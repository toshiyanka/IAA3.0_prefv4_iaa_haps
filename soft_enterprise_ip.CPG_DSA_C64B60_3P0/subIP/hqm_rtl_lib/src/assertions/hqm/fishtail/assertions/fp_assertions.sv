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

// fp18260_1
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/vec_pm_unit_0_f_reg[0]

// fp18260_2
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/vec_pm_unit_0_f_reg[5]

// fp18260_3
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/vec_pm_unit_0_f_reg[1]

// fp18260_4
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_pg_ack_b_in_f_reg

// fp18260_5
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pgcb_fet_en_b_f_reg

// fp18260_6
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_pg_ack_b_in_delay0_f_reg

// fp18260_7
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_pgcb_clk_rf_pg_cont/i_rf_count_rmw_pipe_wd_dir_mem/i_rf/hqm_ip764hd2prf64x10s0r2p1_upf_wrapper/hqm_ip764hd2prf64x10s0r2p1/pshutoff

// fp18260_8
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_pgcb_clk_rf_pg_cont/i_rf_count_rmw_pipe_wd_dir_mem/i_rf/hqm_ip764hd2prf64x10s0r2p1_upf_wrapper/hqm_ip764hd2prf64x10s0r2p1/shutoff

// fp18260_9
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmclk (rise)
// Endpoint: (pin) i_hqm_list_sel_mem/i_hqm_list_sel_mem_hqm_clk_sram_pg_cont/i_sr_aqed/i_sram_b0/hqm_ip764hduspsr2048x70m4b2s0r2p1d0_upf_wrapper/hqm_ip764hduspsr2048x70m4b2s0r2p1d0/pshutoff

// fp18260_10
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmclk (rise)
// Endpoint: (pin) i_hqm_list_sel_mem/i_hqm_list_sel_mem_hqm_clk_sram_pg_cont/i_sr_aqed/i_sram_b0/hqm_ip764hduspsr2048x70m4b2s0r2p1d0_upf_wrapper/hqm_ip764hduspsr2048x70m4b2s0r2p1d0/shutoff

// fp18260_11
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmprimclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_prim_clk_rf_dc_pg_cont/i_rf_hcw_enq_fifo/i_rf/hqm_ip764hd2prf256x168s0r2p1_upf_wrapper/hqm_ip764hd2prf256x168s0r2p1/pshutoff

// fp18260_12
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmprimclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_prim_clk_rf_dc_pg_cont/i_rf_hcw_enq_fifo/i_rf/hqm_ip764hd2prf256x168s0r2p1_upf_wrapper/hqm_ip764hd2prf256x168s0r2p1/shutoff

// fp18264_1
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/vec_pm_unit_0_f_reg[0]

// fp18264_2
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/vec_pm_unit_0_f_reg[5]

// fp18264_3
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/vec_pm_unit_0_f_reg[1]

// fp18264_4
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_pg_ack_b_in_f_reg

// fp18264_5
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pgcb_fet_en_b_f_reg

// fp18264_6
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_pg_ack_b_in_delay0_f_reg

// fp18264_7
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_pgcb_clk_rf_pg_cont/i_rf_count_rmw_pipe_wd_dir_mem/i_rf/hqm_ip764hd2prf64x10s0r2p1_upf_wrapper/hqm_ip764hd2prf64x10s0r2p1/pshutoff

// fp18264_8
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmpgcbclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_pgcb_clk_rf_pg_cont/i_rf_count_rmw_pipe_wd_dir_mem/i_rf/hqm_ip764hd2prf64x10s0r2p1_upf_wrapper/hqm_ip764hd2prf64x10s0r2p1/shutoff

// fp18264_9
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmclk (rise)
// Endpoint: (pin) i_hqm_list_sel_mem/i_hqm_list_sel_mem_hqm_clk_sram_pg_cont/i_sr_aqed/i_sram_b0/hqm_ip764hduspsr2048x70m4b2s0r2p1d0_upf_wrapper/hqm_ip764hduspsr2048x70m4b2s0r2p1d0/pshutoff

// fp18264_10
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmclk (rise)
// Endpoint: (pin) i_hqm_list_sel_mem/i_hqm_list_sel_mem_hqm_clk_sram_pg_cont/i_sr_aqed/i_sram_b0/hqm_ip764hduspsr2048x70m4b2s0r2p1d0_upf_wrapper/hqm_ip764hduspsr2048x70m4b2s0r2p1d0/shutoff

// fp18264_11
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmprimclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_prim_clk_rf_dc_pg_cont/i_rf_hcw_enq_fifo/i_rf/hqm_ip764hd2prf256x168s0r2p1_upf_wrapper/hqm_ip764hd2prf256x168s0r2p1/pshutoff

// fp18264_12
// Sensitization condition: 
//    ( 0 )
// Launch Clock: hqmpgcbclk (rise)
// Startpoint: i_hqm_sip/hqm_sip_aon_wrap/i_hqm_master/i_hqm_master_core/i_hqm_pm_unit/pmc_pgcb_fet_en_b_f_reg
// Capture Clock: hqmprimclk (rise)
// Endpoint: (pin) i_hqm_system_mem/i_hqm_system_mem_prim_clk_rf_dc_pg_cont/i_rf_hcw_enq_fifo/i_rf/hqm_ip764hd2prf256x168s0r2p1_upf_wrapper/hqm_ip764hd2prf256x168s0r2p1/shutoff
