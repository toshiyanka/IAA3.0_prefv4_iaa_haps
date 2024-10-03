# Side clock should always be valid for the IOSF interface
set side_clk_period  [get_attribute [get_clock side_clk]  period]
# Agent clock needs to be set to the side clock for synchronous designs.
if {[sizeof_collection [get_cells {gen_async_blk1_sync_rstb}]] > 0} {
   set agent_clk_period [get_attribute [get_clock agent_clk] period]
   set agent_clk        [get_clock agent_clk]
   puts "Sideband Endpoint is in Async Mode, using agent_clk for agent interface"
} else {
   set agent_clk_period [get_attribute [get_clock side_clk] period]
   set agent_clk        [get_clock side_clk]
   puts "Sideband Endpoint is in Sync Mode, using side_clk for agent interface"
}

#set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_clk}]
#set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {gated_side_clk}]
#set_input_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY] [get_ports {agent_clk}]
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_rst_b}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {side_rst_b}] -add_delay

set_input_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY] [get_ports {agent_side_rst_b_sync}]

set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {usyncselect}] -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {usyncselect}] -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_usync}]
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {agent_usync}]

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_clkreq}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {sbi_sbe_clkreq}] -add_delay

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_idle}]

set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_ism_lock_b}]

set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {side_clkreq}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_clkack}]

set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {sbe_sbi_clkreq}] -add_delay
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_clkreq}] -add_delay

set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_idle}]
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {sbe_sbi_clk_valid}]
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_OUTPUT_DELAY]  [get_ports {sbe_sbi_comp_exp}]

set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {mpccup}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {mnpcup}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {mpcput}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {mnpput}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {meom}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {mpayload*}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {side_ism_fabric*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {side_ism_agent*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {tpccup}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_OUTPUT_DELAY] [get_ports {tnpcup}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tpcput}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tnpput}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {teom}]
set_input_delay  -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {tpayload*}]

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_tmsg_pcfree*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_tmsg_npfree*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_tmsg_npclaim*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_pcput}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_npput}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_pcmsgip}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_npmsgip}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_pceom}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_npeom}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_pcpayload*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_nppayload*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_pccmpl}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_pcvalid}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_tmsg_npvalid}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {ur_csairs_valid}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {ur_csai*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {ur_crs*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {ur_rx_sairs_valid}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {ur_rx_sai*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {ur_rx_rs*}]

set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_mmsg_pcirdy*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_mmsg_npirdy*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_mmsg_pceom*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_mmsg_npeom*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_mmsg_pcpayload*}]
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY]  [get_ports {sbi_sbe_mmsg_nppayload*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_mmsg_pctrdy}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_mmsg_nptrdy}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_mmsg_pcmsgip}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_mmsg_npmsgip}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_mmsg_pcsel*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_OUTPUT_DELAY] [get_ports {sbe_sbi_mmsg_npsel*}]

set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {cgctrl_idlecnt*}]
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {cgctrl_clkgaten}]
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {cgctrl_clkgatedef}]

set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {visa_all_disable}]      -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {visa_customer_disable}] -add_delay
set_input_delay  -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {visa_ser_cfg_in*}]      -add_delay
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {avisa_data_out*}]       -add_delay
set_output_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_RELAXED_DELAY]  [get_ports {avisa_clk_out*}]        -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_all_disable}]      -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_customer_disable}] -add_delay
set_input_delay  -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_ser_cfg_in*}]      -add_delay
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {avisa_data_out*}]       -add_delay
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {avisa_clk_out*}]        -add_delay

set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_port_tier1_sb*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_port_tier2_sb*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier1_sb*}]
set_output_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier2_sb*}]

set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier1_ag*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_fifo_tier2_ag*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_agent_tier1_ag*}]
set_output_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_RELAXED_DELAY] [get_ports {visa_agent_tier2_ag*}]

set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_clkgate_ovrd}]    -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_clkreq}]    -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_idle}]      -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_notidle}]   -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {jta_force_creditreq}] -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {jta_clkgate_ovrd}]    -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {jta_force_clkreq}]    -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {jta_force_idle}]      -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {jta_force_notidle}]   -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {jta_force_creditreq}] -add_delay

set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_mode}]          -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_latchopen}]     -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_latchclosed_b}] -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_clkungate}]     -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_clkungate_syn}] -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_rstbypen}]      -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_byprst_b}]      -add_delay
set_input_delay -clock [get_clock side_clk]   [expr $side_clk_period * $EP_INPUT_DELAY]  [get_ports {fscan_shiften}]       -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_mode}]          -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_latchopen}]     -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_latchclosed_b}] -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_clkungate}]     -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_clkungate_syn}] -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_rstbypen}]      -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_byprst_b}]      -add_delay
set_input_delay -clock [get_clock $agent_clk] [expr $agent_clk_period * $EP_INPUT_DELAY] [get_ports {fscan_shiften}]       -add_delay

set_input_delay -clock [get_clock side_clk] [expr $side_clk_period * $EP_INPUT_DELAY] [get_ports {tx_ext_headers*}]
