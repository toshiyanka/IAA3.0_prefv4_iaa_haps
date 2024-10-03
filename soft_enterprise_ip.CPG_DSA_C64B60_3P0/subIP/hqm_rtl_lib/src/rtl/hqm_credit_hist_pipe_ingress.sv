//-----------------------------------------------------------------------------------------------------
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
// hqm_credit_hist_pipe_ingress
//
//
//-----------------------------------------------------------------------------------------------------

module hqm_credit_hist_pipe_ingress 
  import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*;
(
  input	 logic 							hqm_inp_gated_clk
, input  logic							hqm_inp_gated_rst_b
, input	 logic 							hqm_gated_clk
, input  logic							hqm_gated_rst_b
, input  logic							hqm_proc_reset_done


, input  logic [ 15 : 0 ]					master_chp_timestamp
, input  logic                                                  rst_prep

//cfg
, input  logic							cfg_req_idlepipe
, input  logic [ ( 4 ) - 1 : 0 ]				cfg_qed_to_cq_pipe_credit_hwm 
, input  logic							ingress_flid_parity_error_inject_1
, input  logic							ingress_flid_parity_error_inject_0
, input  logic							ingress_error_inject_h0
, input  logic							ingress_error_inject_l0
, input  logic							ingress_error_inject_h1
, input  logic							ingress_error_inject_l1

, input  logic [ ( 1 * 6 * HQM_NUM_DIR_CQ ) - 1 : 0]		hqm_chp_target_cfg_dir_cq2vas_reg_f
, input  logic [ ( 1 * 6 * HQM_NUM_LB_CQ ) - 1 : 0]		hqm_chp_target_cfg_ldb_cq2vas_reg_f
, input  logic [ ( 32 ) - 1 : 0]			        hqm_chp_target_cfg_hw_agitate_control_reg_f
, input  logic [ ( 32 ) - 1 : 0]			        hqm_chp_target_cfg_hw_agitate_select_reg_f

//errors
, output logic							ing_err_hcw_enq_invalid_hcw_cmd
, output logic							ing_err_hcw_enq_user_parity_error
, output logic							ing_err_hcw_enq_data_parity_error
, output logic							ing_err_qed_chp_sch_rx_sync_out_cmd_error
, output logic							ing_err_qed_chp_sch_flid_ret_flid_parity_error
, output logic							ing_err_qed_chp_sch_cq_parity_error
, output logic							ing_err_aqed_chp_sch_cq_parity_error
, output logic							ing_err_qed_chp_sch_vas_parity_error
, output logic							ing_err_aqed_chp_sch_vas_parity_error
, output logic							ing_err_enq_vas_credit_count_residue_error
, output logic							ing_err_sch_vas_credit_count_residue_error

//counter


//smon
, output logic [ ( 4 * 1 ) - 1 : 0 ] 				ing_hqm_chp_target_cfg_chp_smon_smon_v
, output logic [ ( 4 * 32 ) - 1 : 0 ]                           ing_hqm_chp_target_cfg_chp_smon_smon_comp
, output logic [ ( 4 * 32 ) - 1 : 0 ]                           ing_hqm_chp_target_cfg_chp_smon_smon_val

//status
, output aw_fifo_status_t 					hcw_enq_w_rx_sync_status
, output logic [ 6 : 0 ]					hcw_replay_db_status
, output logic [ 6 : 0 ]					atm_ord_db_status
, output aw_fifo_status_t 					qed_chp_sch_rx_sync_status
, output aw_fifo_status_t 					qed_chp_sch_flid_ret_rx_sync_status
, output aw_fifo_status_t 					aqed_chp_sch_rx_sync_status
, output aw_fifo_status_t					fifo_qed_to_cq_status
, output logic							qed_sch_sn_map_mem_pipe_status
, output logic							qed_sch_sn_mem_pipe_status

//idle, clock control
, input  logic							hcw_enq_w_rx_sync_enable 
, output logic							hcw_enq_w_rx_sync_idle
, input  logic							qed_chp_sch_rx_sync_enable 
, output logic							qed_chp_sch_rx_sync_idle
, input  logic							qed_chp_sch_flid_ret_rx_sync_enable 
, output logic							qed_chp_sch_flid_ret_rx_sync_idle
, input  logic							aqed_chp_sch_rx_sync_enable 
, output logic							aqed_chp_sch_rx_sync_idle

, output logic                                                  ing_pipe_idle
, output logic                                                  ing_unit_idle

// top level RFW/SRW , FIFO, RMW, MFIFO
, output logic							hcw_enq_w_rx_sync_mem_we
, output logic [ 3 : 0 ] 					hcw_enq_w_rx_sync_mem_waddr
, output hcw_enq_w_req_t					hcw_enq_w_rx_sync_mem_wdata
, output logic							hcw_enq_w_rx_sync_mem_re
, output logic [ 3 : 0 ]					hcw_enq_w_rx_sync_mem_raddr
, input  hcw_enq_w_req_t					hcw_enq_w_rx_sync_mem_rdata
, output logic                                                  qed_chp_sch_rx_sync_mem_we
, output logic [ 2 : 0 ]                                        qed_chp_sch_rx_sync_mem_waddr
, output qed_chp_sch_t                                          qed_chp_sch_rx_sync_mem_wdata
, output logic                                                  qed_chp_sch_rx_sync_mem_re
, output logic [ 2 : 0 ]                                        qed_chp_sch_rx_sync_mem_raddr
, input  qed_chp_sch_t                                          qed_chp_sch_rx_sync_mem_rdata
, output logic                                                  qed_chp_sch_flid_ret_rx_sync_mem_we
, output logic [ 1 : 0 ]                                        qed_chp_sch_flid_ret_rx_sync_mem_waddr
, output qed_chp_sch_flid_ret_t                                 qed_chp_sch_flid_ret_rx_sync_mem_wdata
, output logic                                                  qed_chp_sch_flid_ret_rx_sync_mem_re
, output logic [ 1 : 0 ]                                        qed_chp_sch_flid_ret_rx_sync_mem_raddr
, input  qed_chp_sch_flid_ret_t                                 qed_chp_sch_flid_ret_rx_sync_mem_rdata
, output logic                                                  aqed_chp_sch_rx_sync_mem_we
, output logic [ 1 : 0 ]                                        aqed_chp_sch_rx_sync_mem_waddr
, output aqed_chp_sch_t                                         aqed_chp_sch_rx_sync_mem_wdata
, output logic                                                  aqed_chp_sch_rx_sync_mem_re
, output logic [ 1 : 0 ]                                        aqed_chp_sch_rx_sync_mem_raddr
, input  aqed_chp_sch_t                                         aqed_chp_sch_rx_sync_mem_rdata

, output logic							func_ord_qid_sn_map_we
, output chp_ord_qid_sn_map_t					func_ord_qid_sn_map_wdata
, output logic [ ( 5 ) - 1 : 0 ]				func_ord_qid_sn_map_waddr
, output logic							func_ord_qid_sn_map_re
, output logic [ ( 5 ) - 1 : 0 ]				func_ord_qid_sn_map_raddr
, input  chp_ord_qid_sn_map_t					func_ord_qid_sn_map_rdata

, output logic 							func_ord_qid_sn_we
, output logic [ ( 5 ) - 1 : 0 ]				func_ord_qid_sn_waddr
, output chp_ord_qid_sn_t					func_ord_qid_sn_wdata
, output logic 							func_ord_qid_sn_re 
, output logic [ ( 5 ) - 1 : 0 ]				func_ord_qid_sn_raddr
, input  chp_ord_qid_sn_t					func_ord_qid_sn_rdata 

, output logic							func_qed_to_cq_fifo_mem_we
, output logic [ ( 3 ) - 1 : 0 ]				func_qed_to_cq_fifo_mem_waddr
, output chp_qed_to_cq_t          				func_qed_to_cq_fifo_mem_wdata
, output logic							func_qed_to_cq_fifo_mem_re
, output logic [ ( 3 ) - 1 : 0 ]				func_qed_to_cq_fifo_mem_raddr
, input  chp_qed_to_cq_t         				func_qed_to_cq_fifo_mem_rdata

, output logic							fifo_qed_to_cq_of
, output logic							fifo_qed_to_cq_uf

// Functional Interface

//input HCW from system, dqed, qed, aqed
, output logic							hcw_enq_w_req_ready 
, input  logic							hcw_enq_w_req_valid 
, input  hcw_enq_w_req_t					hcw_enq_w_req

, output logic							qed_chp_sch_ready
, input  logic							qed_chp_sch_v
, input  qed_chp_sch_t		   				qed_chp_sch_data

, output logic							aqed_chp_sch_ready
, input  logic							aqed_chp_sch_v
, input  aqed_chp_sch_t						aqed_chp_sch_data

//interface to chp_arb, chp_enqpipe, chp_schpipe
, input  logic							hcw_enq_pop
, output logic							hcw_enq_valid
, output chp_pp_info_t						hcw_enq_info
, output chp_pp_data_t						hcw_enq_data

, input  logic							hcw_replay_pop
, output logic							hcw_replay_valid
, output chp_hcw_replay_data_t					hcw_replay_data

, input  logic							qed_sch_pop
, output logic							qed_sch_valid
, output chp_qed_to_cq_t					qed_sch_data

, input  logic							aqed_sch_pop
, output logic							aqed_sch_valid
, output aqed_chp_sch_t						aqed_sch_data

, output logic [ ( 8 ) - 1 : 0 ]				qed_to_cq_pipe_credit_status

, input  chp_credit_count_t    				 	ing_enq_vas_credit_count_rdata	
, output logic							ing_enq_vas_credit_count_we 
, output logic [ ( 5 ) - 1 : 0 ]			 	ing_enq_vas_credit_count_addr 	
, output chp_credit_count_t				 	ing_enq_vas_credit_count_wdata	

, input  chp_credit_count_t    				 	ing_sch_vas_credit_count_rdata	
, output logic							ing_sch_vas_credit_count_we 
, output logic [ ( 5 ) - 1 : 0 ]			 	ing_sch_vas_credit_count_addr 	
, output chp_credit_count_t				 	ing_sch_vas_credit_count_wdata	

, output logic							ing_freelist_push_v
, output chp_flid_t						ing_freelist_push_data
 
, output logic							ingress_flid_parity_error_inject_1_done_set
, output logic							ingress_flid_parity_error_inject_0_done_set
, output logic							ingress_error_inject_h0_done_set
, output logic							ingress_error_inject_l0_done_set
, output logic							ingress_error_inject_h1_done_set
, output logic							ingress_error_inject_l1_done_set

, output logic						 	hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc	
) ;

logic								hcw_enq_w_rx_sync_in_ready ;
logic								hcw_enq_w_rx_sync_in_valid ;
hcw_enq_w_req_t							hcw_enq_w_rx_sync_in_data ;
logic								hcw_enq_w_rx_sync_out_ready ;
logic								hcw_enq_w_rx_sync_out_valid ;
hcw_enq_w_req_t							hcw_enq_w_rx_sync_out_data ;
logic								hcw_enq_w_rx_sync_out_invalid_hcw_cmd ;
hcw_cmd_dec_t							hcw_enq_w_rx_sync_out_data_hcw_cmd ;
logic								hcw_enq_w_rx_sync_out_to_rop_enq ;

logic 								hcw_enq_valid_nxt ;
logic 								hcw_enq_valid_f ;
chp_pp_info_t							hcw_enq_info_nxt ;
chp_pp_info_t							hcw_enq_info_f ;
chp_pp_data_t							hcw_enq_data_nxt ;
chp_pp_data_t							hcw_enq_data_f ;

logic 					 			enq_vas_credit_count_residue_check ;
logic [ 1 : 0 ]							enq_vas_credit_count_residue_m1 ;
logic								enq_vas_out_of_credit ;

logic								qed_chp_sch_rx_sync_in_ready ;
logic								qed_chp_sch_rx_sync_in_valid ;
qed_chp_sch_t							qed_chp_sch_rx_sync_in_data ;
logic								qed_chp_sch_rx_sync_out_ready ;
logic								qed_chp_sch_rx_sync_out_valid ;
qed_chp_sch_t							qed_chp_sch_rx_sync_out_data ;
logic	 							qed_chp_sch_rx_sync_out_ordered ;
logic	 							qed_sch_data_cq_parity ;

logic								qed_chp_sch_flid_ret_rx_sync_in_ready ;
logic								qed_chp_sch_flid_ret_rx_sync_in_valid ;
qed_chp_sch_flid_ret_t						qed_chp_sch_flid_ret_rx_sync_in_data ;
logic								qed_chp_sch_flid_ret_rx_sync_out_ready ;
logic								qed_chp_sch_flid_ret_rx_sync_out_valid ;
qed_chp_sch_flid_ret_t						qed_chp_sch_flid_ret_rx_sync_out_data ;

logic								qed_chp_sch_flid_ret_v_set ;
logic								qed_chp_sch_flid_ret_v_nxt ;
logic								qed_chp_sch_flid_ret_v_f ;
qed_chp_sch_flid_ret_t						qed_chp_sch_flid_ret_nxt ;
qed_chp_sch_flid_ret_t						qed_chp_sch_flid_ret_f ;
logic 								qed_chp_sch_flid_ret_flid_parity_check_enable ;
logic 								qed_chp_sch_flid_ret_flid_parity_check_odd ;
logic								qed_chp_sch_flid_ret_flid_parity_error_nxt ;
logic								qed_chp_sch_flid_ret_flid_parity_error_f ;

logic 								qed_chp_sch_vas_parity_check_enable ;
logic 								qed_chp_sch_vas_parity_check_odd ;
logic [ 4 : 0 ]							qed_chp_sch_vas ;
logic 	 							qed_chp_sch_vas_parity ;
logic 	 							qed_chp_sch_vas_parity_error ;
logic 	 							qed_chp_sch_cq_parity_error ;

logic 								aqed_chp_sch_vas_parity_check_enable ;
logic 								aqed_chp_sch_vas_parity_check_odd ;
logic [ 4 : 0 ]							aqed_chp_sch_vas ;
logic 								aqed_chp_sch_vas_parity ;
logic 								aqed_chp_sch_vas_parity_error ;
logic 	 							aqed_chp_sch_cq_parity_error ;

logic [ 1 : 0 ] 						sch_vas_credit_count_residue_p1 ;

logic								aqed_chp_sch_rx_sync_in_ready ;
logic								aqed_chp_sch_rx_sync_in_valid ;
aqed_chp_sch_t							aqed_chp_sch_rx_sync_in_data ;
logic								aqed_chp_sch_rx_sync_out_ready ;
logic								aqed_chp_sch_rx_sync_out_valid ;
aqed_chp_sch_t							aqed_chp_sch_rx_sync_out_data ;
logic	 							aqed_sch_data_cq_parity ;

logic								hcw_enq_user_parity_check_enable ;
logic								hcw_enq_user_parity_check_odd ;
logic								hcw_enq_data_parity_check_enable ;
logic								hcw_enq_data_parity_check_odd_1 ;
logic								hcw_enq_data_parity_check_odd_0 ;
logic								ing_err_hcw_enq_data_parity_error_1 ;
logic								ing_err_hcw_enq_data_parity_error_0 ;
logic								hcw_enq_hcw_cmd_parity_gen_odd ;
logic								hcw_enq_hcw_cmd_parity ;

logic [ 1 : 0 ]							atm_ord_qed_arb_reqs ;
logic								atm_ord_qed_arb_update ;
logic								atm_ord_qed_arb_winner_v ;
logic								atm_ord_qed_arb_winner ;

logic								atm_ord_db_in_ready ;
logic								atm_ord_db_in_valid ;
aqed_chp_sch_t     		 				atm_ord_db_in_data ;
logic								atm_ord_db_out_ready ;
logic								atm_ord_db_out_valid ;
aqed_chp_sch_t							atm_ord_db_out_data ;

logic								hcw_replay_db_in_ready ;
logic								hcw_replay_db_in_valid ;
chp_hcw_replay_data_t						hcw_replay_db_in_data ;
logic								hcw_replay_db_out_ready ;
logic								hcw_replay_db_out_valid ;
chp_hcw_replay_data_t						hcw_replay_db_out_data ;

logic							 	p0_qed_sch_v_nxt , p0_qed_sch_v_f ;
logic							 	p1_qed_sch_v_nxt , p1_qed_sch_v_f ;
logic							 	p2_qed_sch_v_nxt , p2_qed_sch_v_f ;
qed_chp_sch_t							p0_qed_sch_nxt , p0_qed_sch_f ;
qed_chp_sch_t							p1_qed_sch_nxt , p1_qed_sch_f ;
qed_chp_sch_t							p2_qed_sch_nxt , p2_qed_sch_f ;
logic [ 9 : 0 ]							p2_qid_sn_size_mask ;
logic 								p2_qed_sch_sn_wrap ;
logic [ 3 : 0 ]							p2_qid_sn_mode_slot_shift_amount ;
logic [ 9 : 0 ]							p2_qid_sn_slot_scaled ;
logic [ 9 : 0 ]							p2_qid_slot_base ;
logic [ 9 : 0 ]							p2_qid_slot_sn ;
logic 								qed_sch_sn_mem_p2_data_residue_check ;
logic 								qed_sch_sn_mem_p2_data_residue_error ;
logic [ 1 : 0 ]							qed_sch_sn_mem_p2_data_residue_p1 ;

logic								qed_sch_sn_map_mem_p0_hold_tlow ;
logic	 							qed_sch_sn_map_mem_p0_v_nxt, qed_sch_sn_map_mem_p0_v_f_nc ;
aw_rwpipe_cmd_t							qed_sch_sn_map_mem_p0_rw_nxt , qed_sch_sn_map_mem_p0_rw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_map_mem_p0_addr_nxt, qed_sch_sn_map_mem_p0_addr_f_nc ;
chp_ord_qid_sn_map_t						qed_sch_sn_map_mem_p0_data_tlow_nxt , qed_sch_sn_map_mem_p0_data_f_nc ;
logic								qed_sch_sn_map_mem_p1_hold_tlow ;
logic    							qed_sch_sn_map_mem_p1_v_f_nc ;
aw_rwpipe_cmd_t							qed_sch_sn_map_mem_p1_rw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_map_mem_p1_addr_f_nc ;
chp_ord_qid_sn_map_t						qed_sch_sn_map_mem_p1_data_f_nc ;
logic								qed_sch_sn_map_mem_p2_hold_tlow ;
logic     							qed_sch_sn_map_mem_p2_v_f_nc ;
aw_rwpipe_cmd_t							qed_sch_sn_map_mem_p2_rw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_map_mem_p2_addr_f_nc ;
chp_ord_qid_sn_map_t						qed_sch_sn_map_mem_p2_data_f ;
logic								qed_sch_sn_map_mem_p3_hold_tlow ;
logic	 							qed_sch_sn_map_mem_p3_v_f_nc ;
aw_rwpipe_cmd_t							qed_sch_sn_map_mem_p3_rw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_map_mem_p3_addr_f_nc ;
chp_ord_qid_sn_map_t						qed_sch_sn_map_mem_p3_data_f_nc ;

logic	 							qed_sch_sn_mem_p0_hold_tlow ;
logic	 							qed_sch_sn_mem_p0_v_nxt, qed_sch_sn_mem_p0_v_f_nc ;
aw_rmwpipe_cmd_t						qed_sch_sn_mem_p0_rmw_nxt , qed_sch_sn_mem_p0_rmw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_mem_p0_addr_nxt , qed_sch_sn_mem_p0_addr_f_nc ;
chp_ord_qid_sn_t						qed_sch_sn_mem_p0_data_tlow_nxt , qed_sch_sn_mem_p0_data_f_nc ;
logic	 							qed_sch_sn_mem_p1_hold_tlow ;
logic	 							qed_sch_sn_mem_p1_v_f_nc ;
aw_rmwpipe_cmd_t						qed_sch_sn_mem_p1_rmw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_mem_p1_addr_f_nc ;
chp_ord_qid_sn_t						qed_sch_sn_mem_p1_data_f_nc ;
logic	 							qed_sch_sn_mem_p2_hold_tlow ;
logic	 							qed_sch_sn_mem_p2_v_f_nc ;
aw_rmwpipe_cmd_t						qed_sch_sn_mem_p2_rmw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_mem_p2_addr_f_nc ;
chp_ord_qid_sn_t						qed_sch_sn_mem_p2_data_f ;
logic								qed_sch_sn_mem_p3_bypsel_nxt ;
chp_ord_qid_sn_t						qed_sch_sn_mem_p3_bypdata_nxt ;
logic	 							qed_sch_sn_mem_p3_hold_tlow ;
logic	 							qed_sch_sn_mem_p3_v_f_nc ;
aw_rmwpipe_cmd_t						qed_sch_sn_mem_p3_rmw_f_nc ;
logic [ 4 : 0 ]							qed_sch_sn_mem_p3_addr_f_nc ;
chp_ord_qid_sn_t						qed_sch_sn_mem_p3_data_f_nc ;

logic 								fifo_qed_to_cq_full_nc ;
logic								fifo_qed_to_cq_afull_nc ;
logic								fifo_qed_to_cq_push ;
chp_qed_to_cq_t							fifo_qed_to_cq_push_data ;
logic								fifo_qed_to_cq_pop ;
logic								fifo_qed_to_cq_pop_data_v ;
chp_qed_to_cq_t							fifo_qed_to_cq_pop_data ;

logic 								qed_to_cq_pipe_credit_alloc ;
logic 								qed_to_cq_pipe_credit_dealloc ;
logic 								qed_to_cq_pipe_credit_empty ;
logic 								qed_to_cq_pipe_credit_full ;
logic [ HQM_CHP_QED_TO_CQ_FIFO_WMWIDTH - 1 : 0 ]		qed_to_cq_pipe_credit_size ;
logic 								qed_to_cq_pipe_credit_error ;
logic 								qed_to_cq_pipe_credit_afull ;

logic [ 15 : 0 ]						hcw_enq_data_cq_hcw_ecc ;

cq_hcw_t							hcw_enq_data_cq_hcw ;

logic								hcw_enq_w_rx_sync_out_data_user_parity ; 

logic								ing_sch_vas_credit_count_we_nxt ;
logic								ing_sch_vas_credit_count_we_f ;
logic [ ( 5 ) - 1 : 0 ]					 	ing_sch_vas_credit_count_addr_nxt ; 	
logic [ ( 5 ) - 1 : 0 ]					 	ing_sch_vas_credit_count_addr_f ; 	

assign qed_to_cq_pipe_credit_status = { qed_to_cq_pipe_credit_size
                                      , qed_to_cq_pipe_credit_empty
                                      , qed_to_cq_pipe_credit_full
                                      , qed_to_cq_pipe_credit_afull
                                      , qed_to_cq_pipe_credit_error
                                      } ;
assign ing_pipe_idle = ( ( ~ p0_qed_sch_v_f )
                       & ( ~ p1_qed_sch_v_f )
                       & ( ~ p2_qed_sch_v_f )
                       & ( ~ ing_freelist_push_v )
                       ) ;
assign ing_unit_idle = ( ( ing_pipe_idle )
                       & ( hcw_enq_w_rx_sync_idle )
                       & ( qed_chp_sch_flid_ret_rx_sync_idle )
                       & ( qed_chp_sch_rx_sync_idle )
                       & ( aqed_chp_sch_rx_sync_idle )
                       & ( ~ fifo_qed_to_cq_pop_data_v )
                       & ( hcw_replay_db_status [ 1 : 0 ] == 2'd0 )
                       & ( atm_ord_db_status [ 1 : 0 ] == 2'd0 )
                       ) ;

assign ing_sch_vas_credit_count_we = ing_sch_vas_credit_count_we_f ;
assign ing_sch_vas_credit_count_addr = ing_sch_vas_credit_count_addr_f ;
assign ing_err_qed_chp_sch_cq_parity_error = qed_chp_sch_cq_parity_error ;
assign ing_err_aqed_chp_sch_cq_parity_error = aqed_chp_sch_cq_parity_error ;
assign ing_err_qed_chp_sch_vas_parity_error = qed_chp_sch_vas_parity_error ;
assign ing_err_aqed_chp_sch_vas_parity_error = aqed_chp_sch_vas_parity_error ;

assign ing_err_hcw_enq_invalid_hcw_cmd = hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_invalid_hcw_cmd ; 
assign hcw_enq_w_req_ready = hcw_enq_w_rx_sync_in_ready ;
assign hcw_enq_w_rx_sync_out_ready = ~ hcw_enq_valid_f | hcw_enq_pop | hcw_enq_w_rx_sync_out_invalid_hcw_cmd ;
assign hcw_enq_w_rx_sync_in_valid = hcw_enq_w_req_valid & hqm_proc_reset_done ;
assign hcw_enq_w_rx_sync_in_data = hcw_enq_w_req ;

assign hcw_enq_user_parity_check_enable = hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_ready ;
assign hcw_enq_user_parity_check_odd = 1'd1 ;
assign hcw_enq_data_parity_check_enable = hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_ready ;
assign hcw_enq_data_parity_check_odd_1 = ~ ingress_error_inject_h0 ;
assign hcw_enq_data_parity_check_odd_0 = ~ ingress_error_inject_l0 ;
assign ing_err_hcw_enq_data_parity_error = ing_err_hcw_enq_data_parity_error_1 | ing_err_hcw_enq_data_parity_error_0 ;
assign hcw_enq_hcw_cmd_parity_gen_odd = 1'd1 ;

assign hcw_enq_valid = hcw_enq_valid_f ;
assign hcw_enq_data = hcw_enq_data_f ;
assign hcw_enq_info = hcw_enq_info_f ;

assign enq_vas_credit_count_residue_check = hcw_enq_w_rx_sync_out_ready & hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_to_rop_enq ;
assign enq_vas_out_of_credit = enq_vas_credit_count_residue_check & ( ing_enq_vas_credit_count_rdata.count == 'd0 ) ;

assign atm_ord_db_in_valid = aqed_chp_sch_rx_sync_out_valid & aqed_chp_sch_rx_sync_out_data.cq_hcw.ao_v ; 

assign hcw_replay_db_in_valid = qed_chp_sch_rx_sync_out_valid & ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_REPLAY ) ;

assign hcw_replay_valid = hcw_replay_db_out_valid ;
assign hcw_replay_data = hcw_replay_db_out_data ;
assign hcw_replay_db_out_ready = hcw_replay_pop ;

assign qed_chp_sch_ready = qed_chp_sch_rx_sync_in_ready & qed_chp_sch_flid_ret_rx_sync_in_ready ;

assign qed_chp_sch_rx_sync_in_valid = qed_chp_sch_v & qed_chp_sch_flid_ret_rx_sync_in_ready ;
assign qed_chp_sch_rx_sync_in_data = qed_chp_sch_data ;
// unconditionally pop the illegal cmd from qed, report the error and drop the request
assign qed_chp_sch_rx_sync_out_ready = (qed_chp_sch_rx_sync_out_valid & ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_SCHED )) ? atm_ord_qed_arb_winner_v & atm_ord_qed_arb_winner : 
                                       ((qed_chp_sch_rx_sync_out_valid & ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_REPLAY )) ? hcw_replay_db_in_ready :
                                       1'd1 );
assign ing_err_qed_chp_sch_rx_sync_out_cmd_error = qed_chp_sch_rx_sync_out_valid & ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_ILL0 ) ;
assign hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc = qed_chp_sch_rx_sync_out_valid & ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_TRANSFER ) ;

assign qed_sch_data_cq_parity = ^ { 1'b1
                                  , ( ^ { qed_sch_data.qed_chp_sch_data.qidix
                                        , qed_sch_data.qed_chp_sch_data.hqm_core_flags.pad_ok
                                        , qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb
                                        , qed_sch_data.qed_chp_sch_data.hqm_core_flags.congestion_management [ 1 : 0 ]
                                        , qed_sch_data.qed_chp_sch_data.hqm_core_flags.write_buffer_optimization [ 1 : 0 ]
                                        , qed_sch_data.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth
                                        } )
                                  , qed_sch_data.qed_chp_sch_data.hqm_core_flags.parity
                                  , qed_sch_data.qed_chp_sch_data.parity } ;

assign aqed_sch_data_cq_parity = ^ { 1'b1
                                   , ( ^ { aqed_sch_data.qidix
                                         , aqed_sch_data.qid
                                         , aqed_sch_data.hqm_core_flags.pad_ok
                                         , aqed_sch_data.hqm_core_flags.cq_is_ldb
                                         , aqed_sch_data.hqm_core_flags.congestion_management [ 1 : 0 ]
                                         , aqed_sch_data.hqm_core_flags.write_buffer_optimization [ 1 : 0 ]
                                         , aqed_sch_data.hqm_core_flags.ignore_cq_depth
                                         } )
                                   , aqed_sch_data.hqm_core_flags.parity
                                   , aqed_sch_data.parity } ;

assign qed_sch_valid = fifo_qed_to_cq_pop_data_v ;

assign fifo_qed_to_cq_pop = qed_sch_pop ;
assign qed_to_cq_pipe_credit_dealloc = fifo_qed_to_cq_pop ;

assign qed_chp_sch_flid_ret_rx_sync_in_valid = qed_chp_sch_v & ( ( qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) | ( qed_chp_sch_data.cmd == QED_CHP_SCH_TRANSFER ) ) &
                                               qed_chp_sch_rx_sync_in_ready ;
assign qed_chp_sch_flid_ret_rx_sync_in_data = { 10'd0 
                                              , qed_chp_sch_data.flid_parity
                                              , qed_chp_sch_data.flid 
                                              } ;
assign qed_chp_sch_flid_ret_rx_sync_out_ready = ~ cfg_req_idlepipe ;

assign aqed_chp_sch_ready = aqed_chp_sch_rx_sync_in_ready ;
assign aqed_chp_sch_rx_sync_in_valid = aqed_chp_sch_v ;
assign aqed_chp_sch_rx_sync_in_data = aqed_chp_sch_data ;
assign aqed_chp_sch_rx_sync_out_ready = aqed_chp_sch_rx_sync_out_data.cq_hcw.ao_v ? atm_ord_db_in_ready : aqed_sch_pop ;
assign aqed_sch_valid = aqed_chp_sch_rx_sync_out_valid & ~ aqed_chp_sch_rx_sync_out_data.cq_hcw.ao_v ;

assign qed_sch_sn_mem_p2_data_residue_check = 1'd1 ;

assign qed_sch_sn_map_mem_p0_data_tlow_nxt = 'd0 ;
assign qed_sch_sn_map_mem_p0_hold_tlow = 1'd0 ;
assign qed_sch_sn_map_mem_p1_hold_tlow = 1'd0 ;
assign qed_sch_sn_map_mem_p2_hold_tlow = 1'd0 ;
assign qed_sch_sn_map_mem_p3_hold_tlow = 1'd0 ;
assign qed_sch_sn_mem_p0_data_tlow_nxt = 'd0 ;
assign qed_sch_sn_mem_p0_hold_tlow = 1'd0 ;
assign qed_sch_sn_mem_p1_hold_tlow = 1'd0 ;
assign qed_sch_sn_mem_p2_hold_tlow = 1'd0 ;
assign qed_sch_sn_mem_p3_hold_tlow = 1'd0 ;

assign fifo_qed_to_cq_of = fifo_qed_to_cq_status [ 1 ] ;
assign fifo_qed_to_cq_uf = fifo_qed_to_cq_status [ 0 ] ;

assign ingress_error_inject_h0_done_set = ingress_error_inject_h0 & hcw_enq_valid & hcw_enq_pop ;
assign ingress_error_inject_l0_done_set = ingress_error_inject_l0 & hcw_enq_valid & hcw_enq_pop ;
assign ingress_error_inject_h1_done_set = ingress_error_inject_h1 & hcw_enq_valid & hcw_enq_pop ;
assign ingress_error_inject_l1_done_set = ingress_error_inject_l1 & hcw_enq_valid & hcw_enq_pop ;

assign hcw_enq_w_rx_sync_out_data_user_parity = hcw_enq_w_rx_sync_out_data.user.parity ^ ( ingress_error_inject_h1 | ingress_error_inject_l1 ) ; 

assign ing_err_qed_chp_sch_flid_ret_flid_parity_error = qed_chp_sch_flid_ret_flid_parity_error_f ;
 
hqm_AW_rx_sync_wagitate # (
  .DEPTH 					( 16 )
, .WIDTH 					( $bits ( hcw_enq_w_req_t ) )
, .WREG						( 1 )
, .SEED                                         ( 32'h0f )

) i_hcw_enq_w_rx_sync (
  .hqm_inp_gated_clk				( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n				( hqm_inp_gated_rst_b )
, .status					( hcw_enq_w_rx_sync_status )
, .enable					( hcw_enq_w_rx_sync_enable )
, .idle						( hcw_enq_w_rx_sync_idle )
, .rst_prep                                     ( rst_prep )
, .in_ready					( hcw_enq_w_rx_sync_in_ready )
, .in_valid					( hcw_enq_w_rx_sync_in_valid )
, .in_data					( hcw_enq_w_rx_sync_in_data )
, .out_ready					( hcw_enq_w_rx_sync_out_ready )
, .out_valid					( hcw_enq_w_rx_sync_out_valid )
, .out_data					( hcw_enq_w_rx_sync_out_data )
, .mem_we 					( hcw_enq_w_rx_sync_mem_we )
, .mem_waddr					( hcw_enq_w_rx_sync_mem_waddr )
, .mem_wdata					( hcw_enq_w_rx_sync_mem_wdata )
, .mem_re					( hcw_enq_w_rx_sync_mem_re )
, .mem_raddr					( hcw_enq_w_rx_sync_mem_raddr )
, .mem_rdata					( hcw_enq_w_rx_sync_mem_rdata )

, .agit_enable                                  ( hqm_chp_target_cfg_hw_agitate_select_reg_f [0] )
, .agit_control                                 ( hqm_chp_target_cfg_hw_agitate_control_reg_f )
) ;

hqm_AW_rx_sync_wagitate # (
  .DEPTH 					( 4 )
, .WIDTH 					( $bits ( qed_chp_sch_flid_ret_t ) )
, .WREG						( 0 )
, .SEED                                         ( 32'h4b )
) i_qed_chp_sch_flid_ret_rx_sync (
  .hqm_inp_gated_clk				( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n				( hqm_inp_gated_rst_b )
, .status					( qed_chp_sch_flid_ret_rx_sync_status )
, .enable					( qed_chp_sch_flid_ret_rx_sync_enable )
, .idle						( qed_chp_sch_flid_ret_rx_sync_idle )
, .rst_prep                                     ( rst_prep )
, .in_ready					( qed_chp_sch_flid_ret_rx_sync_in_ready )
, .in_valid					( qed_chp_sch_flid_ret_rx_sync_in_valid )
, .in_data					( qed_chp_sch_flid_ret_rx_sync_in_data )
, .out_ready					( qed_chp_sch_flid_ret_rx_sync_out_ready )	
, .out_valid					( qed_chp_sch_flid_ret_rx_sync_out_valid )
, .out_data					( qed_chp_sch_flid_ret_rx_sync_out_data )
, .mem_we 					( qed_chp_sch_flid_ret_rx_sync_mem_we )
, .mem_waddr					( qed_chp_sch_flid_ret_rx_sync_mem_waddr )
, .mem_wdata					( qed_chp_sch_flid_ret_rx_sync_mem_wdata )
, .mem_re					( qed_chp_sch_flid_ret_rx_sync_mem_re )
, .mem_raddr					( qed_chp_sch_flid_ret_rx_sync_mem_raddr )
, .mem_rdata					( qed_chp_sch_flid_ret_rx_sync_mem_rdata )

, .agit_enable                                  ( 1'd0 )	// can't agitate this since this can't be backpressured
, .agit_control                                 ( hqm_chp_target_cfg_hw_agitate_control_reg_f )
) ;

hqm_AW_rx_sync_wagitate # (
  .DEPTH 					( 8 )
, .WIDTH 					( $bits ( qed_chp_sch_t ) )
, .WREG						( 0 )
, .SEED                                         ( 32'h3c )
) i_qed_chp_sch_rx_sync (
  .hqm_inp_gated_clk				( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n				( hqm_inp_gated_rst_b )
, .status					( qed_chp_sch_rx_sync_status )
, .enable					( qed_chp_sch_rx_sync_enable )
, .idle						( qed_chp_sch_rx_sync_idle )
, .rst_prep                                     ( rst_prep )
, .in_ready					( qed_chp_sch_rx_sync_in_ready )
, .in_valid					( qed_chp_sch_rx_sync_in_valid )
, .in_data					( qed_chp_sch_rx_sync_in_data )
, .out_ready					( qed_chp_sch_rx_sync_out_ready )
, .out_valid					( qed_chp_sch_rx_sync_out_valid )
, .out_data					( qed_chp_sch_rx_sync_out_data )
, .mem_we 					( qed_chp_sch_rx_sync_mem_we )
, .mem_waddr					( qed_chp_sch_rx_sync_mem_waddr )
, .mem_wdata					( qed_chp_sch_rx_sync_mem_wdata )
, .mem_re					( qed_chp_sch_rx_sync_mem_re )
, .mem_raddr					( qed_chp_sch_rx_sync_mem_raddr )
, .mem_rdata					( qed_chp_sch_rx_sync_mem_rdata )

, .agit_enable                                  ( hqm_chp_target_cfg_hw_agitate_select_reg_f [3] )
, .agit_control                                 ( hqm_chp_target_cfg_hw_agitate_control_reg_f )
) ;

hqm_AW_rx_sync_wagitate # (
  .DEPTH 					( 4 )
, .WIDTH					( $bits ( aqed_chp_sch_t ) )
, .WREG						( 1 )
, .SEED                                         ( 32'h5a )
) i_aqed_chp_sch_rx_sync (
  .hqm_inp_gated_clk				( hqm_inp_gated_clk )
, .hqm_inp_gated_rst_n				( hqm_inp_gated_rst_b )
, .status					( aqed_chp_sch_rx_sync_status )
, .enable					( aqed_chp_sch_rx_sync_enable )
, .idle						( aqed_chp_sch_rx_sync_idle )
, .rst_prep                                     ( rst_prep )
, .in_ready					( aqed_chp_sch_rx_sync_in_ready )
, .in_valid					( aqed_chp_sch_rx_sync_in_valid )
, .in_data					( aqed_chp_sch_rx_sync_in_data )
, .out_ready					( aqed_chp_sch_rx_sync_out_ready )
, .out_valid					( aqed_chp_sch_rx_sync_out_valid )
, .out_data					( aqed_chp_sch_rx_sync_out_data )
, .mem_we 					( aqed_chp_sch_rx_sync_mem_we )
, .mem_waddr					( aqed_chp_sch_rx_sync_mem_waddr )
, .mem_wdata					( aqed_chp_sch_rx_sync_mem_wdata )
, .mem_re					( aqed_chp_sch_rx_sync_mem_re )
, .mem_raddr					( aqed_chp_sch_rx_sync_mem_raddr )
, .mem_rdata					( aqed_chp_sch_rx_sync_mem_rdata )

, .agit_enable                                  ( hqm_chp_target_cfg_hw_agitate_select_reg_f [5] )
, .agit_control                                 ( hqm_chp_target_cfg_hw_agitate_control_reg_f )
) ;

hqm_AW_rr_arb #(
  .NUM_REQS					( 2 )
) i_atm_ord_qed_arb (
  .clk						( hqm_gated_clk )
, .rst_n					( hqm_gated_rst_b )
, .reqs						( atm_ord_qed_arb_reqs )
, .update					( atm_ord_qed_arb_update )
, .winner_v					( atm_ord_qed_arb_winner_v )
, .winner					( atm_ord_qed_arb_winner )
) ;

hqm_AW_double_buffer # (
  .WIDTH					( $bits ( atm_ord_db_in_data ) )
) i_atm_ord_db (
  .clk						( hqm_gated_clk )
, .rst_n					( hqm_gated_rst_b )
, .status					( atm_ord_db_status )
, .in_ready					( atm_ord_db_in_ready )
, .in_valid					( atm_ord_db_in_valid )
, .in_data					( atm_ord_db_in_data )
, .out_ready					( atm_ord_db_out_ready )
, .out_valid					( atm_ord_db_out_valid )
, .out_data					( atm_ord_db_out_data )
) ;

hqm_AW_double_buffer # (
  .WIDTH					( $bits ( hcw_replay_db_in_data ) )
) i_hcw_replay_db (
  .clk						( hqm_gated_clk )
, .rst_n					( hqm_gated_rst_b )
, .status					( hcw_replay_db_status )
, .in_ready					( hcw_replay_db_in_ready )
, .in_valid					( hcw_replay_db_in_valid )
, .in_data					( hcw_replay_db_in_data )
, .out_ready					( hcw_replay_db_out_ready )
, .out_valid					( hcw_replay_db_out_valid )
, .out_data					( hcw_replay_db_out_data )
) ;

hqm_AW_parity_check # (
  .WIDTH							( 5 + 8 + 8 + 1 + 1 + 1 + 1 )
) i_hcw_enq_user_parity_check (
  .p								( hcw_enq_w_rx_sync_out_data_user_parity )
, .d								( { hcw_enq_w_rx_sync_out_data.user.vas
								  , hcw_enq_w_rx_sync_out_data.user.pp 
								  , hcw_enq_w_rx_sync_out_data.user.qid
								  , hcw_enq_w_rx_sync_out_data.user.pp_is_ldb
								  , hcw_enq_w_rx_sync_out_data.user.qe_is_ldb
								  , hcw_enq_w_rx_sync_out_data.user.insert_timestamp
								  , hcw_enq_w_rx_sync_out_data.user.ao_v
								  } )
, .e								( hcw_enq_user_parity_check_enable )
, .odd								( hcw_enq_user_parity_check_odd )
, .err								( ing_err_hcw_enq_user_parity_error )
) ;

hqm_AW_parity_check # (
  .WIDTH							( 64 )
) i_hcw_enq_data_parity_check_1 (
  .p								( hcw_enq_w_rx_sync_out_data.user.hcw_parity [ 1 ] )
, .d								( hcw_enq_w_rx_sync_out_data.data [ 127 : 64 ] )
, .e								( hcw_enq_data_parity_check_enable )
, .odd								( hcw_enq_data_parity_check_odd_1 )
, .err								( ing_err_hcw_enq_data_parity_error_1 )
) ;

hqm_AW_parity_check # (
  .WIDTH							( 64 )
) i_hcw_enq_data_parity_check_0 (
  .p								( hcw_enq_w_rx_sync_out_data.user.hcw_parity [ 0 ] )
, .d								( hcw_enq_w_rx_sync_out_data.data [ 63 : 0 ] )
, .e								( hcw_enq_data_parity_check_enable )
, .odd								( hcw_enq_data_parity_check_odd_0 )
, .err								( ing_err_hcw_enq_data_parity_error_0 )
) ;

hqm_AW_parity_gen # (
  .WIDTH							( 4 )
) i_hcw_enq_hcw_cmd_parity_gen (
  .d								( hcw_enq_w_rx_sync_out_data_hcw_cmd )
, .odd								( hcw_enq_hcw_cmd_parity_gen_odd )
, .p								( hcw_enq_hcw_cmd_parity )
) ;

hqm_AW_ecc_gen # (
  .DATA_WIDTH							( 59 )
, .ECC_WIDTH							( 8 )
) i_hcw_enq_data_cq_hcw_ecc_gen_1 (
  .d								( hcw_enq_data_cq_hcw [ 122 : 64 ] )
, .ecc								( hcw_enq_data_cq_hcw_ecc [ 15 : 8 ] )
) ;

hqm_AW_ecc_gen # (
  .DATA_WIDTH							( 64 )
, .ECC_WIDTH							( 8 )
) i_hcw_enq_data_cq_hcw_ecc_gen_0 (
  .d								( hcw_enq_data_cq_hcw [ 63 : 0 ] )
, .ecc								( hcw_enq_data_cq_hcw_ecc [ 7 : 0 ] )
) ;

hqm_AW_residue_check #(
  .WIDTH							( 10 )
) i_qed_sch_sn_residue_check (
  .r								( qed_sch_sn_mem_p2_data_f.residue )
, .d								( qed_sch_sn_mem_p2_data_f.sn )
, .e								( qed_sch_sn_mem_p2_data_residue_check )
, .err								( qed_sch_sn_mem_p2_data_residue_error )
) ;

hqm_AW_parity_check # (
  .WIDTH							( $bits ( qed_chp_sch_flid_ret_nxt.flid ) )
) i_qed_chp_sch_flid_ret_flid_parity_check (
  .p								( qed_chp_sch_flid_ret_nxt.flid_parity )
, .d								( qed_chp_sch_flid_ret_nxt.flid ) 
, .e								( qed_chp_sch_flid_ret_flid_parity_check_enable )
, .odd								( qed_chp_sch_flid_ret_flid_parity_check_odd )
, .err								( qed_chp_sch_flid_ret_flid_parity_error_nxt )
) ;

hqm_AW_parity_check # (
  .WIDTH							( $bits ( qed_chp_sch_vas ) )
) i_qed_chp_sch_vas_parity_check (
  .p								( qed_chp_sch_vas_parity )
, .d								( qed_chp_sch_vas ) 
, .e								( qed_chp_sch_vas_parity_check_enable )
, .odd								( qed_chp_sch_vas_parity_check_odd )
, .err								( qed_chp_sch_vas_parity_error )
) ;

hqm_AW_parity_check # (
  .WIDTH							( $bits ( aqed_chp_sch_vas ) )
) i_aqed_chp_sch_vas_parity_check (
  .p								( aqed_chp_sch_vas_parity )
, .d								( aqed_chp_sch_vas ) 
, .e								( aqed_chp_sch_vas_parity_check_enable )
, .odd								( aqed_chp_sch_vas_parity_check_odd )
, .err								( aqed_chp_sch_vas_parity_error )
) ;

hqm_AW_residue_check #(
  .WIDTH							( $bits ( ing_enq_vas_credit_count_rdata.count ) )
) i_enq_vas_credit_count_residue_check (
  .r								( ing_enq_vas_credit_count_rdata.residue )
, .d								( ing_enq_vas_credit_count_rdata.count )
, .e								( enq_vas_credit_count_residue_check )
, .err								( ing_err_enq_vas_credit_count_residue_error )
) ;

hqm_AW_residue_sub i_enq_vas_credit_count_residue_dec (
  .a 								( 2'b01 )
, .b								( ing_enq_vas_credit_count_rdata.residue )
, .r								( enq_vas_credit_count_residue_m1)
) ;

hqm_AW_residue_check #(
   .WIDTH							( $bits ( ing_sch_vas_credit_count_rdata.count ) )
) i_sch_vas_credit_count_residue_check (
   .r								( ing_sch_vas_credit_count_rdata.residue )
 , .d								( ing_sch_vas_credit_count_rdata.count )
 , .e								( ing_sch_vas_credit_count_we )
 , .err								( ing_err_sch_vas_credit_count_residue_error )
);

hqm_AW_residue_add i_sch_vas_credit_count_residue_add (
   .a								( 2'b01 )
 , .b								( ing_sch_vas_credit_count_rdata.residue )
 , .r								( sch_vas_credit_count_residue_p1 )
);

hqm_AW_residue_add i_qed_sch_sn_mem_p2_dataresidue_p1 (
  .a								( 2'b01 )
, .b								( qed_sch_sn_mem_p2_data_f.residue )
, .r								( qed_sch_sn_mem_p2_data_residue_p1)
) ;

logic [ ( 5 ) - 1 : 0 ] func_ord_qid_sn_map_addr ;
assign func_ord_qid_sn_map_raddr = func_ord_qid_sn_map_addr ;
assign func_ord_qid_sn_map_waddr = func_ord_qid_sn_map_addr ;

hqm_AW_rw_mem_4pipe # (
  .DEPTH							( 32 )
, .WIDTH							( $bits ( chp_ord_qid_sn_map_t ) )
) i_rw_qed_sch_sn_map_mem_pipe (
   .clk								( hqm_gated_clk )
 , .rst_n							( hqm_gated_rst_b )
 , .status							( qed_sch_sn_map_mem_pipe_status )
 , .p0_v_nxt							( qed_sch_sn_map_mem_p0_v_nxt )
 , .p0_rw_nxt							( qed_sch_sn_map_mem_p0_rw_nxt )
 , .p0_addr_nxt							( qed_sch_sn_map_mem_p0_addr_nxt )
 , .p0_write_data_nxt						( qed_sch_sn_map_mem_p0_data_tlow_nxt )
 , .p0_hold							( qed_sch_sn_map_mem_p0_hold_tlow )
 , .p0_v_f							( qed_sch_sn_map_mem_p0_v_f_nc )
 , .p0_rw_f							( qed_sch_sn_map_mem_p0_rw_f_nc )
 , .p0_addr_f							( qed_sch_sn_map_mem_p0_addr_f_nc )
 , .p0_data_f							( qed_sch_sn_map_mem_p0_data_f_nc )
 , .p1_hold							( qed_sch_sn_map_mem_p1_hold_tlow )
 , .p1_v_f							( qed_sch_sn_map_mem_p1_v_f_nc )
 , .p1_rw_f							( qed_sch_sn_map_mem_p1_rw_f_nc )
 , .p1_addr_f							( qed_sch_sn_map_mem_p1_addr_f_nc )
 , .p1_data_f							( qed_sch_sn_map_mem_p1_data_f_nc )
 , .p2_hold							( qed_sch_sn_map_mem_p2_hold_tlow )
 , .p2_v_f							( qed_sch_sn_map_mem_p2_v_f_nc )
 , .p2_rw_f							( qed_sch_sn_map_mem_p2_rw_f_nc )
 , .p2_addr_f							( qed_sch_sn_map_mem_p2_addr_f_nc )
 , .p2_data_f							( qed_sch_sn_map_mem_p2_data_f )
 , .p3_hold							( qed_sch_sn_map_mem_p3_hold_tlow )
 , .p3_v_f							( qed_sch_sn_map_mem_p3_v_f_nc )
 , .p3_rw_f							( qed_sch_sn_map_mem_p3_rw_f_nc )
 , .p3_addr_f							( qed_sch_sn_map_mem_p3_addr_f_nc )
 , .p3_data_f							( qed_sch_sn_map_mem_p3_data_f_nc )
 , .mem_write							( func_ord_qid_sn_map_we )
 , .mem_addr							( func_ord_qid_sn_map_addr )
 , .mem_write_data						( func_ord_qid_sn_map_wdata )
 , .mem_read							( func_ord_qid_sn_map_re )
 , .mem_read_data						( func_ord_qid_sn_map_rdata )
) ;

hqm_AW_rmw_mem_4pipe # (
  .DEPTH							( 32 )
, .WIDTH							( $bits ( chp_ord_qid_sn_t ) )
) i_rw_qed_sch_sn_mem_pipe (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .status							( qed_sch_sn_mem_pipe_status )
, .p0_v_nxt							( qed_sch_sn_mem_p0_v_nxt )
, .p0_rw_nxt							( qed_sch_sn_mem_p0_rmw_nxt )
, .p0_addr_nxt							( qed_sch_sn_mem_p0_addr_nxt )
, .p0_write_data_nxt						( qed_sch_sn_mem_p0_data_tlow_nxt )
, .p0_hold							( qed_sch_sn_mem_p0_hold_tlow )
, .p0_v_f							( qed_sch_sn_mem_p0_v_f_nc )
, .p0_rw_f							( qed_sch_sn_mem_p0_rmw_f_nc )
, .p0_addr_f							( qed_sch_sn_mem_p0_addr_f_nc )
, .p0_data_f							( qed_sch_sn_mem_p0_data_f_nc )
, .p1_hold							( qed_sch_sn_mem_p1_hold_tlow )
, .p1_v_f							( qed_sch_sn_mem_p1_v_f_nc )
, .p1_rw_f							( qed_sch_sn_mem_p1_rmw_f_nc )
, .p1_addr_f							( qed_sch_sn_mem_p1_addr_f_nc )
, .p1_data_f							( qed_sch_sn_mem_p1_data_f_nc )
, .p2_hold							( qed_sch_sn_mem_p2_hold_tlow )
, .p2_v_f							( qed_sch_sn_mem_p2_v_f_nc )
, .p2_rw_f							( qed_sch_sn_mem_p2_rmw_f_nc )
, .p2_addr_f							( qed_sch_sn_mem_p2_addr_f_nc )
, .p2_data_f							( qed_sch_sn_mem_p2_data_f )
, .p3_bypsel_nxt						( qed_sch_sn_mem_p3_bypsel_nxt )
, .p3_bypdata_nxt						( qed_sch_sn_mem_p3_bypdata_nxt )
, .p3_hold							( qed_sch_sn_mem_p3_hold_tlow )
, .p3_v_f							( qed_sch_sn_mem_p3_v_f_nc )
, .p3_rw_f							( qed_sch_sn_mem_p3_rmw_f_nc )
, .p3_addr_f							( qed_sch_sn_mem_p3_addr_f_nc )
, .p3_data_f							( qed_sch_sn_mem_p3_data_f_nc )
, .mem_write							( func_ord_qid_sn_we )
, .mem_write_addr						( func_ord_qid_sn_waddr )
, .mem_write_data						( func_ord_qid_sn_wdata )
, .mem_read							( func_ord_qid_sn_re )
, .mem_read_addr						( func_ord_qid_sn_raddr )
, .mem_read_data						( func_ord_qid_sn_rdata )
) ;

hqm_AW_fifo_control_wreg # (
  .DEPTH							( HQM_CHP_QED_TO_CQ_FIFO_DEPTH )
, .DWIDTH							( $bits ( chp_qed_to_cq_t ) )
) i_fifo_qed_to_cq (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .cfg_high_wm							( HQM_CHP_QED_TO_CQ_FIFO_DEPTH [ 3 : 0 ] )
, .fifo_status							( fifo_qed_to_cq_status )
, .fifo_full							( fifo_qed_to_cq_full_nc )
, .fifo_afull							( fifo_qed_to_cq_afull_nc )
, .push								( fifo_qed_to_cq_push )
, .push_data							( fifo_qed_to_cq_push_data )
, .pop								( fifo_qed_to_cq_pop )
, .pop_data_v							( fifo_qed_to_cq_pop_data_v )
, .pop_data							( fifo_qed_to_cq_pop_data )
, .mem_we							( func_qed_to_cq_fifo_mem_we )
, .mem_waddr							( func_qed_to_cq_fifo_mem_waddr )
, .mem_wdata							( func_qed_to_cq_fifo_mem_wdata )
, .mem_re							( func_qed_to_cq_fifo_mem_re )
, .mem_raddr							( func_qed_to_cq_fifo_mem_raddr )
, .mem_rdata							( func_qed_to_cq_fifo_mem_rdata )
) ;

hqm_AW_control_credits #(
  .DEPTH							( HQM_CHP_QED_TO_CQ_FIFO_DEPTH )
, .NUM_A							( 1 )
, .NUM_D							( 1 )
) i_qed_to_cq_pipe_credit (
  .clk								( hqm_gated_clk )
, .rst_n							( hqm_gated_rst_b )
, .alloc							( qed_to_cq_pipe_credit_alloc )
, .dealloc							( qed_to_cq_pipe_credit_dealloc )
, .empty							( qed_to_cq_pipe_credit_empty )
, .full								( qed_to_cq_pipe_credit_full )
, .size								( qed_to_cq_pipe_credit_size )
, .error							( qed_to_cq_pipe_credit_error )
, .hwm								( cfg_qed_to_cq_pipe_credit_hwm )
, .afull							( qed_to_cq_pipe_credit_afull )
) ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_b ) begin
  if ( ~ hqm_gated_rst_b ) begin
    hcw_enq_valid_f <= 1'd0 ;
    qed_chp_sch_flid_ret_v_f <= 1'd0 ;
    qed_chp_sch_flid_ret_flid_parity_error_f <= 1'd0 ;
    ing_sch_vas_credit_count_we_f <= 1'd0 ;
    p0_qed_sch_v_f <= 1'd0 ;
    p1_qed_sch_v_f <= 1'd0 ;
    p2_qed_sch_v_f <= 1'd0 ;
  end else begin
    hcw_enq_valid_f <= hcw_enq_valid_nxt ;
    qed_chp_sch_flid_ret_v_f <= qed_chp_sch_flid_ret_v_nxt ;
    qed_chp_sch_flid_ret_flid_parity_error_f <= qed_chp_sch_flid_ret_flid_parity_error_nxt ;
    ing_sch_vas_credit_count_we_f <= ing_sch_vas_credit_count_we_nxt ;
    p0_qed_sch_v_f <= p0_qed_sch_v_nxt ;
    p1_qed_sch_v_f <= p1_qed_sch_v_nxt ;
    p2_qed_sch_v_f <= p2_qed_sch_v_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk ) begin
  hcw_enq_data_f <= hcw_enq_data_nxt ;
  hcw_enq_info_f <= hcw_enq_info_nxt ;
  qed_chp_sch_flid_ret_f <= qed_chp_sch_flid_ret_nxt ;
  ing_sch_vas_credit_count_addr_f <= ing_sch_vas_credit_count_addr_nxt ;
  p0_qed_sch_f <= p0_qed_sch_nxt ;
  p1_qed_sch_f <= p1_qed_sch_nxt ;
  p2_qed_sch_f <= p2_qed_sch_nxt ;
end

always_comb begin

  hcw_enq_w_rx_sync_out_invalid_hcw_cmd = hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ? 
                                          ~ ( ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_NOOP ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_BAT_TOK_RET ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_COMP ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_COMP_TOK_RET ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ARM ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_A_COMP ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_A_COMP_TOK_RET ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) :
                                          ~ ( ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_NOOP ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_BAT_TOK_RET ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ARM ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                                              ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) ) ;

  hcw_enq_w_rx_sync_out_to_rop_enq = hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ?
                                     ( ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                                       ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                       ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) |
                                       ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                       ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) |
                                       ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) :
                                     ( ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                                       ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) ) ;

  hcw_enq_w_rx_sync_out_data_hcw_cmd = ing_err_hcw_enq_user_parity_error ? HQM_CMD_NOOP : hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec ;

  hcw_enq_info_nxt = hcw_enq_info_f ;
  hcw_enq_data_nxt = hcw_enq_data_f ;
  hcw_enq_valid_nxt = hcw_enq_valid_f & ~ hcw_enq_pop ;

  if ( hcw_enq_w_rx_sync_out_ready & hcw_enq_w_rx_sync_out_valid ) begin
    hcw_enq_valid_nxt = ~ hcw_enq_w_rx_sync_out_invalid_hcw_cmd ;

    hcw_enq_info_nxt.hcw_enq_user_parity_error_drop		= ing_err_hcw_enq_user_parity_error &
                                                                  ( ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
                                                                    ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                    ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) |
                                                                    ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                                                    ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) |
                                                                    ( hcw_enq_w_rx_sync_out_data.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ;
    hcw_enq_info_nxt.out_of_credit				= enq_vas_out_of_credit ;
    hcw_enq_info_nxt.no_dec					= hcw_enq_w_rx_sync_out_data.data.debug.no_dec ;
    hcw_enq_info_nxt.cmp_id					= hcw_enq_w_rx_sync_out_data.data.debug.cmp_id ;
    hcw_enq_info_nxt.ao_v					= hcw_enq_w_rx_sync_out_data.user.ao_v ;
    hcw_enq_info_nxt.vas					= hcw_enq_w_rx_sync_out_data.user.vas ;
    hcw_enq_info_nxt.pp_parity					= ^ { 1'b1
                                                                      , ( ^ { 1'b1
                                                                            , hcw_enq_w_rx_sync_out_data.user.ao_v
                                                                            , hcw_enq_w_rx_sync_out_data.user.vas
                                                                            , hcw_enq_w_rx_sync_out_data.user.pp_is_ldb
                                                                            , hcw_enq_w_rx_sync_out_data.user.qe_is_ldb
                                                                            , hcw_enq_w_rx_sync_out_data.user.qid
                                                                            , hcw_enq_w_rx_sync_out_data.user.insert_timestamp } )
                                                                      , hcw_enq_w_rx_sync_out_data_user_parity } ;
    hcw_enq_info_nxt.pp						= hcw_enq_w_rx_sync_out_data.user.pp ;
    hcw_enq_info_nxt.qid_parity					= ^ { 1'b1
                                                                      , ( ^ { 1'b1
                                                                            , hcw_enq_w_rx_sync_out_data.user.ao_v
                                                                            , hcw_enq_w_rx_sync_out_data.user.vas
                                                                            , hcw_enq_w_rx_sync_out_data.user.pp_is_ldb
                                                                            , hcw_enq_w_rx_sync_out_data.user.qe_is_ldb
                                                                            , hcw_enq_w_rx_sync_out_data.user.pp
                                                                            , hcw_enq_w_rx_sync_out_data.user.insert_timestamp } )
                                                                      , hcw_enq_w_rx_sync_out_data_user_parity } ;
    hcw_enq_info_nxt.qid					= hcw_enq_w_rx_sync_out_data.user.qid ;
    hcw_enq_info_nxt.hcw_cmd_parity				= hcw_enq_hcw_cmd_parity ;
    hcw_enq_info_nxt.hcw_cmd					= hcw_enq_w_rx_sync_out_data_hcw_cmd ;
    hcw_enq_info_nxt.pp_is_ldb 					= hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ;
    hcw_enq_info_nxt.qe_is_ldb 					= hcw_enq_w_rx_sync_out_data.user.qe_is_ldb ;

    hcw_enq_data_nxt.cq_hcw.qe_wt				= hcw_enq_w_rx_sync_out_data.data.debug.qe_wt ;
    hcw_enq_data_nxt.cq_hcw.ao_v				= hcw_enq_w_rx_sync_out_data.user.ao_v ;
    hcw_enq_data_nxt.cq_hcw.pp_is_ldb				= hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ;
    hcw_enq_data_nxt.cq_hcw.ppid				= hcw_enq_w_rx_sync_out_data.user.pp [ 5 : 0 ] ;
    hcw_enq_data_nxt.cq_hcw.ts_flag				= hcw_enq_w_rx_sync_out_data.user.insert_timestamp ;
    hcw_enq_data_nxt.cq_hcw.lockid_dir_info_tokens		= hcw_enq_w_rx_sync_out_data.data.lockid_dir_info_tokens ;
    hcw_enq_data_nxt.cq_hcw.msg_info.msgtype			= hcw_enq_w_rx_sync_out_data.data.msg_info.msgtype ;
    hcw_enq_data_nxt.cq_hcw.msg_info.qpri 			= hcw_enq_w_rx_sync_out_data.data.msg_info.qpri ;
    hcw_enq_data_nxt.cq_hcw.msg_info.qtype			= hcw_enq_w_rx_sync_out_data.data.msg_info.qtype ;
    hcw_enq_data_nxt.cq_hcw.msg_info.hcw_data_parity_error 	= ing_err_hcw_enq_data_parity_error ;
    hcw_enq_data_nxt.cq_hcw.msg_info.qid			= hcw_enq_w_rx_sync_out_data.data.msg_info.qid ;
    hcw_enq_data_nxt.cq_hcw.dsi_timestamp			= hcw_enq_w_rx_sync_out_data.data.dsi ;
    hcw_enq_data_nxt.cq_hcw.ptr					= hcw_enq_w_rx_sync_out_data.data.ptr ;

    if ( hcw_enq_w_rx_sync_out_data.user.insert_timestamp ) begin
      hcw_enq_data_nxt.cq_hcw.dsi_timestamp			= master_chp_timestamp ;
    end

    hcw_enq_data_nxt.cq_hcw_ecc					= hcw_enq_data_cq_hcw_ecc ;
  end

  hcw_enq_data_cq_hcw						= hcw_enq_data_nxt.cq_hcw ;

  ing_enq_vas_credit_count_we = 1'b0 ;
  ing_enq_vas_credit_count_addr = hcw_enq_w_rx_sync_out_data.user.vas [ 4 : 0 ] ;
  ing_enq_vas_credit_count_wdata = ing_enq_vas_credit_count_rdata ;

  if ( enq_vas_credit_count_residue_check & 
       ~ enq_vas_out_of_credit & 
       ~ ing_err_enq_vas_credit_count_residue_error ) begin
    ing_enq_vas_credit_count_we = 1'b1 ;
    ing_enq_vas_credit_count_wdata.residue = enq_vas_credit_count_residue_m1 ;
    ing_enq_vas_credit_count_wdata.count = ing_enq_vas_credit_count_rdata.count - 15'd1 ;
  end

  atm_ord_qed_arb_reqs = 2'b00 ;
  if ( ~ qed_to_cq_pipe_credit_afull & ~ cfg_req_idlepipe ) begin
    atm_ord_qed_arb_reqs [ 1 ] = ( qed_chp_sch_rx_sync_out_valid & ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_SCHED ) ) ; 
    atm_ord_qed_arb_reqs [ 0 ] = atm_ord_db_out_valid ;
  end 

  atm_ord_db_in_data = aqed_chp_sch_rx_sync_out_data ;
  atm_ord_db_out_ready = atm_ord_qed_arb_winner_v & ~ atm_ord_qed_arb_winner ;

  hcw_replay_db_in_data.cq_is_ldb = qed_chp_sch_rx_sync_out_data.hqm_core_flags.cq_is_ldb ;
  hcw_replay_db_in_data.flid_parity = qed_chp_sch_rx_sync_out_data.flid_parity ;
  hcw_replay_db_in_data.flid = qed_chp_sch_rx_sync_out_data.flid ;
  hcw_replay_db_in_data.cq_hcw_ecc = qed_chp_sch_rx_sync_out_data.cq_hcw_ecc ;
  hcw_replay_db_in_data.cq_hcw = qed_chp_sch_rx_sync_out_data.cq_hcw ;

  qed_sch_data.qed_chp_sch_data = fifo_qed_to_cq_pop_data.qed_chp_sch_data ;
  qed_sch_data.slot = fifo_qed_to_cq_pop_data.slot ;
  qed_sch_data.mode = fifo_qed_to_cq_pop_data.mode ;
  qed_sch_data.sn = fifo_qed_to_cq_pop_data.sn ;

  aqed_sch_data.cq = aqed_chp_sch_rx_sync_out_data.cq ;
  aqed_sch_data.qid = aqed_chp_sch_rx_sync_out_data.qid ;
  aqed_sch_data.qidix = aqed_chp_sch_rx_sync_out_data.qidix ;
  aqed_sch_data.parity = aqed_chp_sch_rx_sync_out_data.parity ;
  aqed_sch_data.fid = aqed_chp_sch_rx_sync_out_data.fid ;
  aqed_sch_data.fid_parity = aqed_chp_sch_rx_sync_out_data.fid_parity ;
  aqed_sch_data.hqm_core_flags = aqed_chp_sch_rx_sync_out_data.hqm_core_flags ;
  aqed_sch_data.cq_hcw = aqed_chp_sch_rx_sync_out_data.cq_hcw ;
  aqed_sch_data.cq_hcw_ecc = aqed_chp_sch_rx_sync_out_data.cq_hcw_ecc ;

  qed_chp_sch_flid_ret_v_set = 1'd0 ;
  qed_chp_sch_flid_ret_v_nxt = 1'd0 ;
  qed_chp_sch_flid_ret_nxt = qed_chp_sch_flid_ret_f ;

  ingress_flid_parity_error_inject_1_done_set = 1'd0 ;
  ingress_flid_parity_error_inject_0_done_set = 1'd0 ;

  if ( qed_chp_sch_flid_ret_rx_sync_out_valid & ~ cfg_req_idlepipe ) begin
    qed_chp_sch_flid_ret_v_set = 1'd1 ;
    qed_chp_sch_flid_ret_nxt.spare        = qed_chp_sch_flid_ret_rx_sync_out_data.spare ;
    qed_chp_sch_flid_ret_nxt.flid_parity  = qed_chp_sch_flid_ret_rx_sync_out_data.flid_parity ;
    qed_chp_sch_flid_ret_nxt.flid         = qed_chp_sch_flid_ret_rx_sync_out_data.flid ;
    if ( ingress_flid_parity_error_inject_1 ) begin
      qed_chp_sch_flid_ret_nxt.flid [ 0 ] = qed_chp_sch_flid_ret_rx_sync_out_data.flid [ 0 ] ^ 1'b1 ;
      ingress_flid_parity_error_inject_1_done_set = 1'd1 ;
    end
    if ( ingress_flid_parity_error_inject_0 ) begin
      qed_chp_sch_flid_ret_nxt.flid [ 13 ]  = qed_chp_sch_flid_ret_rx_sync_out_data.flid [ 13 ] ^ 1'b1 ;
      ingress_flid_parity_error_inject_0_done_set = 1'd1 ;
    end
    if ( ingress_flid_parity_error_inject_1 & ingress_flid_parity_error_inject_0 ) begin
      qed_chp_sch_flid_ret_nxt.flid_parity  = qed_chp_sch_flid_ret_rx_sync_out_data.flid_parity ^ 1'b1 ;
    end
    qed_chp_sch_flid_ret_v_nxt = qed_chp_sch_flid_ret_v_set & ( ~ qed_chp_sch_flid_ret_flid_parity_error_nxt | ingress_flid_parity_error_inject_0 ) ;
  end

  qed_chp_sch_flid_ret_flid_parity_check_enable = qed_chp_sch_flid_ret_v_set ;
  qed_chp_sch_flid_ret_flid_parity_check_odd = 1'd1 ;

  if ( qed_sch_data.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
    qed_chp_sch_vas_parity = hqm_chp_target_cfg_ldb_cq2vas_reg_f [ ( ( qed_sch_data.qed_chp_sch_data.cq [ 5 : 0 ] * 6 ) + 5 ) +: 1 ] ; 
    qed_chp_sch_vas        = hqm_chp_target_cfg_ldb_cq2vas_reg_f [   ( qed_sch_data.qed_chp_sch_data.cq [ 5 : 0 ] * 6 )       +: 5 ] ;
  end 
  else begin
    qed_chp_sch_vas_parity = hqm_chp_target_cfg_dir_cq2vas_reg_f [ ( ( qed_sch_data.qed_chp_sch_data.cq [ 6 : 0 ] * 6 ) + 5 ) +: 1 ] ; 
    qed_chp_sch_vas        = hqm_chp_target_cfg_dir_cq2vas_reg_f [   ( qed_sch_data.qed_chp_sch_data.cq [ 6 : 0 ] * 6 )       +: 5 ] ;
  end

  aqed_chp_sch_vas_parity = hqm_chp_target_cfg_ldb_cq2vas_reg_f [ ( ( aqed_sch_data.cq [ 5 : 0 ] * 6 ) + 5 ) +: 1 ] ; 
  aqed_chp_sch_vas        = hqm_chp_target_cfg_ldb_cq2vas_reg_f [   ( aqed_sch_data.cq [ 5 : 0 ] * 6 )       +: 5 ] ;

  qed_chp_sch_vas_parity_check_enable = qed_sch_pop ;
  qed_chp_sch_vas_parity_check_odd = 1'd1 ;

  aqed_chp_sch_vas_parity_check_enable = aqed_sch_pop ;
  aqed_chp_sch_vas_parity_check_odd = 1'd1 ;

  qed_chp_sch_cq_parity_error = qed_sch_pop & 
                                ( ( ^ { 1'b1 , qed_sch_data.qed_chp_sch_data.cq } ) ^ qed_sch_data_cq_parity ) ;
  aqed_chp_sch_cq_parity_error = aqed_sch_pop & 
                                 ( ( ^ { 1'b1 , aqed_sch_data.cq } ) ^ aqed_sch_data_cq_parity ) ;
  ing_sch_vas_credit_count_we_nxt = 1'd0 ;
  ing_sch_vas_credit_count_addr_nxt = qed_sch_pop ? qed_chp_sch_vas : aqed_chp_sch_vas  ;
  ing_sch_vas_credit_count_wdata = ing_sch_vas_credit_count_rdata ;

  if ( ( qed_sch_pop & ( qed_sch_data.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) & 
         ~ qed_chp_sch_cq_parity_error & ~ qed_chp_sch_vas_parity_error ) |
       ( aqed_sch_pop & 
         ~ aqed_chp_sch_cq_parity_error & ~ aqed_chp_sch_vas_parity_error ) ) begin
    ing_sch_vas_credit_count_we_nxt = 1'b1 ;
  end
  if ( ~ ing_err_sch_vas_credit_count_residue_error ) begin
    ing_sch_vas_credit_count_wdata.count = ing_sch_vas_credit_count_rdata.count + 15'd1 ;
    ing_sch_vas_credit_count_wdata.residue = sch_vas_credit_count_residue_p1 ;
  end

  ing_freelist_push_v = qed_chp_sch_flid_ret_v_f ;
  ing_freelist_push_data.flid_parity = qed_chp_sch_flid_ret_f.flid_parity ;
  ing_freelist_push_data.flid = qed_chp_sch_flid_ret_f.flid [ 13 : 0 ] ;
 
  qed_to_cq_pipe_credit_alloc = 1'd0 ;
  p0_qed_sch_v_nxt = 1'd0 ;
  p0_qed_sch_nxt = p0_qed_sch_f ;
  atm_ord_qed_arb_update = 1'b0 ;
  if ( atm_ord_qed_arb_winner_v ) begin
    atm_ord_qed_arb_update = 1'b1 ;
    qed_to_cq_pipe_credit_alloc = 1'd1 ;
    p0_qed_sch_v_nxt = 1'd1 ;
    p0_qed_sch_nxt.cmd = QED_CHP_SCH_SCHED ;
    p0_qed_sch_nxt.cq = atm_ord_db_out_data.cq ;
    p0_qed_sch_nxt.qidix = atm_ord_db_out_data.qidix ;
    p0_qed_sch_nxt.parity = ^ { 1'b1
                              , ( ^ { 1'b1, atm_ord_db_out_data.qid } )
                              , atm_ord_db_out_data.parity
                              } ;
    p0_qed_sch_nxt.flid = { 3'd0, atm_ord_db_out_data.fid } ;
    p0_qed_sch_nxt.flid_parity = atm_ord_db_out_data.fid_parity ;
    p0_qed_sch_nxt.hqm_core_flags = atm_ord_db_out_data.hqm_core_flags ;
    p0_qed_sch_nxt.cq_hcw = atm_ord_db_out_data.cq_hcw ;
    p0_qed_sch_nxt.cq_hcw_ecc = atm_ord_db_out_data.cq_hcw_ecc ;
    if ( atm_ord_qed_arb_winner ) begin
      p0_qed_sch_nxt = qed_chp_sch_rx_sync_out_data ;
    end
  end

  qed_chp_sch_rx_sync_out_ordered = ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_SCHED ) & qed_chp_sch_rx_sync_out_data.hqm_core_flags.cq_is_ldb &
                                    ( qed_chp_sch_rx_sync_out_data.cq_hcw.msg_info.qtype == ORDERED ) ;
  qed_sch_sn_mem_p0_v_nxt = p0_qed_sch_v_nxt ; 
  qed_sch_sn_mem_p0_rmw_nxt = (p0_qed_sch_v_nxt & ((~atm_ord_qed_arb_winner) | qed_chp_sch_rx_sync_out_ordered )) ? HQM_AW_RMWPIPE_RMW : HQM_AW_RMWPIPE_NOOP ; 
  qed_sch_sn_mem_p0_addr_nxt = p0_qed_sch_v_nxt ? ( atm_ord_qed_arb_winner ? qed_chp_sch_rx_sync_out_data.cq_hcw.msg_info.qid [ 4 : 0 ] : atm_ord_db_out_data.cq_hcw.msg_info.qid [ 4 : 0 ] ) : 5'd0 ;

  qed_sch_sn_map_mem_p0_v_nxt = qed_sch_sn_mem_p0_v_nxt ; 
  qed_sch_sn_map_mem_p0_rw_nxt = HQM_AW_RWPIPE_READ ; 
  qed_sch_sn_map_mem_p0_addr_nxt = qed_sch_sn_mem_p0_addr_nxt ;

  p1_qed_sch_v_nxt = 1'd0 ;
  p1_qed_sch_nxt = p1_qed_sch_f ;
  if ( p0_qed_sch_v_f ) begin
    p1_qed_sch_v_nxt = 1'd1 ;
    p1_qed_sch_nxt = p0_qed_sch_f ;
  end

  p2_qed_sch_v_nxt = 1'd0 ;
  p2_qed_sch_nxt = p2_qed_sch_f ;
  if ( p1_qed_sch_v_f ) begin
    p2_qed_sch_v_nxt = 1'd1 ;
    p2_qed_sch_nxt = p1_qed_sch_f ;
  end

  case (qed_sch_sn_map_mem_p2_data_f.map.mode)
    QIDS_32_SN_64  : p2_qid_sn_size_mask = 10'h03f ;
    QIDS_16_SN_128 : p2_qid_sn_size_mask = 10'h07f ;
    QIDS_8_SN_256  : p2_qid_sn_size_mask = 10'h0ff ;
    QIDS_4_SN_512  : p2_qid_sn_size_mask = 10'h1ff ;
    QIDS_2_SN_1024 : p2_qid_sn_size_mask = 10'h3ff ;
    default        : p2_qid_sn_size_mask = 10'h000 ;
  endcase

  case (qed_sch_sn_map_mem_p2_data_f.map.mode)
    QIDS_32_SN_64  : p2_qed_sch_sn_wrap = ( qed_sch_sn_mem_p2_data_f.sn == 10'h03f ) ;
    QIDS_16_SN_128 : p2_qed_sch_sn_wrap = ( qed_sch_sn_mem_p2_data_f.sn == 10'h07f ) ;
    QIDS_8_SN_256  : p2_qed_sch_sn_wrap = ( qed_sch_sn_mem_p2_data_f.sn == 10'h0ff ) ;
    QIDS_4_SN_512  : p2_qed_sch_sn_wrap = ( qed_sch_sn_mem_p2_data_f.sn == 10'h1ff ) ;
    QIDS_2_SN_1024 : p2_qed_sch_sn_wrap = ( qed_sch_sn_mem_p2_data_f.sn == 10'h3ff ) ;
    default        : p2_qed_sch_sn_wrap = 1'b0  ;
  endcase

  qed_sch_sn_mem_p3_bypsel_nxt = p2_qed_sch_v_f & p2_qed_sch_f.hqm_core_flags.cq_is_ldb &
                                 ( ( p2_qed_sch_f.cq_hcw.msg_info.qtype == ORDERED ) |
                                   ( ( p2_qed_sch_f.cq_hcw.msg_info.qtype == ATOMIC ) & p2_qed_sch_f.cq_hcw.ao_v ) ) ;
  qed_sch_sn_mem_p3_bypdata_nxt.sn = ( qed_sch_sn_mem_p2_data_f.sn + 10'd1 ) & p2_qid_sn_size_mask ;
  qed_sch_sn_mem_p3_bypdata_nxt.residue = qed_sch_sn_mem_p2_data_residue_p1 ;

  if ( p2_qed_sch_sn_wrap & ~ qed_sch_sn_mem_p2_data_residue_error ) begin
    qed_sch_sn_mem_p3_bypdata_nxt.residue = 2'd0 ;
  end

  p2_qid_sn_mode_slot_shift_amount = { 1'd0 , qed_sch_sn_map_mem_p2_data_f.map.mode } + 4'd6 ;
  p2_qid_sn_slot_scaled = { 6'd0 , qed_sch_sn_map_mem_p2_data_f.map.slot[ 3 : 0 ] } ;
  p2_qid_slot_base = p2_qid_sn_slot_scaled << p2_qid_sn_mode_slot_shift_amount;
  p2_qid_slot_sn = p2_qid_slot_base + qed_sch_sn_mem_p2_data_f.sn ;

  fifo_qed_to_cq_push = p2_qed_sch_v_f ;
  fifo_qed_to_cq_push_data.qed_chp_sch_data = p2_qed_sch_f ;
  fifo_qed_to_cq_push_data.slot = { 1'b0, qed_sch_sn_map_mem_p2_data_f.map.slot [ 3 : 0 ] } ;
  fifo_qed_to_cq_push_data.mode = qed_sch_sn_map_mem_p2_data_f.map.mode ;
  fifo_qed_to_cq_push_data.sn = { 1'b0, qed_sch_sn_map_mem_p2_data_f.map.group [ 0 ] , p2_qid_slot_sn } ;

  ing_hqm_chp_target_cfg_chp_smon_smon_v [ ( 0 * 1 ) +: 1 ]      = hcw_enq_w_rx_sync_out_valid |
                                                                   fifo_qed_to_cq_push |
                                                                   qed_chp_sch_rx_sync_out_valid |
                                                                   aqed_chp_sch_rx_sync_out_valid ;
  ing_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 0 * 32 ) +: 32 ] = { 15'd0
                                                                   , fifo_qed_to_cq_push								// 16
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready &			// 15
                                                                       ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_ILL0 ) )			      
                                                                   , 1'b0                                                               		// 14
                                                                   , 1'b0                                                               		// 13
                                                                   , ( hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_invalid_hcw_cmd &		// 12
                                                                     hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ) 
                                                                   , ( hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_invalid_hcw_cmd &		// 11
                                                                     ~ hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ) 
                                                                   , 1'b0                                                        			// 10
                                                                   , ( aqed_chp_sch_rx_sync_out_valid & aqed_chp_sch_rx_sync_out_ready )		//  9
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready &			//  8
                                                                       ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_TRANSFER ) )			      
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready &			//  7
                                                                       ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_REPLAY ) &			      
                                                                       qed_chp_sch_rx_sync_out_data.hqm_core_flags.cq_is_ldb )
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready &			//  7
                                                                       ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_SCHED ) &			      
                                                                       qed_chp_sch_rx_sync_out_data.hqm_core_flags.cq_is_ldb )
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready )			//  5
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready &			//  4
                                                                       ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_REPLAY ) &			      
                                                                       ~ qed_chp_sch_rx_sync_out_data.hqm_core_flags.cq_is_ldb )
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready &			//  3
                                                                       ( qed_chp_sch_rx_sync_out_data.cmd == QED_CHP_SCH_SCHED ) &				      
                                                                       ~ qed_chp_sch_rx_sync_out_data.hqm_core_flags.cq_is_ldb )
                                                                   , ( qed_chp_sch_rx_sync_out_valid & qed_chp_sch_rx_sync_out_ready &			//  2
                                                                       qed_chp_sch_rx_sync_out_data.hqm_core_flags.cq_is_ldb )
                                                                   , ( hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_ready &			//  1
                                                                       hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ) 
                                                                   , ( hcw_enq_w_rx_sync_out_valid & hcw_enq_w_rx_sync_out_ready &			//  0
                                                                       ~ hcw_enq_w_rx_sync_out_data.user.pp_is_ldb ) 
                                                                   } ;
  ing_hqm_chp_target_cfg_chp_smon_smon_val [ ( 0 * 32 ) +: 32 ]  = 32'd1 ;

  ing_hqm_chp_target_cfg_chp_smon_smon_v [ ( 1 * 1 ) +: 1 ]      = hcw_enq_pop | 
                                                                   aqed_sch_pop | 
                                                                   qed_sch_pop | 
                                                                   hcw_replay_pop ;
  ing_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 1 * 32 ) +: 32 ] = { 18'd0 
                                                                   , ( ( hcw_enq_pop & ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) |		// 13
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) &
                                                                                         hcw_enq_info.pp_is_ldb ) |
                                                                       ( hcw_enq_pop & ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) &
                                                                                         ~ hcw_enq_info.pp_is_ldb ) ) 
                                                                   , ( ( hcw_enq_pop & ~ ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) |	// 12
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) &
                                                                                         hcw_enq_info.pp_is_ldb ) |
                                                                       ( hcw_enq_pop & ~ ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) & 
                                                                                         ~ hcw_enq_info.pp_is_ldb ) ) 
                                                                   , 1'd0										// 11
                                                                   , 1'd0 										// 10
                                                                   , aqed_sch_pop									//  9
                                                                   , 1'd0										//  8
                                                                   , hcw_replay_pop									//  7
                                                                   , qed_sch_pop									//  6 
                                                                   , (qed_sch_pop | hcw_replay_pop )							//  5 
                                                                   , hcw_replay_pop									//  4
                                                                   , qed_sch_pop									//  3 
                                                                   , (qed_sch_pop | hcw_replay_pop )							//  2 
                                                                   , hcw_enq_pop									//  1
                                                                   , 1'd0       									//  0
                                                                   } ;
  ing_hqm_chp_target_cfg_chp_smon_smon_val [ ( 1 * 32 ) +: 32 ]  = 32'd1 ;

  ing_hqm_chp_target_cfg_chp_smon_smon_v [ ( 2 * 1 ) +: 1 ]      = hcw_enq_pop ;
  ing_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 2 * 32 ) +: 32 ] = { 18'd0 
                                                                   , ( ( hcw_enq_pop & ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) |		// 13
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) &
                                                                                         hcw_enq_info.pp_is_ldb ) |
                                                                       ( hcw_enq_pop & ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) &
                                                                                         ~ hcw_enq_info.pp_is_ldb ) )
                                                                   , ( ( hcw_enq_pop & ~ ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) |		// 12
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) &
                                                                                           hcw_enq_info.pp_is_ldb ) |
                                                                       ( hcw_enq_pop & ~ ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                                                                           ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) &
                                                                                           ~ hcw_enq_info.pp_is_ldb ) )
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) &		// 11
                                                                       hcw_enq_info.pp_is_ldb )
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) ) &			// 10
                                                                       hcw_enq_info.pp_is_ldb )
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) ) &		//  9
                                                                       hcw_enq_info.pp_is_ldb )
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) ) &			//  8 
                                                                       hcw_enq_info.pp_is_ldb )
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) ) ) 		//  7
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) ) )			//  6
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ARM ) ) )			//  5
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_4 ) ) &		//  4
                                                                       hcw_enq_info.pp_is_ldb )
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) ) &		//  3
                                                                       hcw_enq_info.pp_is_ldb )
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) ) )			//  2
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_BAT_TOK_RET ) ) )		//  1
                                                                   , ( ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_NOOP ) ) )			//  0
                                                                   } ;
  ing_hqm_chp_target_cfg_chp_smon_smon_val [ ( 2 * 32 ) +: 32 ]  = 32'd1 ;

  ing_hqm_chp_target_cfg_chp_smon_smon_v [ ( 3 * 1 ) +: 1 ]      = hcw_enq_pop ;
  ing_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 3 * 32 ) +: 32 ] = { ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_15 ) &		// 31
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_14 ) &		// 30
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) &		// 29
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) &			// 28
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) &		// 27
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) &			// 26 
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) &		// 25
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) &			// 24
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) &		// 23
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP        ) &		// 22
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ARM ) &				// 21
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_4 ) &		// 20
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) &			// 19
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) &				// 18
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_BAT_TOK_RET ) &			// 17
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_NOOP ) &				// 16
                                                                     hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_15 ) &		// 15
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_14 ) &		// 14
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) &		// 13
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) &			// 12
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) &		// 11
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) &			// 10 
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) &		//  9
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) &			//  8
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) &		//  7
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP        ) &		//  6
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ARM ) &				//  5
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_ILLEGAL_CMD_4 ) &		//  4
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) &			//  3
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) &				//  2
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_BAT_TOK_RET ) &			//  1
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   , ( hcw_enq_pop & ( hcw_enq_info.hcw_cmd == HQM_CMD_NOOP ) &				//  0
                                                                     ~ hcw_enq_info.pp_is_ldb )
                                                                   } ;
  ing_hqm_chp_target_cfg_chp_smon_smon_val [ ( 3 * 32 ) +: 32 ]  = 32'd1 ;

end 

endmodule 
