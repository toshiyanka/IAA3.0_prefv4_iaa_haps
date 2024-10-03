`include "hqm_hier_define.sv"
`include "hqm_sip_hier_define.sv"

`define USE_TEST_ISLAND_APPROACH


`ifdef TB_TOP
  `ifdef HQM
    `define HQM_PATH `TB_TOP.`HQM
  `else
    `define HQM_PATH `TB_TOP.u_hqm
  `endif
`else
  `define HQM_PATH hqm_tb_top.u_hqm
`endif

`define HQM_PATH_STR                                        `STRINGIFY(`HQM_PATH)

`define HQM_SIP_PATH                                        `HQM_PATH.`I_HQM_SIP
`define HQM_SIP_PATH_STR                                    `STRINGIFY(`HQM_SIP_PATH)

`define HQM_AQED_PIPE_PATH                                  `HQM_SIP_PATH.`I_HQM_AQED_PIPE
`define HQM_AQED_PIPE_PATH_STR                              `STRINGIFY(`HQM_AQED_PIPE_PATH)
`define HQM_AQED_PIPE_INST_PATH                             `HQM_AQED_PIPE_PATH.i_hqm_aqed_pipe_core.i_hqm_aqed_pipe_inst
                                                           
`define HQM_LIST_SEL_PIPE_PATH                              `HQM_SIP_PATH.`I_HQM_LIST_SEL_PIPE
`define HQM_LIST_SEL_PIPE_PATH_STR                          `STRINGIFY(`HQM_LIST_SEL_PIPE_PATH)
`define HQM_LIST_SEL_PIPE_INST_PATH                         `HQM_LIST_SEL_PIPE_PATH.i_hqm_list_sel_pipe_core.i_hqm_list_sel_pipe_inst
                                                           
`define HQM_ATM_PIPE_PATH                                   `HQM_SIP_PATH.`I_HQM_LIST_SEL_PIPE
`define HQM_ATM_PIPE_PATH_STR                               `STRINGIFY(`HQM_ATM_PIPE_PATH)
`define HQM_ATM_PIPE_INST_PATH                              `HQM_ATM_PIPE_PATH.i_hqm_list_sel_pipe_core.i_hqm_lsp_atm_pipe.i_hqm_lsp_atm_pipe_inst
                                                           
`define HQM_DIR_PIPE_PATH                                   `HQM_SIP_PATH.`I_HQM_QED_PIPE.i_hqm_qed_pipe_core
`define HQM_DIR_PIPE_PATH_STR                               `STRINGIFY(`HQM_PATH.`I_HQM_QED_PIPE.i_hqm_qed_pipe_core)
`define HQM_DIR_PIPE_INST_PATH                              `HQM_DIR_PIPE_PATH.i_hqm_dir_pipe_core.i_hqm_dir_pipe_inst

                                                           
`define HQM_QED_PIPE_PATH                                   `HQM_SIP_PATH.`I_HQM_QED_PIPE
`define HQM_QED_PIPE_PATH_STR                               `STRINGIFY(`HQM_QED_PIPE_PATH)
`define HQM_QED_PIPE_INST_PATH                              `HQM_QED_PIPE_PATH.i_hqm_qed_pipe_core.i_hqm_qed_pipe_inst
                                                           
`define HQM_NALB_PIPE_PATH                                  `HQM_SIP_PATH.`I_HQM_QED_PIPE.i_hqm_qed_pipe_core
`define HQM_NALB_PIPE_PATH_STR                              `STRINGIFY(`HQM_PATH.`I_HQM_QED_PIPE.i_hqm_qed_pipe_core)
`define HQM_NALB_PIPE_INST_PATH                             `HQM_NALB_PIPE_PATH.i_hqm_nalb_pipe_core.i_hqm_nalb_pipe_inst
                                                           
`define HQM_MASTER_PATH                                     `HQM_SIP_PATH.`I_HQM_MASTER
`define HQM_MASTER_PATH_STR                                 `STRINGIFY(`HQM_MASTER_PATH)
`define HQM_MASTER_INST_PATH                                `HQM_MASTER_PATH.i_hqm_master_core.i_hqm_master_inst
                                                           
`define HQM_REORDER_PIPE_PATH                               `HQM_SIP_PATH.`I_HQM_REORDER_PIPE
`define HQM_REORDER_PIPE_PATH_STR                           `STRINGIFY(`HQM_REORDER_PIPE_PATH)
`define HQM_REORDER_PIPE_INST_PATH                          `HQM_REORDER_PIPE_PATH.i_hqm_reorder_pipe_core.i_hqm_reorder_pipe_inst
                                                           
`define HQM_CREDIT_HIST_PIPE_PATH                           `HQM_SIP_PATH.`I_HQM_CREDIT_HIST_PIPE
`define HQM_CREDIT_HIST_PIPE_PATH_STR                       `STRINGIFY(`HQM_CREDIT_HIST_PIPE_PATH)
`define HQM_CREDIT_HIST_PIPE_INST_PATH                      `HQM_CREDIT_HIST_PIPE_PATH.i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_inst
                                                           
`define HQM_SYSTEM_PATH                                     `HQM_SIP_PATH.`I_HQM_SYSTEM
`define HQM_SYSTEM_PATH_STR                                 `STRINGIFY(`HQM_SYSTEM_PATH)
`define HQM_SYSTEM_INST_PATH                                `HQM_SYSTEM_PATH.i_hqm_system_core.i_hqm_system_inst
                                                           
`define HQM_SIF_PATH                                        `HQM_SIP_PATH.`I_HQM_SIF
`define HQM_SIF_PATH_STR                                    `STRINGIFY(`HQM_SIF_PATH)
`define HQM_SIF_INST_PATH                                   `HQM_SIF_PATH.i_hqm_sif_core.i_hqm_sif_inst
                                                           
`define HQM_QED_MEM_PATH                                    `HQM_PATH.`I_HQM_QED_MEM
`define HQM_QED_MEM_PATH_STR                                `STRINGIFY(`HQM_QED_MEM_PATH)
                                                           
`define HQM_LIST_SEL_MEM_PATH                               `HQM_PATH.`I_HQM_LIST_SEL_MEM
`define HQM_LIST_SEL_MEM_PATH_STR                           `STRINGIFY(`HQM_LIST_SEL_MEM_PATH)
                                                           
`define HQM_SYSTEM_MEM_PATH                                 `HQM_PATH.`I_HQM_SYSTEM_MEM
`define HQM_SYSTEM_MEM_PATH_STR                             `STRINGIFY(`HQM_SYSTEM_MEM_PATH)

`define HQM_CHP_PGCB_CLKFREE_PATH                           `HQM_SIP_PATH.`I_HQM_CHP_PGCB_CLKFREE
`define HQM_CHP_PGCB_CLKFREE_PATH_STR                       `STRINGIFY(`HQM_CHP_PGCB_CLKFREE_PATH)

`define HQM_CHP_HQM_GATED_RST_PGCB_SYNC_N_PATH              `HQM_SIP_PATH.`I_HQM_CHP_HQM_GATED_RST_PGCB_SYNC_N
`define HQM_CHP_HQM_GATED_RST_PGCB_SYNC_N_PATH_STR          `STRINGIFY(`HQM_CHP_HQM_GATED_RST_PGCB_SYNC_N_PATH)

`define HQM_MASTER_HQM_CLK_RPTR_RST_SYNC_N_PATH             `HQM_SIP_PATH.`I_HQM_MASTER_HQM_CLK_RPTR_RST_SYNC_N
`define HQM_MASTER_HQM_CLK_RPTR_RST_SYNC_N_PATH_STR         `STRINGIFY(`HQM_MASTER_HQM_CLK_RPTR_RST_SYNC_N_PATH)

`define HQM_MASTER_HQM_CDC_CLK_ENABLE_RPTR_PATH             `HQM_SIP_PATH.`I_HQM_MASTER_HQM_CDC_CLK_ENABLE_RPTR
`define HQM_MASTER_HQM_CDC_CLK_ENABLE_RPTR_PATH_STR         `STRINGIFY(`HQM_MASTER_HQM_CDC_CLK_ENABLE_RPTR_PATH)

`define HQM_MASTER_HQM_FREERUN_CLK_ENABLE_RPTR_PATH         `HQM_SIP_PATH.`I_HQM_MASTER_HQM_FREERUN_CLK_ENABLE_RPTR
`define HQM_MASTER_HQM_FREERUN_CLK_ENABLE_RPTR_PATH_STR     `STRINGIFY(`HQM_MASTER_HQM_FREERUN_CLK_ENABLE_RPTR_PATH)

`define HQM_MASTER_HQM_INP_GATED_CLK_ENABLE_RPTR_PATH       `HQM_SIP_PATH.`I_HQM_MASTER_HQM_INP_GATED_CLK_ENABLE_RPTR
`define HQM_MASTER_HQM_INP_GATED_CLK_ENABLE_RPTR_PATH_STR   `STRINGIFY(`HQM_MASTER_HQM_INP_GATED_CLK_ENABLE_RPTR_PATH)
                                                           
`define HQM_CHP_FREELIST_INST_PATH                          `HQM_SIP_PATH.`I_HQM_CREDIT_HIST_PIPE.i_hqm_credit_hist_pipe_core.i_chp_freelist.i_hqm_chp_freelist_inst
`define HQM_INST_LSP_PATH                                   `HQM_SIP_PATH.i_hqm_inst_lsp
`define HQM_INST_QED_PATH                                   `HQM_SIP_PATH.i_hqm_inst_qed
`define HQM_INST_SYS_PATH                                   `HQM_SIP_PATH.i_hqm_inst_sys
`define HQM_PM_UNIT_INST_PATH                               `HQM_SIP_PATH.`I_HQM_MASTER.i_hqm_master_core.i_hqm_pm_unit.i_hqm_pm_unit_inst
                                                           
`define HQM_SIF_CORE                                        `HQM_SIF_PATH.i_hqm_sif_core

`ifdef HQM_SFI

 `define MY_IOSF_PARAMS \
   .MAX_DATA_LEN  (MAX_DATA_LEN),  \
   .MMAX_ADDR     (MMAX_ADDR),     \
   .TMAX_ADDR     (TMAX_ADDR),     \
   .AGENT_WIDTH   (AGENT_WIDTH),   \
   .MNUMCHAN      (3),      \
   .TNUMCHAN      (3),      \
   .MNUMCHANL2    (1),    \
   .TNUMCHANL2    (1),    \
   .MD_WIDTH      (MD_WIDTH),      \
   .TD_WIDTH      (TD_WIDTH),      \
   .MSAI_WIDTH    (SAI_WIDTH),    \
   .TSAI_WIDTH    (SAI_WIDTH),    \
   .SRC_ID_WIDTH  (SRC_ID_WIDTH),  \
   .DEST_ID_WIDTH (DST_ID_WIDTH), \
   .RS_WIDTH      (RS_WIDTH)

`else

 `define MY_IOSF_PARAMS \
   .MAX_DATA_LEN  (MAX_DATA_LEN),  \
   .MMAX_ADDR     (MMAX_ADDR),     \
   .TMAX_ADDR     (TMAX_ADDR),     \
   .AGENT_WIDTH   (AGENT_WIDTH),   \
   .MNUMCHAN      (0),      \
   .TNUMCHAN      (0),      \
   .MNUMCHANL2    (0),    \
   .TNUMCHANL2    (0),    \
   .MD_WIDTH      (MD_WIDTH),      \
   .TD_WIDTH      (TD_WIDTH),      \
   .MSAI_WIDTH    (SAI_WIDTH),    \
   .TSAI_WIDTH    (SAI_WIDTH),    \
   .SRC_ID_WIDTH  (SRC_ID_WIDTH),  \
   .DEST_ID_WIDTH (DST_ID_WIDTH), \
   .RS_WIDTH      (RS_WIDTH)

`endif

`define hqm_tb_log(_info_) $display({"[HQM_TB_DEBUG] : ",$psprintf(_info_)});

`include "hqm_sif_defines.sv"

// Power defines 
`define HQM_D3STATE 3
`define HQM_D0STATE 0

`define LCP_DEPTH 52

`define HQM_NUM_LDB_CQ 64
`define HQM_NUM_DIR_CQ 64

