`ifdef INTEL_INST_ON

module hqm_reorder_pipe_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON

   logic clk;
   logic rst_n;

   // chp_rop_hcw interface
   logic                                            chp_rop_hcw_v;
   logic                                            chp_rop_hcw_ready;
   chp_rop_hcw_t                                    chp_rop_hcw_data;
                                                    
   logic                                            rop_dp_enq_v;
   rop_dp_enq_t                                     rop_dp_enq_data;
   logic                                            rop_dp_enq_ready;
                                                    
   logic                                            rop_nalb_enq_v;
   rop_nalb_enq_t                                   rop_nalb_enq_data;
   logic                                            rop_nalb_enq_ready;
                                                    
   logic                                            rop_qed_dqed_enq_v;
   logic                                            rop_qed_enq_ready;
   logic                                            rop_dqed_enq_ready;
   rop_qed_dqed_enq_t                               rop_qed_dqed_enq_data;
                                                    
   logic                                            rop_lsp_reordercmp_v;
   logic                                            rop_lsp_reordercmp_ready;
   rop_lsp_reordercmp_t                             rop_lsp_reordercmp_data;
                                                    
   logic [1:0]                                      ecc_check_hcw_err_sb;                  
   logic [1:0]                                      ecc_check_hcw_err_mb;                  

   logic [HQM_ROP_CFG_UNIT_NUM_TGTS-1:0]            mux_cfg_req_read_pnc;
   logic [HQM_ROP_CFG_UNIT_NUM_TGTS-1:0]            mux_cfg_req_write_pnc;

   logic          [(HQM_ROP_ALARM_NUM_INF-1) : 0]   int_inf_v;
   aw_alarm_syn_t [(HQM_ROP_ALARM_NUM_INF-1) : 0]   int_inf_data;

   idle_status_t                                    cfg_unit_idle_f;
                                                    
   logic                                            chp_rop_hcw_fifo_push;
   logic                                            dir_rply_req_fifo_push;
   logic                                            ldb_rply_req_fifo_push;
   logic                                            sn_ordered_fifo_push;
   logic                                            sn_complete_fifo_push;
   logic                                            lsp_reordercmp_fifo_push;

   errors_plus_chp_rop_hcw_t                        chp_rop_hcw_fifo_push_data;
   dp_rply_data_t                                   dir_rply_req_fifo_push_data;
   nalb_rply_data_t                                 ldb_rply_req_fifo_push_data;
   logic [(12 -1) : 0]                              sn_ordered_fifo_push_data;
   sn_complete_t                                    sn_complete_fifo_push_data;
   rop_lsp_reordercmp_t                             lsp_reordercmp_fifo_push_data;

   errors_plus_chp_rop_hcw_t                        chp_rop_hcw_fifo_pop_data;
   dp_rply_data_t                                   dir_rply_req_fifo_pop_data;
   nalb_rply_data_t                                 ldb_rply_req_fifo_pop_data;
   logic [(12 -1) : 0]                              sn_ordered_fifo_pop_data;
   sn_complete_t                                    sn_complete_fifo_pop_data;
   rop_lsp_reordercmp_t                             lsp_reordercmp_fifo_pop_data;

   logic [(4*1024)-1: 0]                            sn_order_pipe_health_sn_state_f;

   logic [16:0]                                     sn_fragment_cnt_dir_nxt[4095:0];
   logic [16:0]                                     sn_fragment_cnt_dir_f[4095:0];
   logic [16:0]                                     sn_fragment_cnt_ldb_nxt[4095:0];
   logic [16:0]                                     sn_fragment_cnt_ldb_f[4095:0];
   logic [16:0]                                     sn_completions_nxt[4095:0];
   logic [16:0]                                     sn_completions_f[4095:0];

   logic                                            mux_p3_reord_st_mem_write;
   logic [1 : 0]                                    mux_p3_reord_st_mem_write_addr;
   logic [(21 -1) : 0]                              mux_p3_reord_st_mem_write_data;
   logic                                            mux_p0_reord_st_mem_read;
   logic [1 : 0]                                    mux_p0_reord_st_mem_read_addr;
   logic [(21 -1) : 0]                              p1_reord_st_mem_read_data;
                                                    
   logic                                            mux_p3_reord_lbhp_mem_write;
   logic [11 : 0]                                   mux_p3_reord_lbhp_mem_write_addr;
   logic [(19 -1) : 0]                              mux_p3_reord_lbhp_mem_write_data;
   logic                                            mux_p0_reord_lbhp_mem_read;
   logic [11 : 0]                                   mux_p0_reord_lbhp_mem_read_addr;
   logic [(19 -1) : 0]                              p1_reord_lbhp_mem_read_data;

   logic                                            mux_sn_order_p2_shft0_mem_write;
   logic [4 :0]                                     mux_sn_order_p2_shft0_mem_write_addr;
   logic [11 :0]                                    mux_sn_order_p2_shft0_mem_write_data;
   logic                                            mux_sn_order_p0_shft0_mem_read;
   logic [4 : 0]                                    mux_sn_order_p0_shft0_mem_read_addr;
   logic [11 : 0]                                   sn_order_p1_shft0_mem_read_data;
                                                    
   logic                                            mux_sn_order_p2_shft1_mem_write;
   logic [4 :0]                                     mux_sn_order_p2_shft1_mem_write_addr;
   logic [11 :0]                                    mux_sn_order_p2_shft1_mem_write_data;
   logic                                            mux_sn_order_p0_shft1_mem_read;
   logic [4 : 0]                                    mux_sn_order_p0_shft1_mem_read_addr;
   logic [11 : 0]                                   sn_order_p1_shft1_mem_read_data;
                                                    
   logic                                            mux_sn_order_p2_shft2_mem_write;
   logic [4 :0]                                     mux_sn_order_p2_shft2_mem_write_addr;
   logic [11 :0]                                    mux_sn_order_p2_shft2_mem_write_data;
   logic                                            mux_sn_order_p0_shft2_mem_read;
   logic [4 : 0]                                    mux_sn_order_p0_shft2_mem_read_addr;
   logic [11 : 0]                                   sn_order_p1_shft2_mem_read_data;
                                                    
   logic                                            mux_sn_order_p2_shft3_mem_write;
   logic [4 :0]                                     mux_sn_order_p2_shft3_mem_write_addr;
   logic [11 :0]                                    mux_sn_order_p2_shft3_mem_write_data;
   logic                                            mux_sn_order_p0_shft3_mem_read;
   logic [4 : 0]                                    mux_sn_order_p0_shft3_mem_read_addr;
   logic [11 : 0]                                   sn_order_p1_shft3_mem_read_data;

   logic                                            mux_p0_reord_st_mem_read_f;
   logic                                            mux_p0_reord_lbhp_mem_read_f;
   logic                                            mux_sn_order_p0_shft0_mem_read_f;
   logic                                            mux_sn_order_p0_shft1_mem_read_f;
   logic                                            mux_sn_order_p0_shft2_mem_read_f;
   logic                                            mux_sn_order_p0_shft3_mem_read_f;

   logic                                            cmd_update_sn_order_state;
   logic                                            cmd_noop;
   logic                                            cmd_hcw_enq;
   logic                                            cmd_sys_enq;
   logic                                            cmd_start_sn_reorder;
   logic                                            chp_rop_hcw_db2_out_valid;
   logic                                            chp_rop_hcw_db2_out_ready;

   logic                                            holding_of_hcw_request_while_processing_cfg_ram_request;

   logic [3:0]                                      cmp_v;
   logic [9:0]                                      cmp_sn;
   logic [4:0]                                      cmp_slt;
   logic [3:0]                                      cmp_ready;

   logic [31:0]                                     rop_cnt_hqm_cmd_noop_nxt;
   logic [31:0]                                     rop_cnt_hqm_cmd_noop_f;
   logic [31:0]                                     rop_cnt_hqm_cmd_comp_nxt;
   logic [31:0]                                     rop_cnt_hqm_cmd_comp_f;
   logic [31:0]                                     rop_cnt_hqm_cmd_comp_tok_ret_nxt;
   logic [31:0]                                     rop_cnt_hqm_cmd_comp_tok_ret_f;

   logic [31:0]                                     rop_cnt_hqm_cmd_comp_qtype_ORDERED_nxt;
   logic [31:0]                                     rop_cnt_hqm_cmd_comp_qtype_ORDERED_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_new_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_new_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_new_tok_ret_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_new_tok_ret_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_tok_ret_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_tok_ret_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_frag_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_frag_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_frag_tok_ret_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_frag_tok_ret_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_ORDERED_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_ORDERED_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_f;
logic [31:0]                                     rop_lsp_reordercmp_cnt_nxt;
logic [31:0]                                     rop_lsp_reordercmp_cnt_f;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_replay_nxt;
logic [31:0]                                     rop_cnt_hqm_cmd_enq_replay_f;

logic [31:0]                                     chp_rop_req_running_clk_count_nxt;
logic [31:0]                                     chp_rop_req_running_clk_count_f;
logic [31:0]                                     chp_rop_request_count_nxt;
logic [31:0]                                     chp_rop_request_count_f;
logic [31:0]                                     chp_rop_request_clk_count_nxt;
logic [31:0]                                     chp_rop_request_clk_count_f;

logic [31:0]                                     rop_dp_enq_running_clk_count_nxt;
logic [31:0]                                     rop_dp_enq_running_clk_count_f;
logic [31:0]                                     rop_dp_enq_count_nxt;
logic [31:0]                                     rop_dp_enq_count_f;
logic [31:0]                                     rop_dp_enq_clk_count_nxt;
logic [31:0]                                     rop_dp_enq_clk_count_f;

logic [31:0]                                     rop_nalb_enq_running_clk_count_nxt;
logic [31:0]                                     rop_nalb_enq_running_clk_count_f;
logic [31:0]                                     rop_nalb_enq_count_nxt;
logic [31:0]                                     rop_nalb_enq_count_f;
logic [31:0]                                     rop_nalb_enq_clk_count_nxt;
logic [31:0]                                     rop_nalb_enq_clk_count_f;

logic [31:0]                                     rop_qed_enq_running_clk_count_nxt;
logic [31:0]                                     rop_qed_enq_running_clk_count_f;
logic [31:0]                                     rop_qed_enq_count_nxt;
logic [31:0]                                     rop_qed_enq_count_f;
logic [31:0]                                     rop_qed_enq_clk_count_nxt;
logic [31:0]                                     rop_qed_enq_clk_count_f;

logic [31:0]                                     rop_dqed_enq_running_clk_count_nxt;
logic [31:0]                                     rop_dqed_enq_running_clk_count_f;
logic [31:0]                                     rop_dqed_enq_count_nxt;
logic [31:0]                                     rop_dqed_enq_count_f;
logic [31:0]                                     rop_dqed_enq_clk_count_nxt;
logic [31:0]                                     rop_dqed_enq_clk_count_f;

logic [31:0]                                     grp0_cmp_running_clk_count_nxt;
logic [31:0]                                     grp0_cmp_running_clk_count_f;
logic [31:0]                                     grp0_cmp_count_nxt;
logic [31:0]                                     grp0_cmp_count_f;
logic [31:0]                                     grp0_cmp_clk_count_nxt;
logic [31:0]                                     grp0_cmp_clk_count_f;

logic [31:0]                                     grp1_cmp_running_clk_count_nxt;
logic [31:0]                                     grp1_cmp_running_clk_count_f;
logic [31:0]                                     grp1_cmp_count_nxt;
logic [31:0]                                     grp1_cmp_count_f;
logic [31:0]                                     grp1_cmp_clk_count_nxt;
logic [31:0]                                     grp1_cmp_clk_count_f;

logic [31:0]                                     grp2_cmp_running_clk_count_nxt;
logic [31:0]                                     grp2_cmp_running_clk_count_f;
logic [31:0]                                     grp2_cmp_count_nxt;
logic [31:0]                                     grp2_cmp_count_f;
logic [31:0]                                     grp2_cmp_clk_count_nxt;
logic [31:0]                                     grp2_cmp_clk_count_f;

logic [31:0]                                     grp3_cmp_running_clk_count_nxt;
logic [31:0]                                     grp3_cmp_running_clk_count_f;
logic [31:0]                                     grp3_cmp_count_nxt;
logic [31:0]                                     grp3_cmp_count_f;
logic [31:0]                                     grp3_cmp_clk_count_nxt;
logic [31:0]                                     grp3_cmp_clk_count_f;


logic [31:0]                                     number_of_expected_completions_nxt;
logic [31:0]                                     number_of_expected_completions_f;

logic [(4*1)-1: 0]                               sn_state_err_any_f;

   // assigns

   assign clk =  hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_gated_clk;
   assign rst_n =  hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_gated_rst_n;

   // interfaces
   assign chp_rop_hcw_v                        = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_v;
   assign chp_rop_hcw_ready                    = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_ready;
   assign chp_rop_hcw_data                     = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_data;
                                               
   assign rop_dp_enq_v                         = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_dp_enq_v;
   assign rop_dp_enq_ready                     = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_dp_enq_ready;
   assign rop_dp_enq_data                      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_dp_enq_data;

   assign rop_nalb_enq_v                       = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_nalb_enq_v;
   assign rop_nalb_enq_ready                   = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_nalb_enq_ready;
   assign rop_nalb_enq_data                    = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_nalb_enq_data;
                                               
   assign rop_qed_dqed_enq_v                   = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_qed_dqed_enq_v;
   assign rop_qed_enq_ready                    = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_qed_enq_ready;
   assign rop_dqed_enq_ready                   = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_dqed_enq_ready;
   assign rop_qed_dqed_enq_data                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_qed_dqed_enq_data;

   assign rop_lsp_reordercmp_v                 = { 2'd0 , hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_lsp_reordercmp_v } ;
   assign rop_lsp_reordercmp_ready             = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_lsp_reordercmp_ready;
   assign rop_lsp_reordercmp_data              = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.rop_lsp_reordercmp_data;
   //assign mux_cfg_req_read_pnc                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_cfg_req_read_pnc;
   //assign mux_cfg_req_write_pnc                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_cfg_req_write_pnc;

   assign cfg_unit_idle_f                      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_f;

   assign chp_rop_hcw_fifo_push                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_push;
   assign dir_rply_req_fifo_push               = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.dir_rply_req_fifo_push;
   assign ldb_rply_req_fifo_push               = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_push;
   assign sn_ordered_fifo_push                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_push;
   assign sn_complete_fifo_push                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_push;
   assign lsp_reordercmp_fifo_push             = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_push;

   assign chp_rop_hcw_fifo_push_data           = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_push_data;
   assign dir_rply_req_fifo_push_data          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.dir_rply_req_fifo_push_data;
   assign ldb_rply_req_fifo_push_data          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_push_data;
   assign sn_ordered_fifo_push_data            = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_push_data;
   assign sn_complete_fifo_push_data           = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_push_data;
   assign lsp_reordercmp_fifo_push_data        = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_push_data;

   assign chp_rop_hcw_fifo_pop                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_pop;
   assign dir_rply_req_fifo_pop                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.dir_rply_req_fifo_pop;
   assign ldb_rply_req_fifo_pop                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_pop;
   assign sn_ordered_fifo_pop                  = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_pop;
   assign sn_complete_fifo_pop                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop;
   assign lsp_reordercmp_fifo_pop              = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_pop;

   assign chp_rop_hcw_fifo_pop_data           = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_fifo_pop_data;
   assign dir_rply_req_fifo_pop_data          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.dir_rply_req_fifo_pop_data;
   assign ldb_rply_req_fifo_pop_data          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ldb_rply_req_fifo_pop_data;
   assign sn_ordered_fifo_pop_data            = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_pop_data;
   assign sn_complete_fifo_pop_data           = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data;
   assign lsp_reordercmp_fifo_pop_data        = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.lsp_reordercmp_fifo_pop_data;

   // ram access
   //assign mux_p3_reord_st_mem_write           = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p3_reord_st_mem_write;
   //assign mux_p3_reord_st_mem_write_addr      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p3_reord_st_mem_write_addr;
   //assign mux_p3_reord_st_mem_write_data      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p3_reord_st_mem_write_data;
   //assign mux_p0_reord_st_mem_read            = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p0_reord_st_mem_read      ;
   //assign mux_p0_reord_st_mem_read_addr       = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p0_reord_st_mem_read_addr ;
   //assign p1_reord_st_mem_read_data           = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_reord_st_mem_read_data     ;
          
   //assign mux_p3_reord_lbhp_mem_write         = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p3_reord_lbhp_mem_write         ;
   //assign mux_p3_reord_lbhp_mem_write_addr    = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p3_reord_lbhp_mem_write_addr    ;
   //assign mux_p3_reord_lbhp_mem_write_data    = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p3_reord_lbhp_mem_write_data    ;
   //assign mux_p0_reord_lbhp_mem_read          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p0_reord_lbhp_mem_read          ;
   //assign mux_p0_reord_lbhp_mem_read_addr     = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_p0_reord_lbhp_mem_read_addr     ;
   //assign p1_reord_lbhp_mem_read_data         = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.p1_reord_lbhp_mem_read_data         ;
                                                                                                     
   //assign mux_sn_order_p2_shft0_mem_write      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write     [0*1  +:  1];
   //assign mux_sn_order_p2_shft0_mem_write_addr = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_addr[0*5  +:  5];
   //assign mux_sn_order_p2_shft0_mem_write_data = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_data[0*12 +: 12];
   //assign mux_sn_order_p0_shft0_mem_read       = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read      [0*1  +:  1];
   //assign mux_sn_order_p0_shft0_mem_read_addr  = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read_addr [0*5  +:  5];
   //assign sn_order_p1_shft0_mem_read_data      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_order_p1_shft_mem_read_data     [0*12 +: 12];
          
   //assign mux_sn_order_p2_shft1_mem_write      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write     [1*1  +:  1];
   //assign mux_sn_order_p2_shft1_mem_write_addr = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_addr[1*5  +:  5];
   //assign mux_sn_order_p2_shft1_mem_write_data = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_data[1*12 +: 12];
   //assign mux_sn_order_p0_shft1_mem_read       = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read      [1*1  +:  1];
   //assign mux_sn_order_p0_shft1_mem_read_addr  = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read_addr [1*5  +:  5];
   //assign sn_order_p1_shft1_mem_read_data      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_order_p1_shft_mem_read_data     [1*12 +: 12];
          
   //assign mux_sn_order_p2_shft2_mem_write      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write     [2*1  +:  1];
   //assign mux_sn_order_p2_shft2_mem_write_addr = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_addr[2*5  +:  5];
   //assign mux_sn_order_p2_shft2_mem_write_data = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_data[2*12 +: 12];
   //assign mux_sn_order_p0_shft2_mem_read       = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read      [2*1  +:  1];
   //assign mux_sn_order_p0_shft2_mem_read_addr  = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read_addr [2*5  +:  5];
   //assign sn_order_p1_shft2_mem_read_data      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_order_p1_shft_mem_read_data     [2*12 +: 12];
          
   //assign mux_sn_order_p2_shft3_mem_write      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write     [3*1  +:  1];
   //assign mux_sn_order_p2_shft3_mem_write_addr = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_addr[3*5  +:  5];
   //assign mux_sn_order_p2_shft3_mem_write_data = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p2_shft_mem_write_data[3*12 +: 12];
   //assign mux_sn_order_p0_shft3_mem_read       = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read      [3*1  +:  1];
   //assign mux_sn_order_p0_shft3_mem_read_addr  = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.mux_sn_order_p0_shft_mem_read_addr [3*5  +:  5];
   //assign sn_order_p1_shft3_mem_read_data      = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_order_p1_shft_mem_read_data     [3*12 +: 12];

   // internal events

   assign cmd_update_sn_order_state            = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cmd_update_sn_order_state;
   assign cmd_noop                             = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cmd_noop;
   assign cmd_hcw_enq                          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cmd_hcw_enq;
   assign cmd_sys_enq                          = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cmd_sys_enq;
   assign cmd_start_sn_reorder                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cmd_start_sn_reorder;

   assign ecc_check_hcw_err_sb                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ecc_check_hcw_err_sb;
   assign ecc_check_hcw_err_mb                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.ecc_check_hcw_err_mb;
   assign chp_rop_hcw_db2_out_valid            = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid; 
   assign chp_rop_hcw_db2_out_ready            = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_ready; 

   // indicator to show cfg ram request is pending while we purge the pipeline
   assign holding_of_hcw_request_while_processing_cfg_ram_request = (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.cfg_unit_idle_nxt.cfg_busy == 1'b1) & chp_rop_hcw_db2_out_valid;

   assign cmp_v                                  = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_aw_sn_order_select;
   assign cmp_sn                                 = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.sn[9:0];
   assign cmp_slt                                = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_complete_fifo_pop_data.grp_slt[4:0];
   assign cmp_ready                              = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_aw_sn_ready;

   assign sn_order_pipe_health_sn_state_f        = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_order_pipe_health_sn_state_f;

   assign sn_state_err_any_f                     = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_state_err_any_f;


   always_ff @(posedge clk or negedge rst_n ) begin
   integer sn_i;
    if (~rst_n) begin
       rop_cnt_hqm_cmd_noop_f <= '0;
       rop_cnt_hqm_cmd_comp_f <= '0;
       rop_cnt_hqm_cmd_comp_tok_ret_f <= '0;
       rop_cnt_hqm_cmd_comp_qtype_ORDERED_f <= '0;
       rop_cnt_hqm_cmd_enq_new_f <= '0;
       rop_cnt_hqm_cmd_enq_new_tok_ret_f <= '0;
       rop_cnt_hqm_cmd_enq_comp_f <= '0;
       rop_cnt_hqm_cmd_enq_comp_tok_ret_f <= '0;
       rop_cnt_hqm_cmd_enq_frag_f <= '0;
       rop_cnt_hqm_cmd_enq_frag_tok_ret_f <= '0;
       rop_cnt_hqm_cmd_enq_comp_ORDERED_f <= '0;
       rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_f <= '0;
       rop_cnt_hqm_cmd_enq_replay_f <= '0;
       rop_lsp_reordercmp_cnt_f <= '0;
       number_of_expected_completions_f <= '0;

       chp_rop_request_count_f <= '0;
       rop_dp_enq_count_f <= '0;
       rop_dp_enq_clk_count_f <= '0;
       rop_nalb_enq_count_f <= '0;
       rop_nalb_enq_clk_count_f <= '0;
       rop_qed_enq_count_f <= '0;
       rop_qed_enq_clk_count_f <= '0;
       rop_dqed_enq_count_f <= '0;
       rop_dqed_enq_clk_count_f <= '0;

       chp_rop_req_running_clk_count_f <= '0;
       rop_dp_enq_running_clk_count_f <= '0;
       rop_nalb_enq_running_clk_count_f <= '0;
       rop_qed_enq_running_clk_count_f <= '0;
       rop_dqed_enq_running_clk_count_f <= '0;

       grp0_cmp_running_clk_count_f <= '0;
       grp0_cmp_count_f <= '0;
       grp0_cmp_clk_count_f <= '0;

       grp1_cmp_running_clk_count_f <= '0;
       grp1_cmp_count_f <= '0;
       grp1_cmp_clk_count_f <= '0;

       grp2_cmp_running_clk_count_f <= '0;
       grp2_cmp_count_f <= '0;
       grp2_cmp_clk_count_f <= '0;

       grp3_cmp_running_clk_count_f <= '0;
       grp3_cmp_count_f <= '0;
       grp3_cmp_clk_count_f <= '0;

       for (sn_i=0; sn_i<4096; sn_i=sn_i+1) begin
          sn_fragment_cnt_dir_f[sn_i] <= '0;
          sn_fragment_cnt_ldb_f[sn_i] <= '0;
          sn_completions_f[sn_i] <= '0;
       end

       chp_rop_request_clk_count_f <= '0;

    end else begin
       rop_cnt_hqm_cmd_noop_f <= rop_cnt_hqm_cmd_noop_nxt;
       rop_cnt_hqm_cmd_comp_f <= rop_cnt_hqm_cmd_comp_nxt;
       rop_cnt_hqm_cmd_comp_tok_ret_f <= rop_cnt_hqm_cmd_comp_tok_ret_nxt;
       rop_cnt_hqm_cmd_comp_qtype_ORDERED_f <= rop_cnt_hqm_cmd_comp_qtype_ORDERED_nxt;

       rop_cnt_hqm_cmd_enq_new_f <= rop_cnt_hqm_cmd_enq_new_nxt;
       rop_cnt_hqm_cmd_enq_new_tok_ret_f <= rop_cnt_hqm_cmd_enq_new_tok_ret_nxt;
       rop_cnt_hqm_cmd_enq_comp_f <= rop_cnt_hqm_cmd_enq_comp_nxt;
       rop_cnt_hqm_cmd_enq_comp_tok_ret_f <= rop_cnt_hqm_cmd_enq_comp_tok_ret_nxt;
       rop_cnt_hqm_cmd_enq_frag_f <= rop_cnt_hqm_cmd_enq_frag_nxt;
       rop_cnt_hqm_cmd_enq_frag_tok_ret_f <= rop_cnt_hqm_cmd_enq_frag_tok_ret_nxt;
       rop_cnt_hqm_cmd_enq_comp_ORDERED_f <= rop_cnt_hqm_cmd_enq_comp_ORDERED_nxt;
       rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_f <= rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_nxt;
       rop_cnt_hqm_cmd_enq_replay_f <= rop_cnt_hqm_cmd_enq_replay_nxt;
       rop_lsp_reordercmp_cnt_f <= rop_lsp_reordercmp_cnt_nxt;
       number_of_expected_completions_f <= number_of_expected_completions_nxt;

       chp_rop_req_running_clk_count_f <= chp_rop_req_running_clk_count_nxt;
       rop_dp_enq_running_clk_count_f <= rop_dp_enq_running_clk_count_nxt;
       rop_nalb_enq_running_clk_count_f <= rop_nalb_enq_running_clk_count_nxt;
       rop_qed_enq_running_clk_count_f <= rop_qed_enq_running_clk_count_nxt;
       rop_dqed_enq_running_clk_count_f <= rop_dqed_enq_running_clk_count_nxt;

       chp_rop_request_count_f <= chp_rop_request_count_nxt;
       chp_rop_request_clk_count_f <= chp_rop_request_clk_count_nxt;

       rop_dp_enq_count_f <= rop_dp_enq_count_nxt;
       rop_dp_enq_clk_count_f <= rop_dp_enq_clk_count_nxt; 

       rop_nalb_enq_count_f <= rop_nalb_enq_count_nxt;
       rop_nalb_enq_clk_count_f <= rop_nalb_enq_clk_count_nxt;
       rop_qed_enq_count_f <= rop_qed_enq_count_nxt;
       rop_qed_enq_clk_count_f <= rop_qed_enq_clk_count_nxt;
       rop_dqed_enq_count_f <= rop_dqed_enq_count_nxt;
       rop_dqed_enq_clk_count_f <= rop_dqed_enq_clk_count_nxt;

       grp0_cmp_running_clk_count_f <= grp0_cmp_running_clk_count_nxt;
       grp0_cmp_count_f <= grp0_cmp_count_nxt;
       grp0_cmp_clk_count_f <= grp0_cmp_clk_count_nxt;

       grp1_cmp_running_clk_count_f <= grp1_cmp_running_clk_count_nxt;
       grp1_cmp_count_f <= grp1_cmp_count_nxt;
       grp1_cmp_clk_count_f <= grp1_cmp_clk_count_nxt;

       grp2_cmp_running_clk_count_f <= grp2_cmp_running_clk_count_nxt;
       grp2_cmp_count_f <= grp2_cmp_count_nxt;
       grp2_cmp_clk_count_f <= grp2_cmp_clk_count_nxt;

       grp3_cmp_running_clk_count_f <= grp3_cmp_running_clk_count_nxt;
       grp3_cmp_count_f <= grp3_cmp_count_nxt;
       grp3_cmp_clk_count_f <= grp3_cmp_clk_count_nxt;
    
    end
end 



always_comb begin

       rop_cnt_hqm_cmd_noop_nxt = rop_cnt_hqm_cmd_noop_f;
       rop_cnt_hqm_cmd_comp_nxt = rop_cnt_hqm_cmd_comp_f;
       rop_cnt_hqm_cmd_comp_tok_ret_nxt = rop_cnt_hqm_cmd_comp_tok_ret_f;
       rop_cnt_hqm_cmd_comp_qtype_ORDERED_nxt = rop_cnt_hqm_cmd_comp_qtype_ORDERED_f;
       rop_cnt_hqm_cmd_enq_new_nxt = rop_cnt_hqm_cmd_enq_new_f;
       rop_cnt_hqm_cmd_enq_new_tok_ret_nxt = rop_cnt_hqm_cmd_enq_new_tok_ret_f;
       rop_cnt_hqm_cmd_enq_comp_nxt = rop_cnt_hqm_cmd_enq_comp_f;
       rop_cnt_hqm_cmd_enq_comp_tok_ret_nxt = rop_cnt_hqm_cmd_enq_comp_tok_ret_f;
       rop_cnt_hqm_cmd_enq_frag_nxt = rop_cnt_hqm_cmd_enq_frag_f;
       rop_cnt_hqm_cmd_enq_frag_tok_ret_nxt = rop_cnt_hqm_cmd_enq_frag_tok_ret_f;
       rop_cnt_hqm_cmd_enq_comp_ORDERED_nxt = rop_cnt_hqm_cmd_enq_comp_ORDERED_f;
       rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_nxt = rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_f;
       rop_cnt_hqm_cmd_enq_replay_nxt = rop_cnt_hqm_cmd_enq_replay_f;
     
       rop_lsp_reordercmp_cnt_nxt = rop_lsp_reordercmp_cnt_f;
       number_of_expected_completions_nxt = number_of_expected_completions_f;

       chp_rop_req_running_clk_count_nxt = chp_rop_req_running_clk_count_f;
       rop_dp_enq_running_clk_count_nxt = rop_dp_enq_running_clk_count_f;
       rop_nalb_enq_running_clk_count_nxt = rop_nalb_enq_running_clk_count_f;
       rop_qed_enq_running_clk_count_nxt = rop_qed_enq_running_clk_count_f;
       rop_dqed_enq_running_clk_count_nxt = rop_dqed_enq_running_clk_count_f;

       chp_rop_request_count_nxt = chp_rop_request_count_f;
       chp_rop_request_clk_count_nxt <= chp_rop_request_clk_count_f;

       rop_dp_enq_count_nxt = rop_dp_enq_count_f;
       rop_dp_enq_clk_count_nxt <= rop_dp_enq_clk_count_f; 

       rop_nalb_enq_count_nxt = rop_nalb_enq_count_f;
       rop_nalb_enq_clk_count_nxt = rop_nalb_enq_clk_count_f;
       rop_qed_enq_count_nxt = rop_qed_enq_count_f;
       rop_qed_enq_clk_count_nxt = rop_qed_enq_clk_count_f;
       rop_dqed_enq_count_nxt = rop_dqed_enq_count_f;
       rop_dqed_enq_clk_count_nxt = rop_dqed_enq_clk_count_f;


       grp0_cmp_running_clk_count_nxt = grp0_cmp_running_clk_count_f;
       grp0_cmp_count_nxt = grp0_cmp_count_f;
       grp0_cmp_clk_count_nxt = grp0_cmp_clk_count_f;

       grp1_cmp_running_clk_count_nxt = grp1_cmp_running_clk_count_f;
       grp1_cmp_count_nxt = grp1_cmp_count_f;
       grp1_cmp_clk_count_nxt = grp1_cmp_clk_count_f;

       grp2_cmp_running_clk_count_nxt = grp2_cmp_running_clk_count_f;
       grp2_cmp_count_nxt = grp2_cmp_count_f;
       grp2_cmp_clk_count_nxt = grp2_cmp_clk_count_f;

       grp3_cmp_running_clk_count_nxt = grp3_cmp_running_clk_count_f;
       grp3_cmp_count_nxt = grp3_cmp_count_f;
       grp3_cmp_clk_count_nxt = grp3_cmp_clk_count_f;

       // ----------------- 
       if (chp_rop_hcw_v & chp_rop_hcw_ready) begin
         chp_rop_request_count_nxt = chp_rop_request_count_f + 32'd1;
         chp_rop_request_clk_count_nxt <= chp_rop_req_running_clk_count_f;
       end

       if (chp_rop_req_running_clk_count_f==32'h0) begin
          if (chp_rop_hcw_v) begin
             chp_rop_req_running_clk_count_nxt = chp_rop_req_running_clk_count_f + 32'b1;
          end
       end
       else begin
          chp_rop_req_running_clk_count_nxt = chp_rop_req_running_clk_count_f + 32'd1;
       end
       // ----------------- 
       if (rop_dp_enq_v & rop_dp_enq_ready) begin
          rop_dp_enq_count_nxt = rop_dp_enq_count_f + 32'd1;
          rop_dp_enq_clk_count_nxt <= rop_dp_enq_running_clk_count_f; 
       end

       if (rop_dp_enq_running_clk_count_f==32'h0) begin
          if (rop_dp_enq_v) begin
             rop_dp_enq_running_clk_count_nxt = rop_dp_enq_running_clk_count_f + 32'b1;
          end
       end
       else begin
             rop_dp_enq_running_clk_count_nxt = rop_dp_enq_running_clk_count_f + 32'b1;
       end
       // ----------------- 
       if (rop_nalb_enq_v & rop_nalb_enq_ready) begin
          rop_nalb_enq_count_nxt = rop_nalb_enq_count_f + 32'd1;
          rop_nalb_enq_clk_count_nxt = rop_nalb_enq_running_clk_count_f;
       end

       if (rop_nalb_enq_running_clk_count_f==32'h0) begin
          if (rop_nalb_enq_v) begin
             rop_nalb_enq_running_clk_count_nxt = rop_nalb_enq_running_clk_count_f + 32'b1;
          end
       end
       else begin
             rop_nalb_enq_running_clk_count_nxt = rop_nalb_enq_running_clk_count_f + 32'b1;
       end
       // ----------------- 
       if ( rop_qed_dqed_enq_v & rop_qed_enq_ready & ( (rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_LB) | (rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_LB_NOOP) ) ) begin
          rop_qed_enq_count_nxt = rop_qed_enq_count_f + 32'd1;
          rop_qed_enq_clk_count_nxt = rop_qed_enq_running_clk_count_f;
       end

       if (rop_qed_enq_running_clk_count_f==32'h0) begin
          if (rop_qed_dqed_enq_v) begin
             rop_qed_enq_running_clk_count_nxt = rop_qed_enq_running_clk_count_f+ 32'b1;
          end
       end
       else begin
             rop_qed_enq_running_clk_count_nxt = rop_qed_enq_running_clk_count_f+ 32'b1;
       end
       // ----------------- 
       if ( rop_qed_dqed_enq_v & rop_dqed_enq_ready & ( (rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_DIR) | (rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_DIR_NOOP) ) ) begin
          rop_dqed_enq_count_nxt = rop_dqed_enq_count_f + 32'd1;
          rop_dqed_enq_clk_count_nxt =  rop_dqed_enq_running_clk_count_f;
       end

       if (rop_dqed_enq_running_clk_count_f==32'h0) begin
          if (rop_qed_dqed_enq_v) begin
             rop_dqed_enq_running_clk_count_nxt = rop_dqed_enq_running_clk_count_f+ 32'b1;
          end
       end
       else begin
             rop_dqed_enq_running_clk_count_nxt = rop_dqed_enq_running_clk_count_f+ 32'b1;
       end
       // ----------------- 


       if (grp0_cmp_running_clk_count_f==32'd0) begin
          if (cmp_v[0]) begin
            grp0_cmp_running_clk_count_nxt = grp0_cmp_running_clk_count_f + 32'd1;
          end
       end 
       else begin
          grp0_cmp_running_clk_count_nxt = grp0_cmp_running_clk_count_f + 32'd1;
       end
       if (grp1_cmp_running_clk_count_f==32'd0) begin
          if (cmp_v[1]) begin
            grp1_cmp_running_clk_count_nxt = grp1_cmp_running_clk_count_f + 32'd1;
          end
       end 
       else begin
          grp1_cmp_running_clk_count_nxt = grp1_cmp_running_clk_count_f + 32'd1;
       end
       if (grp2_cmp_running_clk_count_f==32'd0) begin
          if (cmp_v[2]) begin
            grp2_cmp_running_clk_count_nxt = grp2_cmp_running_clk_count_f + 32'd1;
          end
       end 
       else begin
          grp2_cmp_running_clk_count_nxt = grp2_cmp_running_clk_count_f + 32'd1;
       end
       if (grp3_cmp_running_clk_count_f==32'd0) begin
          if (cmp_v[3]) begin
            grp3_cmp_running_clk_count_nxt = grp3_cmp_running_clk_count_f + 32'd1;
          end
       end 
       else begin
          grp3_cmp_running_clk_count_nxt = grp3_cmp_running_clk_count_f + 32'd1;
       end

       if ( cmp_v[0] & cmp_ready[0] ) begin
          grp0_cmp_count_nxt = grp0_cmp_count_f + 32'd1;
          grp0_cmp_clk_count_nxt = grp0_cmp_running_clk_count_f;
       end
       if ( cmp_v[1] & cmp_ready[1] ) begin
          grp1_cmp_count_nxt = grp1_cmp_count_f + 32'd1;
          grp1_cmp_clk_count_nxt = grp1_cmp_running_clk_count_f;
       end
       if ( cmp_v[2] & cmp_ready[2] ) begin
          grp2_cmp_count_nxt = grp2_cmp_count_f + 32'd1;
          grp2_cmp_clk_count_nxt = grp2_cmp_running_clk_count_f;
       end
       if ( cmp_v[3] & cmp_ready[3] ) begin
          grp3_cmp_count_nxt = grp3_cmp_count_f + 32'd1;
          grp3_cmp_clk_count_nxt = grp3_cmp_running_clk_count_f;
       end


      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.sn_ordered_fifo_pop) begin number_of_expected_completions_nxt = number_of_expected_completions_f + 1; end

      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_valid_req & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_ready & (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_NEW_HCW) ) begin
     
      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_NOOP) begin
            rop_cnt_hqm_cmd_noop_nxt = rop_cnt_hqm_cmd_noop_f + 1'd1;
      end

      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_COMP) begin
            rop_cnt_hqm_cmd_comp_nxt = rop_cnt_hqm_cmd_comp_f + 1'd1;
      end
      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_COMP_TOK_RET) begin
            rop_cnt_hqm_cmd_comp_nxt = rop_cnt_hqm_cmd_comp_f + 1'd1;
            if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype == ORDERED) begin
                rop_cnt_hqm_cmd_comp_qtype_ORDERED_nxt = rop_cnt_hqm_cmd_comp_qtype_ORDERED_f + 1 ;
            end
      end
      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_ENQ_NEW) begin
            rop_cnt_hqm_cmd_enq_new_nxt =rop_cnt_hqm_cmd_enq_new_f + 1'd1;
      end
      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_ENQ_NEW_TOK_RET) begin
            rop_cnt_hqm_cmd_enq_new_tok_ret_nxt =rop_cnt_hqm_cmd_enq_new_tok_ret_f + 1'd1;
      end

      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_ENQ_COMP) begin
            rop_cnt_hqm_cmd_enq_comp_nxt =rop_cnt_hqm_cmd_comp_f + 1'd1;
            if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype == ORDERED) begin
                rop_cnt_hqm_cmd_enq_comp_ORDERED_nxt = rop_cnt_hqm_cmd_enq_comp_ORDERED_f + 1;
            end
      end

      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_ENQ_FRAG) begin
            rop_cnt_hqm_cmd_enq_frag_nxt =rop_cnt_hqm_cmd_enq_frag_f + 1'd1;
      end
      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_ENQ_FRAG_TOK_RET) begin
            rop_cnt_hqm_cmd_enq_frag_tok_ret_nxt =rop_cnt_hqm_cmd_enq_frag_tok_ret_f + 1'd1;
      end

      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hcw_cmd.hcw_cmd_dec[3:0] == HQM_CMD_ENQ_COMP_TOK_RET) begin
            rop_cnt_hqm_cmd_enq_comp_tok_ret_nxt =rop_cnt_hqm_cmd_comp_tok_ret_f + 1'd1;
            if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qtype == ORDERED) begin
                rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_nxt = rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_f + 1;
            end 
      end

      if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cmd==CHP_ROP_ENQ_REPLAY_HCW) begin
         rop_cnt_hqm_cmd_enq_replay_nxt <= rop_cnt_hqm_cmd_enq_replay_f;
      end

      end

      if (rop_lsp_reordercmp_v & rop_lsp_reordercmp_ready) begin
            rop_lsp_reordercmp_cnt_nxt = rop_lsp_reordercmp_cnt_f + 1'd1;
      end

end
    

   always_comb begin
       for (int loop_inf=0; loop_inf<HQM_ROP_ALARM_NUM_INF; loop_inf=loop_inf+1) begin 
          int_inf_v[loop_inf]    = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.int_inf_v[loop_inf];
          int_inf_data[loop_inf] = hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.int_inf_data[loop_inf];
       
       end  
   end

   always_ff @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
           mux_p0_reord_st_mem_read_f <= '0;
           mux_p0_reord_lbhp_mem_read_f <= '0;
      end
      else begin
            mux_p0_reord_st_mem_read_f      <= mux_p0_reord_st_mem_read      ;
            mux_p0_reord_lbhp_mem_read_f    <= mux_p0_reord_lbhp_mem_read   ;
            mux_sn_order_p0_shft0_mem_read_f<= mux_sn_order_p0_shft0_mem_read;
            mux_sn_order_p0_shft1_mem_read_f<= mux_sn_order_p0_shft1_mem_read;
            mux_sn_order_p0_shft2_mem_read_f<= mux_sn_order_p0_shft2_mem_read;
            mux_sn_order_p0_shft3_mem_read_f<= mux_sn_order_p0_shft3_mem_read;
      end
   end // always_ff

   always_ff @(posedge clk) begin


if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

  //    for ( int i = 0 ; i < HQM_ROP_CFG_UNIT_NUM_TGTS ; i++) begin
  //      if ( rst_n & mux_cfg_req_write_pnc [ i ] ) begin
  //        $display("@%0t [ROP_DEBUG] \
  //        ,%-30s \
  //        ,target:%02x \
  //        ,%m"
  //        ,$time
  //        , "CFG_WRITE :"
  //        , i
  //        ) ;
  //      end
  //      if ( rst_n & mux_cfg_req_read_pnc [ i ] ) begin
  //        $display("@%0t [ROP_DEBUG] \
  //        ,%-30s \
  //        ,target:%02x \
  //        ,%m"
  //        ,$time
  //        , "CFG_READ  :"
  //        , i
  //        ) ;
  //      end
  //    end // for i

      // display incoming hcw from chp
      if (rst_n & chp_rop_hcw_v & chp_rop_hcw_ready ) begin

           if ( (chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec==HQM_CMD_COMP) |
                (chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec==HQM_CMD_COMP_TOK_RET) ) begin

            $display("@%0tps [ROP_DEBUG], cmd:%h(%s) hcw_cmd:%h(%s) hist_list_info: qtype:%s qpri:%h qid:%h qidix:%h qid_sn_mode:%h qid_sn_slot:%h sn_fid:%h"
                     ,$time
                     ,chp_rop_hcw_data.cmd
                     ,chp_rop_hcw_data.cmd.name
                     ,chp_rop_hcw_data.hcw_cmd
                     ,chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec.name
                     ,chp_rop_hcw_data.hist_list_info.qtype.name
                     ,chp_rop_hcw_data.hist_list_info.qpri
                     ,chp_rop_hcw_data.hist_list_info.qid
                     ,chp_rop_hcw_data.hist_list_info.qidix
                     ,chp_rop_hcw_data.hist_list_info.reord_mode
                     ,chp_rop_hcw_data.hist_list_info.reord_slot
                     ,chp_rop_hcw_data.hist_list_info.sn_fid
                    );
           end
           else if ( (chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec==HQM_CMD_ENQ_COMP) |
                (chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec==HQM_CMD_ENQ_COMP_TOK_RET) ) begin

            $display("@%0tps [ROP_DEBUG], cmd:%h(%s) hcw_cmd:%h(%s) hist_list_info: qtype:%s qpri:%h qid:%h qidix:%h qid_sn_mode:%h qid_sn_slot:%h sn_fid:%h"
                     ,$time
                     ,chp_rop_hcw_data.cmd
                     ,chp_rop_hcw_data.cmd.name
                     ,chp_rop_hcw_data.hcw_cmd
                     ,chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec.name
                     ,chp_rop_hcw_data.hist_list_info.qtype.name
                     ,chp_rop_hcw_data.hist_list_info.qpri
                     ,chp_rop_hcw_data.hist_list_info.qid
                     ,chp_rop_hcw_data.hist_list_info.qidix
                     ,chp_rop_hcw_data.hist_list_info.reord_mode
                     ,chp_rop_hcw_data.hist_list_info.reord_slot
                     ,chp_rop_hcw_data.hist_list_info.sn_fid
                    );
           end
           else if ( (chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec==HQM_CMD_ENQ_FRAG) |
                (chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec==HQM_CMD_ENQ_FRAG_TOK_RET) ) begin

            $display("@%0tps [ROP_DEBUG], cmd:%h(%s) hcw_cmd:%h(%s) hist_list_info: qtype:%s qpri:%h qid:%h qidix:%h qid_sn_mode:%h qid_sn_slot:%h sn_fid:%h"
                     ,$time
                     ,chp_rop_hcw_data.cmd
                     ,chp_rop_hcw_data.cmd.name
                     ,chp_rop_hcw_data.hcw_cmd
                     ,chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec.name
                     ,chp_rop_hcw_data.hist_list_info.qtype.name
                     ,chp_rop_hcw_data.hist_list_info.qpri
                     ,chp_rop_hcw_data.hist_list_info.qid
                     ,chp_rop_hcw_data.hist_list_info.qidix
                     ,chp_rop_hcw_data.hist_list_info.reord_mode
                     ,chp_rop_hcw_data.hist_list_info.reord_slot
                     ,chp_rop_hcw_data.hist_list_info.sn_fid
                    );
           end
           else if (rst_n & chp_rop_hcw_v & chp_rop_hcw_ready & (chp_rop_hcw_data.cmd==CHP_ROP_ENQ_REPLAY_HCW) ) begin
              $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, flid_parity:%h, hist_list_info.id:%h, hist_list_info.qidix:%h, hist_list_info.qpri:%h, hcw_cmd:%s, cq_hcw:%h, cq_hcw_ecc:%h"
                       ,$time
                       ,chp_rop_hcw_data.cmd.name
                       ,chp_rop_hcw_data.flid
                       ,chp_rop_hcw_data.flid_parity
                       ,chp_rop_hcw_data.hist_list_info.qid
                       ,chp_rop_hcw_data.hist_list_info.qidix
                       ,chp_rop_hcw_data.hist_list_info.qpri
                       ,chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec.name
                       ,chp_rop_hcw_data.cq_hcw
                       ,chp_rop_hcw_data.cq_hcw_ecc
                      );
           end
           else begin
              //$display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, flid_parity:%h, msg_info.qid:%h, msg_info.qpri:%h, hcw_cmd:%s, cq_hcw:%h, cq_hcw_ecc:%h"
              $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, flid_parity:%h, msg_info.qpri:%h, hcw_cmd:%s, cq_hcw:%h, cq_hcw_ecc:%h"
                       ,$time
                       ,chp_rop_hcw_data.cmd.name
                       ,chp_rop_hcw_data.flid
                       ,chp_rop_hcw_data.flid_parity
                       //,chp_rop_hcw_data.cq_hcw.msg_info.qid
                       ,chp_rop_hcw_data.cq_hcw.msg_info.qpri
                       ,chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec.name
                       ,chp_rop_hcw_data.cq_hcw
                       ,chp_rop_hcw_data.cq_hcw_ecc
                      );
           
           end 

      end


      if (( rst_n === 1 ) && ( (|ecc_check_hcw_err_sb) === 1) ) begin  // Careful not to display "error" when running xprop
         $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, ECC single bit error detected "
                  ,$time
                  ,chp_rop_hcw_data.cmd.name
                  ,chp_rop_hcw_data.flid
                  ,chp_rop_hcw_data.flid_parity
                 );
      end
      if (( rst_n === 1 ) && ( (|ecc_check_hcw_err_mb) === 1) ) begin  // Careful not to display "error" when running xprop
         $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, ECC multi bit error detected "
                  ,$time
                  ,chp_rop_hcw_data.cmd.name
                  ,chp_rop_hcw_data.flid
                  ,chp_rop_hcw_data.flid_parity
                 );
      end

      // rop_dp_enq interface
      if (rst_n & rop_dp_enq_v & rop_dp_enq_ready) begin
         if ( (rop_dp_enq_data.cmd==ROP_DP_ENQ_DIR_ENQ_NEW_HCW) | (rop_dp_enq_data.cmd==ROP_DP_ENQ_DIR_ENQ_NEW_HCW_NOOP) | (rop_dp_enq_data.cmd==ROP_DP_ENQ_DIR_ENQ_REORDER_HCW) ) begin
             $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, hist_list_info.qid:%h, hist_list_info.qidix:%h, hist_list_info.qpri:%h "
                      ,$time
                      ,rop_dp_enq_data.cmd.name
                      ,rop_dp_enq_data.flid
                      ,rop_dp_enq_data.hist_list_info.qid
                      ,rop_dp_enq_data.hist_list_info.qidix
                      ,rop_dp_enq_data.hist_list_info.qpri
                     );
         end
         else begin
              $display("@%0tps [ROP_DEBUG], cmd:%s, cq:%h, hist_list_info.qid:%h, hist_list_info.qidix:%h, hist_list_info.qpri:%h, frag_list_info.hptr:%h, frag_list_info.tptr:%h, frag_list_info.cnt:%h, frag_list_info.hptr_parity:%h, frag_list_info.tptr_parity:%h, frag_list_info.cnt_residue:%h "
                       ,$time
                       ,rop_dp_enq_data.cmd.name
                       ,rop_dp_enq_data.cq
                       ,rop_dp_enq_data.hist_list_info.qid
                       ,rop_dp_enq_data.hist_list_info.qidix
                       ,rop_dp_enq_data.hist_list_info.qpri
                       ,rop_dp_enq_data.frag_list_info.hptr
                       ,rop_dp_enq_data.frag_list_info.tptr
                       ,rop_dp_enq_data.frag_list_info.cnt
                       ,rop_dp_enq_data.frag_list_info.hptr_parity
                       ,rop_dp_enq_data.frag_list_info.tptr_parity
                       ,rop_dp_enq_data.frag_list_info.cnt_residue
                      );
         end 
      end

      if (rst_n & holding_of_hcw_request_while_processing_cfg_ram_request) begin
              $display("@%0tps [ROP_DEBUG], Pending cfg ram request while we wait to purge the pipe lineProcessine, "
                       ,$time
                      );
      end

      // rop_nalb_enq interface
      if (rst_n & rop_nalb_enq_v & rop_nalb_enq_ready) begin
         if (rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW | (rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_NEW_HCW_NOOP) | (rop_nalb_enq_data.cmd == ROP_NALB_ENQ_LB_ENQ_REORDER_HCW) ) begin
              $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, hist_list_info.qid:%h, hist_list_info.qidix:%h, hist_list_info.qpri:%h"
                       ,$time
                       ,rop_nalb_enq_data.cmd.name
                       ,rop_nalb_enq_data.flid
                       ,rop_nalb_enq_data.hist_list_info.qid
                       ,rop_nalb_enq_data.hist_list_info.qidix
                       ,rop_nalb_enq_data.hist_list_info.qpri
                      );
         end 
         else begin
              $display("@%0tps [ROP_DEBUG], cmd:%s, cq:%h, hist_list_info.qid:%h, hist_list_info.qidix:%h, hist_list_info.qpri:%h, frag_list_info.hptr:%h, frag_list_info.tptr:%h, frag_list_info.cnt:%h, frag_list_info.hptr_parity:%h, frag_list_info.tptr_parity:%h, frag_list_info.cnt_residue:%h "
                       ,$time
                       ,rop_nalb_enq_data.cmd.name
                       ,rop_nalb_enq_data.cq
                       ,rop_nalb_enq_data.hist_list_info.qid
                       ,rop_nalb_enq_data.hist_list_info.qidix
                       ,rop_nalb_enq_data.hist_list_info.qpri
                       ,rop_nalb_enq_data.frag_list_info.hptr
                       ,rop_nalb_enq_data.frag_list_info.tptr
                       ,rop_nalb_enq_data.frag_list_info.cnt
                       ,rop_nalb_enq_data.frag_list_info.hptr_parity
                       ,rop_nalb_enq_data.frag_list_info.tptr_parity
                       ,rop_nalb_enq_data.frag_list_info.cnt_residue
                      );
         end
      end

      // rop_qed_dqed_enq interface
      if (rst_n & rop_qed_dqed_enq_v & rop_qed_enq_ready & ((rop_qed_dqed_enq_data.cmd==ROP_QED_DQED_ENQ_LB) | (rop_qed_dqed_enq_data.cmd==ROP_QED_DQED_ENQ_LB_NOOP) ) ) begin
              $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, flid_parity:%h, cq_hcw:%h, cq_hcw_ecc:%h "
                       ,$time
                       ,rop_qed_dqed_enq_data.cmd.name
                       ,rop_qed_dqed_enq_data.flid
                       ,rop_qed_dqed_enq_data.flid_parity
                       ,rop_qed_dqed_enq_data.cq_hcw
                       ,rop_qed_dqed_enq_data.cq_hcw_ecc
                      );
      end

      if (rst_n & rop_qed_dqed_enq_v & rop_dqed_enq_ready & ( (rop_qed_dqed_enq_data.cmd==ROP_QED_DQED_ENQ_DIR) | (rop_qed_dqed_enq_data.cmd==ROP_QED_DQED_ENQ_DIR_NOOP) ) ) begin
              $display("@%0tps [ROP_DEBUG], cmd:%s, flid:%h, flid_parity:%h, cq_hcw:%h, cq_hcw_ecc:%h "
                       ,$time
                       ,rop_qed_dqed_enq_data.cmd.name
                       ,rop_qed_dqed_enq_data.flid
                       ,rop_qed_dqed_enq_data.flid_parity
                       ,rop_qed_dqed_enq_data.cq_hcw
                       ,rop_qed_dqed_enq_data.cq_hcw_ecc
                      );

      end

      if (rst_n & cmd_start_sn_reorder & chp_rop_hcw_db2_out_ready) begin
          $display("@%0tps [ROP_DEBUG], ROP_COMPLETION START REORDER, cq:%h, flid:%h, hist_list_info{ qid:%h, qidix:%h, sn:%h} "
                   ,$time
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.flid 
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn
                  );
      end
      if (rst_n & cmd_update_sn_order_state & chp_rop_hcw_db2_out_ready) begin
          $display("@%0tps [ROP_DEBUG], UPDATING_ORDER_STATE,         cq:%h, flid:%h, hist_list_info{ qid:%h, qidix:%h, sn:%h}"
                   ,$time
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.cq_hcw
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.flid 
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qid
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.qidix
                   ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.chp_rop_hcw_db2_out_data.chp_rop_hcw.hist_list_info.sn_fid.sn
                  );
      end

      // rop_lsp_reordercmp interface
      if (rst_n & rop_lsp_reordercmp_v & rop_lsp_reordercmp_ready) begin
          $display("@%0tps [ROP_DEBUG], ROP_LSP_REORDERCMP, user:%h, cq:%h, qid:%h, parity:%h "
                   ,$time
                   ,rop_lsp_reordercmp_data.user
                   ,rop_lsp_reordercmp_data.cq
                   ,rop_lsp_reordercmp_data.qid
                   ,rop_lsp_reordercmp_data.parity
                  );
      end

      // push into one of 4 instance of hqm_AW_sn_order 
      if (rst_n & cmp_v[0] & cmp_ready[0] ) begin
          $display("@%0tps [ROP_DEBUG], COMPLETION_GRP_0, sn:%h, slt:%h "
                   ,$time
                   ,cmp_sn
                   ,cmp_slt
                  );
      end

      // push into one of 4 instance of hqm_AW_sn_order 
      if (rst_n & cmp_v[1] & cmp_ready[1] ) begin
          $display("@%0tps [ROP_DEBUG], COMPLETION_GRP_1, sn:%h, slt:%h "
                   ,$time
                   ,cmp_sn
                   ,cmp_slt
                  );
      end

      // push into one of 4 instance of hqm_AW_sn_order 
      if (rst_n & cmp_v[2] & cmp_ready[2] ) begin
          $display("@%0tps [ROP_DEBUG], COMPLETION_GRP_2, sn:%h, slt:%h "
                   ,$time
                   ,cmp_sn
                   ,cmp_slt
                  );
      end
      // push into one of 4 instance of hqm_AW_sn_order 
      if (rst_n & cmp_v[3] & cmp_ready[3] ) begin
          $display("@%0tps [ROP_DEBUG], COMPLETION_GRP_3, sn:%h, slt:%h "
                   ,$time
                   ,cmp_sn
                   ,cmp_slt
                  );
      end


end // if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin



if ( $test$plusargs("HQM_DEBUG_HIGH") ) begin

      if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p1_cmp_f.v & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p2_shft_bypsel_nxt) begin
          $display("@%0tps [ROP_DEBUG.AW_SN_ORDER_0], HQM_AW_SN_SEL_RMW, slt:%h, sht:%h "
                   ,$time
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p1_cmp_f.data.slt 
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p2_shft_bypdata_nxt[9:0]
                  );
      end

      if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p1_cmp_f.v & hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p2_shft_bypsel_nxt) begin
          $display("@%0tps [ROP_DEBUG.AW_SN_ORDER_1], HQM_AW_SN_SEL_RMW, slt:%h, sht:%h "
                   ,$time
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p1_cmp_f.data.slt 
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p2_shft_bypdata_nxt[9:0]
                  );
      end

      if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.cmp_v ) begin
          $display("@%0tps [ROP_DEBUG.AW_SN_ORDER_0], cmd:%s, slt:%h "
                   ,$time
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p0_cmp_nxt.data.cmd.name
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p0_shft_addr_nxt

                  );
      end
      if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.cmp_v ) begin
          $display("@%0tps [ROP_DEBUG.AW_SN_ORDER_1], cmd:%s, slt:%h "
                   ,$time
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p0_cmp_nxt.data.cmd.name
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p0_shft_addr_nxt
                  );
      end

      if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p1_cmp_f.v ) begin
          $display("@%0tps [ROP_DEBUG.AW_SN_ORDER_0], cmd:%s, slt:%h, sn:%h "
                   ,$time
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p1_cmp_f.data.cmd.name
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p2_cmp_nxt.data.slt
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.p2_cmp_nxt.data.shift
                  );
      end
      if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p1_cmp_f.v ) begin
          $display("@%0tps [ROP_DEBUG.AW_SN_ORDER_1], cmd:%s, slt:%h, sn:%h "
                   ,$time
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p1_cmp_f.data.cmd.name
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p2_cmp_nxt.data.slt
                  ,hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.p2_cmp_nxt.data.shift
                  );
      end

          if ( rst_n & chp_rop_hcw_fifo_push ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: pushing data into chp_rop_hcw_fifo ,%h, ", $time , chp_rop_hcw_fifo_push_data); 
          end

          if ( rst_n & dir_rply_req_fifo_push ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: pushing data into dir_rply_req_fifo ,%h, ", $time , dir_rply_req_fifo_push_data); 
          end

          if ( rst_n & ldb_rply_req_fifo_push ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: pushing data into ldb_rply_req_fifo ,%h, ", $time , ldb_rply_req_fifo_push_data); 
          end

          if ( rst_n & sn_ordered_fifo_push ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: pushing data into sn_ordered_fifo ,%h, ", $time , sn_ordered_fifo_push_data); 
          end

          if ( rst_n & sn_complete_fifo_push) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: pushing data into sn_complete_fifo ,%h, ", $time , sn_complete_fifo_push_data); 
          end

          if ( rst_n & lsp_reordercmp_fifo_push) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: pushing data into lsp_reordercmp_fifo ,%h, ", $time , lsp_reordercmp_fifo_push_data); 
          end

          if ( rst_n & chp_rop_hcw_fifo_pop ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: poping data into chp_rop_hcw_fifo ,%h, ", $time , chp_rop_hcw_fifo_pop_data); 
          end

          if ( rst_n & dir_rply_req_fifo_pop ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: poping data into dir_rply_req_fifo ,%h, ", $time , dir_rply_req_fifo_pop_data); 
          end

          if ( rst_n & ldb_rply_req_fifo_pop ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: poping data into ldb_rply_req_fifo ,%h, ", $time , ldb_rply_req_fifo_pop_data); 
          end

          if ( rst_n & sn_ordered_fifo_pop ) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: poping data into sn_ordered_fifo ,%h, ", $time , sn_ordered_fifo_pop_data); 
          end

          if ( rst_n & sn_complete_fifo_pop) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: poping data into sn_complete_fifo ,%h, ", $time , sn_complete_fifo_pop_data); 
          end

          if ( rst_n & lsp_reordercmp_fifo_pop) begin
                $display("@%0t [ROP_DEBUG]          FIFO_PUSH: poping data into lsp_reordercmp_fifo ,%h, ", $time , lsp_reordercmp_fifo_pop_data); 
          end

//      end // if $test$plusargs

end


   end // always_ff

























   initial begin
      $display("@%0tps [ROP_DEBUG] hqm_reorder_pipe initial block ...",$time);
   end // begin

   final begin
      $display("@%0tps [ROP_DEBUG] hqm_reorder_pipe final block ...",$time);

      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_noop                       :#%08d",$time,rop_cnt_hqm_cmd_noop_f                    );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_comp                       :#%08d",$time,rop_cnt_hqm_cmd_comp_f                    );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_comp_tok_ret               :#%08d",$time,rop_cnt_hqm_cmd_comp_tok_ret_f            );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_comp_qtype_ORDERED         :#%08d",$time,rop_cnt_hqm_cmd_comp_qtype_ORDERED_f      );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_new                    :#%08d",$time,rop_cnt_hqm_cmd_enq_new_f                 );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_new_tok_ret            :#%08d",$time,rop_cnt_hqm_cmd_enq_new_tok_ret_f         );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_comp                   :#%08d",$time,rop_cnt_hqm_cmd_enq_comp_f                );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_comp_tok_ret           :#%08d",$time,rop_cnt_hqm_cmd_enq_comp_tok_ret_f        );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_frag                   :#%08d",$time,rop_cnt_hqm_cmd_enq_frag_f                );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_frag_tok_ret           :#%08d",$time,rop_cnt_hqm_cmd_enq_frag_tok_ret_f        );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_comp_ORDERED           :#%08d",$time,rop_cnt_hqm_cmd_enq_comp_ORDERED_f        );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED   :#%08d",$time,rop_cnt_hqm_cmd_enq_comp_tok_ret_ORDERED_f);
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_lsp_reordercmp_cnt                     :#%08d",$time,rop_lsp_reordercmp_cnt_f                  );
      $display("@%0tps [ROP_INFO] SIM COUNTER rop_cnt_hqm_cmd_enq_replay                 :#%08d",$time,rop_cnt_hqm_cmd_enq_replay_f              );
      $display("@%0tps [ROP_INFO] SIM COUNTER number_of_expected_completions_f           :#%08d",$time,number_of_expected_completions_f          );

      if (chp_rop_request_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT chp_rop_request_clk_count_f  :#%0d chp_rop_request_count  :#%0d average rate 1 hcw every %.2f clk"
                  ,$time
                  ,chp_rop_request_clk_count_f
                  ,chp_rop_request_count_f
                  ,(chp_rop_request_clk_count_f*1.0)/(chp_rop_request_count_f*1.0)
                 );
      end
      if (rop_dp_enq_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT rop_dp_enq_clk_count_f       :#%0d rop_dp_enq_count       :#%0d average rate 1 hcw every %.2f clk"
                  ,$time
                  ,rop_dp_enq_clk_count_f
                  ,rop_dp_enq_count_f
                  ,(rop_dp_enq_clk_count_f*1.0)/(rop_dp_enq_count_f*1.0)
                 );
      end
      if (rop_nalb_enq_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT rop_nalb_enq_clk_count_f     :#%0d rop_nalb_enq_count     :#%0d average rate 1 hcw every %.2f clk"
                  ,$time
                  ,rop_nalb_enq_clk_count_f
                  ,rop_nalb_enq_count_f
                  ,(rop_nalb_enq_clk_count_f*1.0)/(rop_nalb_enq_count_f*1.0)
                 );
      end

      if (rop_qed_enq_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT rop_qed_enq_clk_count_f      :#%0d rop_qed_enq_count      :#%0d average rate 1 hcw every %.2f clk"
                  ,$time
                  ,rop_qed_enq_clk_count_f
                  ,rop_qed_enq_count_f
                  ,(rop_qed_enq_clk_count_f*1.0)/(rop_qed_enq_count_f*1.0)
                 );
      end

      if (rop_dqed_enq_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT rop_dqed_enq_clk_count_f     :#%0d rop_dqed_enq_count     :#%0d average rate 1 hcw every %.2f clk"
                  ,$time
                  ,rop_dqed_enq_clk_count_f
                  ,rop_dqed_enq_count_f
                  ,(rop_dqed_enq_clk_count_f*1.0)/(rop_dqed_enq_count_f*1.0)
                 );
      end

      if (grp0_cmp_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT grp0_cmp_clk_count_f         :#%0d grp0_cmp_count         :#%0d average rate 1 every %.2f clk"
                  ,$time
                  ,grp0_cmp_clk_count_f
                  ,grp0_cmp_count_f
                  ,(grp0_cmp_clk_count_f*1.0)/(grp0_cmp_count_f*1.0)
                 );
      end
      if (grp1_cmp_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT grp1_cmp_clk_count_f         :#%0d grp1_cmp_count         :#%0d average rate 1 every %.2f clk"
                  ,$time
                  ,grp1_cmp_clk_count_f
                  ,grp1_cmp_count_f
                  ,(grp1_cmp_clk_count_f*1.0)/(grp1_cmp_count_f*1.0)
                 );
      end
      if (grp2_cmp_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT grp2_cmp_clk_count_f         :#%0d grp2_cmp_count         :#%0d average rate 1 every %.2f clk"
                  ,$time
                  ,grp2_cmp_clk_count_f
                  ,grp2_cmp_count_f
                  ,(grp2_cmp_clk_count_f*1.0)/(grp2_cmp_count_f*1.0)
                 );
      end
      if (grp3_cmp_count_f>0) begin
         $display("@%0tps [ROP_INFO]   PERF STAT grp3_cmp_running_clk_count_f :#%0d grp3_cmp_count         :#%0d average rate 1 every %.2f clk"
                  ,$time
                  ,grp3_cmp_running_clk_count_f
                  ,grp3_cmp_count_f
                  ,(grp3_cmp_running_clk_count_f*1.0)/(grp3_cmp_count_f*1.0)
                 );
      end





   end // final
`endif

task eot_check (output bit pf);

  pf = 1'b0 ; //pass


//Unit state checks
if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_unit_idle_reg_f[0] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_unit_idle_reg_f.pipe_idle is not set "
);
end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_unit_idle_reg_f[1] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_unit_idle_reg_f.unit_idle is not set "
);
end

for( int i = 0; i < 32; i++ ) begin
    if ( |hqm_reorder_pipe_core.i_hqm_reorder_pipe_register_pfcsr.hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status[i*32 +: 32]) begin // there should be no pending requests in order logic 
  pf = 1'b1; 
  $display( "@%0tps [ROP_ERROR] \
  ,%-30s \
  "
  ,$time
  ," sn_order_pipe_health_sn_state_grp0_reg_f is not clear "
  );
  end
    if ( |hqm_reorder_pipe_core.i_hqm_reorder_pipe_register_pfcsr.hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status[i*32 +: 32]) begin // there should be no pending requests in order logic 
  pf = 1'b1; 
  $display( "@%0tps [ROP_ERROR] \
  ,%-30s \
  "
  ,$time
  ," sn_order_pipe_health_sn_state_grp1_reg_f is not clear "
  );
  end

end // for

  if (hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_frag_integrity_count_status!='0) begin // The count should be 0 at end of test
pf = 1'b1; 
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.frag_integrity_cnt_f is not zero"
);
end

 //Unit Port checks - captured in MASTER
  if (|sn_state_err_any_f) begin pf = 1'b1; end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_interface_status_status[3] != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," rop_alarm_down_v is not clear "
);
end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_interface_status_status[1] != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," rop_alarm_up_v is not clear "
);
end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_interface_status_status[5] != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," chp_rop_hcw_v is not clear "
);
end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_interface_status_status[7] != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," rop_dp_enq_v is not clear "
);
end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_interface_status_status[9] != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," rop_nalb_enq_v is not clear "
);
end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_interface_status_status[11] != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," rop_qed_dqed_enq_v is not clear "
);
end

if ( hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.hqm_rop_target_cfg_interface_status_status[13] != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [ROP_ERROR] \
,%-30s \
"
,$time
," rop_lsp_reordercmp_v is not clear "
);
end

endtask : eot_check

endmodule

bind hqm_reorder_pipe_core hqm_reorder_pipe_inst i_hqm_reorder_pipe_inst();

`endif
