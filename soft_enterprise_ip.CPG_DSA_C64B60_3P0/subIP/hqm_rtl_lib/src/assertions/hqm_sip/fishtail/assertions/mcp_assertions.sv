// Assertion file generated by FishTail Focus version 2020.06g
`ifndef FT_DISABLE
   `define FT_DISABLE disable iff (1'b0)
`endif

`define FT_TRANSITIONS_AND_NOT_UNKNOWN(reg) \
   ( (reg !== $past(reg)) && !$isunknown(reg) && !$isunknown($past(reg)) )

`define FT_RISES_AND_NOT_UNKNOWN(reg) \
   ( (reg !== $past(reg)) && !$isunknown($past(reg)) && !$isunknown(reg) && ($countones(reg) >= $countones($past(reg))) )

`define FT_FALLS_AND_NOT_UNKNOWN(reg) \
   ( (reg !== $past(reg)) && !$isunknown($past(reg)) && !$isunknown(reg) && ($countones(reg) <= $countones($past(reg))) )

`define FT_SP_TRANSITIONS_AND_NOT_UNKNOWN(reg) \
   ( (reg !== $past(reg)) && !$isunknown(reg) )

`define FT_SP_RISES_AND_NOT_UNKNOWN(reg) \
   ( (reg !== $past(reg)) && !$isunknown(reg) && ($countones(reg) >= $countones($past(reg))) )

`define FT_SP_FALLS_AND_NOT_UNKNOWN(reg) \
   ( (reg !== $past(reg)) && !$isunknown(reg) && ($countones(reg) <= $countones($past(reg))) )

`define FT_PPC_IS_FALSE(cond) \
   ( !cond || $isunknown(cond) )

`define FT_PPC_IS_FALSE_IN_PREV_CYCLE(cond) \
   ( !$past(cond) || $isunknown($past(cond)) )

`define FT_TRANSITIONS(reg) \
   ( reg !== $past(reg) )

`define FT_TRANSITIONS_IN_PREV_CYCLE(reg) \
   ( ($past(reg) !== $past($past(reg))) && !$isunknown($past(reg)) && !$isunknown($past($past(reg))) )

`define FT_TRANSITIONS_IN_ANY_PREV_CYCLE(reg,initial_reg_val) \
   ( ($past(reg) !== initial_reg_val) && !$isunknown($past(reg)) )

`define FT_NEWDATA_TOREG(size,edge,clk_sink_sig) \
   logic [``size:1] to_reg_delayed;        \
   logic static_to_reg=1;                  \
   always @(to_reg)                        \
     to_reg_delayed <= #1 to_reg;          \
   always @(to_reg)                        \
     if(to_reg_delayed !== {size{1'bx}})   \
       static_to_reg = 0;                  \
   always @(``edge clk_sink_sig)               \
     if (to_reg_delayed === to_reg)        \
       static_to_reg = 1;     

`define FT_NEWDATA_TOREG_BUS(size,edge,sb,eb,clk_sink_sig) \
   logic [``size:1] to_reg_delayed;              \
   logic [``size:1] to_reg_int;                  \
   logic static_to_reg=1;                        \
   assign to_reg_int = to_reg[``sb:``eb];        \
   always @(to_reg_int)                          \
     to_reg_delayed <= #1 to_reg_int;            \
   always @(to_reg_int)                          \
     if(to_reg_delayed !== {size{1'bx}})         \
       static_to_reg = 0;                        \
   always @(``edge clk_sink_sig)                 \
     if (to_reg_delayed === to_reg_int)          \
       static_to_reg = 1;     


`define FT_DISPLAY_CHECKED(id)        \
  task display_checked;               \
    begin                             \
      static bit done = 0;            \
      if (done == 0) begin            \
        $``id; \
        done = 1;                     \
      end                             \
    end                               \
  endtask

// iteration 1 minimize_primary_control 0 min_control_value 0

// mcp13388_1
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pgcbunit/i_pgcbfsm1/pgcb_force_rst_b_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/vec_pm_unit_0_f_reg[3]
// MCP type: setup/start
// Path multiplier: 6

// mcp13388_2
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pgcbunit/i_pgcbfsm1/pgcb_force_rst_b_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_cdc/u_CdcPgcbClock/force_pgate_req_not_pg_active_pg_reg
// MCP type: setup/start
// Path multiplier: 6

// mcp13388_3
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pgcbunit/i_pgcbfsm1/pgcb_force_rst_b_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_cdc/u_CdcPgcbClock/force_pgate_req_pg_reg
// MCP type: setup/start
// Path multiplier: 6

// mcp13388_4
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pgcbunit/i_pgcbfsm1/pgcb_force_rst_b_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_cdc/u_CdcPgcbClock/unlock_domain_pg_reg
// MCP type: setup/start
// Path multiplier: 6

// mcp13344_1
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/hqm_pmsm_visa_f.go_off_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_2
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/hqm_pmsm_visa_f.go_on_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_3
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/hqm_pmsm_visa_f.pm_fsm_d3tod0_ok_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_4
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pm_flr_unit/flr_clkreq_b_f_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_5
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pm_flr_unit/flr_clkreq_f_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_6
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pm_flr_unit/flr_pmfsm_req_f_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_7
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pm_flr_unit/flr_req_f_reg[0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_8
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pm_flr_unit/flr_triggered_f_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_9
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/i_hqm_pmsm/pmsm_state_f_reg[4:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_10
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/allow_force_pwrgate_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_11
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_csr_ctl/flr_treatment_q0_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_12
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_csr_ctl/flr_treatment_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_13
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_csr_ctl/int_csr_rd_data_f_reg[31:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_14
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_pm/rst_act_cnt_reg[7:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_15
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_pm/i_ri_pm_fsm_pf0/flr_pending_f_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_16
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_pm/i_ri_pm_fsm_pf0/pm_cur_state_reg[1:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_17
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_nphdr/i_db/data_q_reg[0][2:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_18
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_nphdr/i_db/data_q_reg[0][157]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_19
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_nphdr/i_db/data_q_reg[1][2:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_20
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_nphdr/i_db/data_q_reg[1][157]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_21
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_nphdr/i_hqm_AW_fifo_control/p0_push_data_f_reg[2:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_22
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_nphdr/i_hqm_AW_fifo_control/p0_push_data_f_reg[157]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_23
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_phdr/i_db/data_q_reg[0][2:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_24
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_phdr/i_db/data_q_reg[0][152]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_25
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_phdr/i_db/data_q_reg[1][2:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_26
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_phdr/i_db/data_q_reg[1][152]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_27
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_phdr/i_hqm_AW_fifo_control_big/p0_push_data_f_reg[2:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_28
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_tlq/i_fifo_phdr/i_hqm_AW_fifo_control_big/p0_push_data_f_reg[152]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_29
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_sfi_core/allow_force_pwrgate_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_30
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][1:0]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_sif_probes/hqm_sif_visa_out_reg[662]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_31
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][15:2]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_csr_ctl/int_csr_rd_data_f_reg[31:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_32
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][15:2]
// Capture Clock: hqmprimclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_ri/i_ri_csr_ctl/pf0_rd_data_f_reg[7:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_33
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/prim_clkreq_async_sbe_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_34
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/sb_ep_msg_irdy_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_35
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_sb_ep_xlate/access_in_prim_rst_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_36
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_sb_ep_xlate/invalid_op_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_37
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_sb_ep_xlate/master_ctl_load_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_38
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_sb_ep_xlate/sb_local_cnt_q_reg[2:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_39
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_sb_ep_xlate/sb_local_done_q_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_40
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_sb_ep_xlate/sb_local_rdata_q_reg[31:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_41
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_sb_ep_xlate/sb_local_reg_wr_q_reg[1:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_42
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_ri_iosf_sb/allow_ep_sb_cmsg_reg
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_43
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_ri_iosf_sb/i_sb_ep_msg_hs/dat_src_q_reg[131:0]
// MCP type: setup/start
// Path multiplier: 3

// mcp13344_44
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmsideclk (rise)
// Startpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_hqm_msg_wrapper/i_hqm_fp_capture_fuses/mem_reg[0][0]
// Capture Clock: hqmsideclk (rise)
// Endpoint: hqm_sip_aon_wrap/i_hqm_sif/i_hqm_sif_core/i_hqm_iosfsb_core/i_ri_iosf_sb/i_sb_ep_msg_hs/val_src_q_reg
// MCP type: setup/start
// Path multiplier: 3
