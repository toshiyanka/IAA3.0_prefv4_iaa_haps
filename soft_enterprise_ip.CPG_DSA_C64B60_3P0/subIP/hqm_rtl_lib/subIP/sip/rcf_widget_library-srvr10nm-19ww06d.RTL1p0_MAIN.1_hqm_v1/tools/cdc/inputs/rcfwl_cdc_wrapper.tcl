set importWaivers 1
# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations. 

# Define clocks 
# netlist clock cpu_clk_in -period 50 
netlist clock clock -period 832 -waveform {0 416} -group gpsb_clk
netlist clock pgcb_clk -period 2496 -waveform {0 1248} -group pma_clk
##VISA
netlist clock fvisa_serstrb -group VISACFGCLK_GROUP
netlist clock ss_clk_out -module visa_unit_mux_s -group VISA_SSCLK_GROUP
netlist clock xbar_ss_clk_out -module visa_unit_mux_s -group VISA_SSCLK_GROUP


# Define constants 
# netlist constant scan_mode 1'b0 
netlist constant fismdrx_force_clkreq       1'b0
#netlist constant fscan_byprst_b             0
netlist constant fscan_rstbypen             0

netlist constant cfg_clkgate_disabled 0
netlist constant cfg_clkreq_ctl_disabled 0
netlist constant cfg_clkgate_holdoff 0
netlist constant cfg_pwrgate_holdoff 0
netlist constant cfg_clkreq_off_holdoff 4
netlist constant cfg_clkreq_syncoff_holdoff 4

# Define Port Clock Domain - optional 
# netlist port domain { input_signal } -clock { cpu_clk_in } 
netlist port domain { pgcb_rst_b } -input -async
netlist port domain { clkack } -input -async
netlist port domain { gclock_req_async } -input -async
netlist port domain { pok_reset_b } -input -async
netlist port domain { ism_agent } -clock gpsb_clk
netlist port domain { ism_fabric } -clock gpsb_clk
netlist port domain { forcepgpok_pok } -input -async
netlist port domain { forcepgpok_pgreq } -input -async
netlist port domain { ip_pg_wake } -input -async
netlist port domain { ism_lock_b } -clock gpsb_clk
netlist port domain { fismdfx_force_clkreq } -input -async
netlist port domain { clkreq } -input  -async -module { CdcMainClock }

netlist port domain cfg_clkgate_disabled -input -async
netlist port domain cfg_clkreq_ctl_disabled -input -async
netlist port domain cfg_clkgate_holdoff -clock gpsb_clk
netlist port domain cfg_pwrgate_holdoff -input -async
netlist port domain cfg_clkreq_off_holdoff -clock gpsb_clk
netlist port domain cfg_clkreq_syncoff_holdoff -clock gpsb_clk


# Define Blackbox 
#netlist blackbox visa_unit_mux_s
#netlist blackbox rcfwl_cdc_wrapper_unit_mux0_auid_gen_module
#netlist blackbox rcfwl_cdc_wrapper_unit_mux1_auid_gen_module

## hier parameters
hier parameter AREQ -range 1 4
hier parameter NUM_EP_ATTACHED -range 1 4

# Set CDC Analysis constraints 
# cdc reconvergence -depth 1 -divergence_depth 1 
# cdc preference -fifo_scheme -handshake_scheme  
cdc reconvergence

#waivers
#  cdc report crossing -scheme async_reset -module rcfwl_cdc_wrapper -severity waived -message {all cases the recieving module is a ctech doublesync cell}
#  cdc report crossing -scheme shift_reg -module rcfwl_cdc_wrapper -severity waived -message {all cases the recieving module is a ctech doublesync cell}