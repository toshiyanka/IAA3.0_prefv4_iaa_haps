`ifdef INTEL_INST_ON
module hqm_reorder_pipe_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
`ifdef HQM_COVER_ON

logic clk;
logic rst_n;

logic [4:0]       request_state;
logic             chp_rop_hcw_db2_out_valid;
logic             chp_rop_hcw_db2_out_ready;
logic             nalb_sn_hazard_detected;
logic             dir_sn_hazard_detected;

// assigns
assign clk =  hqm_reorder_pipe_core.hqm_gated_clk;
assign rst_n =  hqm_reorder_pipe_core.hqm_gated_rst_n;
assign request_state = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.request_state;
assign chp_rop_hcw_db2_out_valid = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid;
assign chp_rop_hcw_db2_out_ready = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_ready;

assign nalb_sn_hazard_detected = !hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_empty & ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_hazard_f.nalb_sn_v & ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_hazard_f.nalb_sn == hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_pop_data ));
assign dir_sn_hazard_detected = !hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_empty  & ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_hazard_f.dp_sn_v   & ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_hazard_f.dp_sn == hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_pop_data ));


covergroup ROP_REQUEST_STATE @(posedge clk );

            ROP_REQUEST_CASES : coverpoint {request_state} iff ( rst_n & chp_rop_hcw_db2_out_valid  & chp_rop_hcw_db2_out_ready )
            {
              
              bins UPDATE_ORDER_ST                                               = { 5'b00001 };
              ignore_bins NVC_2                                                  = { 5'b00010 }; // NVC not valid combination // illegal_bins NVC_2                                                         = { 5'b00010 }; // NVC not valid combination
              bins START_REORDER_UPDATE_ORDER_ST                                 = { 5'b00011 };
            //bins SYS_ENQ                                                       = { 5'b00100 };
              ignore_bins NVC_4                                                  = { 5'b00100 };
              ignore_bins NVC_5                                                  = { 5'b00101 }; // NVC not valid combinatino: cmd_sys_enq and cmd_update_sn_order_state not possible // illegal_bins NVC_5                                                         = { 5'b00101 }; // NVC not valid combinatino: cmd_sys_enq and cmd_update_sn_order_state not possible
              ignore_bins NVC_6                                                  = { 5'b00110 }; // NVC not valid combination: // illegal_bins NVC_6                                                         = { 5'b00110 }; // NVC not valid combination:
              ignore_bins NVC_7                                                  = { 5'b00111 }; // NVC not valid combination:  cmd_sys_enq and cmd_start_sn_reorder and cmd_update_sn_order_state n // illegal_bins NVC_7                                                         = { 5'b00111 }; // NVC not valid combination:  cmd_sys_enq and cmd_start_sn_reorder and cmd_update_sn_order_state n
              ignore_bins NVC_8                                                  = { 5'b01000 }; // NVC not valid combination: // illegal_bins NVC_8                                                         = { 5'b01000 }; // NVC not valid combination:
            //bins HCW_ENQ_UPDATE_ORDER_ST                                       = { 5'b01001 };
              ignore_bins NVC_9                                                  = { 5'b01001 };
              ignore_bins NVC_10                                                 = { 5'b01010 }; // NVC not valid combination: // illegal_bins NVC_10                                                        = { 5'b01010 }; // NVC not valid combination:
            //bins HCW_ENQ_START_REORDER_UPDATE_ORDER_ST                         = { 5'b01011 };
              ignore_bins NVC_11                                                 = { 5'b01011 };
              bins HCW_ENQ_SYS_ENQ                                               = { 5'b01100 }; 
              bins HCW_ENQ_SYS_ENQ_UPDATE_ORDER_ST                               = { 5'b01101 };
            //bins HCW_ENQ_SYS_ENQ_START_REORDER                                 = { 5'b01110 };
              ignore_bins NVC_14                                                 = { 5'b01110 };
              bins HCW_ENQ_SYS_ENQ_START_REORDER_UPDATE_ORDER_ST                 = { 5'b01111 };
              bins SN_GET_ORDER_ST                                               = { 5'b10000 }; // - pull from sn_order fifo to get SN ordering information
            //bins SN_GET_ORDER_ST_UPDATE_ORDER_ST                               = { 5'b10001 }; // - UPDATE_ORDER_ST always wins
              ignore_bins NVC_17                                                 = { 5'b10001 }; // - UPDATE_ORDER_ST always wins
            //bins SN_GET_ORDER_ST_START_REORDER                                 = { 5'b10010 }; // - START_REORDER always wins
              ignore_bins NVC_18                                                 = { 5'b10010 }; // - START_REORDER always wins
              bins SN_GET_ORDER_ST_START_REORDER_UPDATE_ORDER_ST                 = { 5'b10011 };
            //bins SN_GET_ORDER_ST_SYS_ENQ                                       = { 5'b10100 };
              ignore_bins NVC_20                                                 = { 5'b10100 };
              ignore_bins NVC_21                                                 = { 5'b10101 }; // NVC not valid combination: // illegal_bins NVC_21                                                       = { 5'b10101 }; // NVC not valid combination:
            //bins SN_GET_ORDER_ST_SYS_ENQ_START_REORDER                         = { 5'b10110 };
              ignore_bins NVC_22                                                 = { 5'b10110 };
              ignore_bins NVC_23                                                 = { 5'b10111 }; // NVC not valid combination: // illegal_bins NVC_23                                                       = { 5'b10111 }; // NVC not valid combination:
              ignore_bins NVC_24                                                 = { 5'b11000 }; // NVC not valid combination: // illegal_bins NVC_24                                                       = { 5'b11000 }; // NVC not valid combination:
            //bins SN_GET_ORDER_ST_HCW_ENQ_UPDATE_ORDER_ST                       = { 5'b11001 };
              ignore_bins NVC_25                                                 = { 5'b11001 };
              bins SN_GET_ORDER_ST_HCW_ENQ_START_REORDER                         = { 5'b11010 };
              ignore_bins NVC_27                                                 = { 5'b11011 }; // NVC not valid combination: // illegal_bins NVC_27                                                       = { 5'b11011 }; // NVC not valid combination:
              bins SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ                               = { 5'b11100 };
              bins SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_UPDATE_ORDER_ST               = { 5'b11101 }; // UPDATE_ORDER_ST always wins over SN_GET_ORDER_ST
            //bins SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_START_REORDER                 = { 5'b11110 }; 
              ignore_bins NVC_30                                                 = { 5'b11110 }; 
              bins SN_GET_ORDER_ST_HCW_ENQ_SYS_ENQ_START_REORDER_UPDATE_ORDER_ST = { 5'b11111 }; // UPDATE_ORDER_ST always winser over SN_GET_ORDER_ST
            }

endgroup

covergroup ROP_CG_SN_0 @(posedge clk);

          ROP_CP_ALL_SN_VALUES : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.cmp_sn } iff ( rst_n & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.cmp_v )
          {
              bins ALL_SN_VALUES [] = { [0:$] };
          }

          ROP_CP_ALL_SLT_VALUES : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.cmp_slt } iff ( rst_n & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.cmp_v )
          {
              bins valid_slot = { [0:15] };
              ignore_bins invalid_slot = { [15:31] };
          }

endgroup

covergroup COVERGROUP @(posedge clk);

  WCP_ROP_000                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.cmp_v } iff (rst_n);

  //Pipeline

  WCP_H00_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_qed_dqed_enq_ctl.hold } iff (rst_n) ;
  WCP_H01_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_qed_dqed_enq_ctl.hold } iff (rst_n) ;
  WCP_H02_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_nalb_enq_ctl.hold } iff (rst_n) ;
  WCP_H03_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_nalb_enq_ctl.hold } iff (rst_n) ;
  WCP_H04_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_nalb_enq_ctl.hold } iff (rst_n) ;
  WCP_H05_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_dp_enq_ctl.hold } iff (rst_n) ;
  WCP_H06_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_dp_enq_ctl.hold } iff (rst_n) ;
  WCP_H07_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_dp_enq_ctl.hold } iff (rst_n) ;
//WCP_H08_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_reord_ctl.hold } iff (rst_n) ;
//WCP_H09_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_reord_ctl.hold } iff (rst_n) ;
//WCP_H10_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_reord_ctl.hold } iff (rst_n) ;
//WCP_H11_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p3_reord_ctl.hold } iff (rst_n) ;
                             
  WCP_H12_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_qed_dqed_enq_ctl.hold } iff (rst_n) ;
  WCP_H13_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_qed_dqed_enq_ctl.hold } iff (rst_n) ;
  WCP_H14_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_nalb_enq_ctl.hold } iff (rst_n) ;
  WCP_H15_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_nalb_enq_ctl.hold } iff (rst_n) ;
  WCP_H16_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_nalb_enq_ctl.hold } iff (rst_n) ;
  WCP_H17_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_dp_enq_ctl.hold } iff (rst_n) ;
  WCP_H18_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_dp_enq_ctl.hold } iff (rst_n) ;
  WCP_H19_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_dp_enq_ctl.hold } iff (rst_n) ;
//WCP_H20_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_reord_ctl.hold } iff (rst_n) ;
//WCP_H21_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_reord_ctl.hold } iff (rst_n) ;
//WCP_H22_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_reord_ctl.hold } iff (rst_n) ;
//WCP_H23_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p3_reord_ctl.hold } iff (rst_n) ;
                             
  WCP_H40_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_qed_dqed_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_qed_dqed_enq_f.v } iff (rst_n) ;
  WCP_H41_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_qed_dqed_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_qed_dqed_enq_f.v } iff (rst_n) ;
                             
  WCP_H42_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_nalb_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_nalb_enq_f.v } iff (rst_n) ;
  WCP_H43_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_nalb_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_nalb_enq_f.v } iff (rst_n) ;
  WCP_H44_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_nalb_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_nalb_enq_f.v } iff (rst_n) ;
                             
  WCP_H45_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_dp_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_dp_enq_f.v } iff (rst_n) ;
  WCP_H46_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_dp_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_dp_enq_f.v } iff (rst_n) ;
  WCP_H47_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_dp_enq_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_dp_enq_f.v } iff (rst_n) ;
                             
//WCP_H48_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_reord_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_reord_f.v } iff (rst_n) ;
//WCP_H49_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_reord_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_reord_f.v } iff (rst_n) ;
//WCP_H50_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_reord_ctl.hold & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_reord_f.v } iff (rst_n) ;
//WCP_H51_ROP                : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p3_reord_ctl.hold } iff (rst_n) ;
                             
  WCP_QED_DQED_CROSS         : cross WCP_H40_ROP, WCP_H41_ROP;
                             
  WCP_NALB_CROSS             : cross WCP_H42_ROP, WCP_H43_ROP, WCP_H44_ROP;
                             
  WCP_DP_CROSS               : cross WCP_H45_ROP, WCP_H46_ROP, WCP_H47_ROP;
                             
//WCP_REORD_CRSOSS           : cross WCP_H48_ROP, WCP_H49_ROP, WCP_H50_ROP, WCP_H51_ROP;

  WCP_P00_ROP_NALB_ENQ       : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_nalb_enq_f.data.cmd } iff (rst_n) { ignore_bins ILL0 = {0}; bins NEW_HCW = {1}; bins REORDER_HCW = {2}; bins REORDER_LIST = {3}; bins NEW_HCW_NOOP = {4}; ignore_bins ILL5 = {5}; ignore_bins ILL6 = {6}; ignore_bins ILL7 = {7}; }
  WCP_P01_ROP_NALB_ENQ       : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_nalb_enq_f.data.cmd } iff (rst_n) { ignore_bins ILL0 = {0}; bins NEW_HCW = {1}; bins REORDER_HCW = {2}; bins REORDER_LIST = {3}; bins NEW_HCW_NOOP = {4}; ignore_bins ILL5 = {5}; ignore_bins ILL6 = {6}; ignore_bins ILL7 = {7}; }
  WCP_P02_ROP_NALB_ENQ       : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_nalb_enq_f.data.cmd } iff (rst_n) { ignore_bins ILL0 = {0}; bins NEW_HCW = {1}; bins REORDER_HCW = {2}; bins REORDER_LIST = {3}; bins NEW_HCW_NOOP = {4}; ignore_bins ILL5 = {5}; ignore_bins ILL6 = {6}; ignore_bins ILL7 = {7}; }
                             
  WCP_P03_ROP_NALB_ENQ       : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_nalb_enq_f.data.cq } iff (rst_n) { bins valid_cq = {[0:95]}; ignore_bins invalid_cq = {[96:255]}; }
  WCP_P04_ROP_NALB_ENQ       : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_nalb_enq_f.data.cq } iff (rst_n) { bins valid_cq = {[0:95]}; ignore_bins invalid_cq = {[96:255]}; }
  WCP_P05_ROP_NALB_ENQ       : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_nalb_enq_f.data.cq } iff (rst_n) { bins valid_cq = {[0:95]}; ignore_bins invalid_cq = {[96:255]}; }
                             
                             
  WCP_P00_ROP_DP_ENQ         : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_dp_enq_f.data.cmd } iff (rst_n) { ignore_bins ILL0 = {0}; bins NEW_HCW = {1}; bins REORDER_HCW = {2}; bins REORDER_LIST = {3}; bins NEW_HCW_NOOP = {4}; ignore_bins ILL5 = {5}; ignore_bins ILL6 = {6}; ignore_bins ILL7 = {7}; }
  WCP_P01_ROP_DP_ENQ         : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_dp_enq_f.data.cmd } iff (rst_n) { ignore_bins ILL0 = {0}; bins NEW_HCW = {1}; bins REORDER_HCW = {2}; bins REORDER_LIST = {3}; bins NEW_HCW_NOOP = {4}; ignore_bins ILL5 = {5}; ignore_bins ILL6 = {6}; ignore_bins ILL7 = {7}; }
  WCP_P02_ROP_DP_ENQ         : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_dp_enq_f.data.cmd } iff (rst_n) { ignore_bins ILL0 = {0}; bins NEW_HCW = {1}; bins REORDER_HCW = {2}; bins REORDER_LIST = {3}; bins NEW_HCW_NOOP = {4}; ignore_bins ILL5 = {5}; ignore_bins ILL6 = {6}; ignore_bins ILL7 = {7}; }
  WCP_P03_ROP_DP_ENQ         : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p0_rop_dp_enq_f.data.cq } iff (rst_n) { bins valid_cq = {[0:95]}; ignore_bins invalid_cq = {[96:255]}; } 
  WCP_P04_ROP_DP_ENQ         : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_rop_dp_enq_f.data.cq } iff (rst_n) { bins valid_cq = {[0:95]}; ignore_bins invalid_cq = {[96:255]}; } 
  WCP_P05_ROP_DP_ENQ         : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p2_rop_dp_enq_f.data.cq } iff (rst_n) { bins valid_cq = {[0:95]}; ignore_bins invalid_cq = {[96:255]}; } 

  WCP_PXX_ROP_NALB_ENQ_CROSS : cross WCP_P00_ROP_NALB_ENQ, WCP_P01_ROP_NALB_ENQ, WCP_P02_ROP_NALB_ENQ;
  WCP_PXX_ROP_DP_ENQ_CROSS   : cross WCP_P00_ROP_DP_ENQ, WCP_P01_ROP_DP_ENQ, WCP_P02_ROP_DP_ENQ;

  //CONTENTION
  WCP_cfg_waiting_0: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_rop_nalb_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
  WCP_cfg_waiting_1: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_rop_dp_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
  WCP_cfg_waiting_2: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_rop_qed_dqed_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
  WCP_cfg_waiting_3: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_rop_lsp_reordercmp_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
  WCP_cfg_waiting_4: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_grp0_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
  WCP_cfg_waiting_5: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_grp1_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
/*
  WCP_cfg_waiting_6: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_grp2_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
  WCP_cfg_waiting_7: coverpoint { (|hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_pipe_health_valid_grp3_f) & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f.cfg_busy } iff (rst_n) {
     bins B0={0};
     bins HIT={1};
  }
*/

  //ARB


  WCP_ARB0_ROP              : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.i_replay_request_select.reqs } iff (rst_n) ;
  WCP_ARB1_ROP              : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.i_rop_nalb_enq_rr_arb.reqs } iff (rst_n) 
  {
            bins b0    = { 2'b00 };
            bins b1    = { 2'b01 };
            bins b2    = { 2'b10 };
            bins b3    = { 2'b11 };

            bins b4    = ( 2'b01 [* 2] );
            bins b5    = ( 2'b01 [* 2] );

            bins b6    = ( 2'b10 [* 2] );
            bins b7    = ( 2'b10 [* 2] );

            bins b8    = ( 2'b11 [* 2] );
            bins b9    = ( 2'b11 [* 2] );

  }
  WCP_ARB2_ROP              : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.i_rop_dp_enq_rr_arb.reqs } iff (rst_n) ;

  //FIFO
  WCP_ROP_chp_rop_hcw_fifo            : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_afull,    hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_empty    } iff (rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; } // illegal_bins X={3}; }
  WCP_ROP_dir_rply_req_fifo           : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.dir_rply_req_fifo_afull,   hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.dir_rply_req_fifo_empty   } iff (rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; } // illegal_bins X={3}; }
  WCP_ROP_ldb_rply_req_fifo           : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_afull,   hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_empty   } iff (rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; } // illegal_bins X={3}; }
  WCP_ROP_sn_ordered_fifo             : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_afull,     hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_empty     } iff (rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; } // illegal_bins X={3}; }
  WCP_ROP_sn_complete_fifo            : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_afull,    hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_empty    } iff (rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; } // illegal_bins X={3}; }
  WCP_ROP_lsp_reordercmp_fifo         : coverpoint { hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_afull, hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_empty } iff (rst_n) { bins N={0}; bins E={1}; bins F={2}; ignore_bins X={3}; } // illegal_bins X={3}; }
                                      
  WCP_ROP_FIFO_0_CROSS                : cross WCP_ROP_chp_rop_hcw_fifo, WCP_ROP_dir_rply_req_fifo;
  WCP_ROP_FIFO_1_CROSS                : cross WCP_ROP_chp_rop_hcw_fifo, WCP_ROP_ldb_rply_req_fifo, WCP_ROP_lsp_reordercmp_fifo;
  WCP_ROP_FIFO_2_CROSS                : cross WCP_ROP_sn_ordered_fifo, WCP_ROP_sn_complete_fifo;
                                      
  //IF                                
  WCP_ROP_chp_rop_ready               : coverpoint { hqm_reorder_pipe_core.chp_rop_hcw_ready } iff (rst_n) ;
  WCP_ROP_chp_rop_v                   : coverpoint { hqm_reorder_pipe_core.chp_rop_hcw_v } iff (rst_n) ;
  WCP_ROP_WCP_ROP_chp_rop_CROSS       : cross WCP_ROP_chp_rop_ready, WCP_ROP_chp_rop_v;


  WCP_ROP_rop_dp_enq_ready            : coverpoint { hqm_reorder_pipe_core.rop_dp_enq_ready } iff (rst_n) ;
  WCP_ROP_rop_dp_enq_v                : coverpoint { hqm_reorder_pipe_core.rop_dp_enq_v } iff (rst_n) ;
  WCP_ROP_rop_dp_enq_CROSS            : cross WCP_ROP_rop_dp_enq_ready , WCP_ROP_rop_dp_enq_v; 

  WCP_ROP_rop_nalb_enq_ready          : coverpoint { hqm_reorder_pipe_core.rop_nalb_enq_ready } iff (rst_n) ;
  WCP_ROP_rop_nalb_enq_v              : coverpoint { hqm_reorder_pipe_core.rop_nalb_enq_v} iff (rst_n) ;
  WCP_ROP_rop_nalb_enq_CROSS          : cross WCP_ROP_rop_nalb_enq_ready, WCP_ROP_rop_nalb_enq_v;
                                     
  WCP_ROP_rop_qed_enq_ready           : coverpoint { hqm_reorder_pipe_core.rop_qed_enq_ready } iff (rst_n) ;
  WCP_ROP_rop_dqed_enq_ready          : coverpoint { hqm_reorder_pipe_core.rop_dqed_enq_ready } iff (rst_n) ;
  WCP_ROP_rop_qed_dqed_enq_v          : coverpoint { hqm_reorder_pipe_core.rop_qed_dqed_enq_v } iff (rst_n) ;
  WCP_ROP_rop_qed_enq_CROSS           : cross WCP_ROP_rop_qed_enq_ready, WCP_ROP_rop_qed_dqed_enq_v; 
  WCP_ROP_rop_dqed_enq_CROSS          : cross WCP_ROP_rop_dqed_enq_ready, WCP_ROP_rop_qed_dqed_enq_v;

  WCP_ROP_rop_lsp_reordercmp_v        : coverpoint { hqm_reorder_pipe_core.rop_lsp_reordercmp_v } iff (rst_n) ;
  WCP_ROP_rop_lsp_reordercmp_ready    : coverpoint { hqm_reorder_pipe_core.rop_lsp_reordercmp_ready } iff (rst_n) ;
  WCP_ROP_rop_lsp_reordercmp_cross    : cross WCP_ROP_rop_lsp_reordercmp_v, WCP_ROP_rop_lsp_reordercmp_ready;

  WCP_ROP_rop_lsp_reordercmp_user     : coverpoint { hqm_reorder_pipe_core.rop_lsp_reordercmp_data.user } iff (rst_n & hqm_reorder_pipe_core.rop_lsp_reordercmp_v & hqm_reorder_pipe_core.rop_lsp_reordercmp_ready) ;
  WCP_ROP_rop_lsp_reordercmp_qid      : coverpoint { hqm_reorder_pipe_core.rop_lsp_reordercmp_data.qid[4:0] } iff (rst_n & hqm_reorder_pipe_core.rop_lsp_reordercmp_v & hqm_reorder_pipe_core.rop_lsp_reordercmp_ready) ;
  WCP_ROP_rop_lsp_reordercmp_cq       : coverpoint { hqm_reorder_pipe_core.rop_lsp_reordercmp_data.cq[5:0] } iff (rst_n & hqm_reorder_pipe_core.rop_lsp_reordercmp_v & hqm_reorder_pipe_core.rop_lsp_reordercmp_ready) ;

  WCP_ROP_DIR_SN_HAZARD               : coverpoint { dir_sn_hazard_detected } iff ( rst_n );
  WCP_ROP_LDB_SN_HAZARD               : coverpoint { nalb_sn_hazard_detected } iff ( rst_n );

  //USAGE
  WCP_ROP_NALB_CQ           : coverpoint { hqm_reorder_pipe_core.rop_nalb_enq_data.cq } iff (rst_n) { bins valid_cq = {[0:95]}; ignore_bins invalid_cq = {[96:255]}; }
  WCP_ROP_NALB_FLID         : coverpoint { hqm_reorder_pipe_core.rop_nalb_enq_data.flid } iff (rst_n) { bins valid_flid = {[0:16383]}; ignore_bins invalid_flid = {[16384:32767]}; }
  WCP_ROP_NALB_CMD          : coverpoint { hqm_reorder_pipe_core.rop_nalb_enq_data.cmd} iff (rst_n);
  WCP_ROP_NALB_FLID_PARITY  : coverpoint { hqm_reorder_pipe_core.rop_nalb_enq_data.flid_parity} iff (rst_n);

endgroup

    COVERGROUP        i_COVERGROUP_inst = new();
    ROP_CG_SN_0       i_ROP_CG_SN_0_inst = new();
    ROP_REQUEST_STATE i_ROP_REQUEST_STATE_inst = new(); 

`endif
endmodule
bind hqm_reorder_pipe_core hqm_reorder_pipe_cover i_hqm_reorder_pipe_cover();
`endif
