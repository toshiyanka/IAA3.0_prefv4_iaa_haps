
#=======================================#
# CDC directives for instance unit_mux0 #
#=======================================#

# Common properties
hier block -user_specified visa_unit_mux_s -instance unit_mux0

# Output lanes and clocks
netlist clock {unit_mux0.ss_clk_out[*]} -group VISA_SSCLK_GROUP -module visa_unit_mux_s
hier clock ss_clk_out -group VISA_SSCLK_GROUP -module visa_unit_mux_s -instance unit_mux0
hier port domain {lane_out[0]} -clock {ss_clk_out[0]} -module visa_unit_mux_s -instance unit_mux0

# Xbar lanes and clocks
netlist clock {unit_mux0.xbar_ss_clk_out[*]} -group VISA_SSCLK_GROUP -module visa_unit_mux_s
hier clock xbar_ss_clk_out -group VISA_SSCLK_GROUP -module visa_unit_mux_s -instance unit_mux0
hier port domain {xbar_out[0]} -clock {xbar_ss_clk_out[0]} -module visa_unit_mux_s -instance unit_mux0

# Serial configuration
hier clock {serial_cfg_in[0]} -group VISACFGCLK_GROUP -module visa_unit_mux_s -instance unit_mux0
hier port domain {serial_cfg_in[2:1]} -clock {serial_cfg_in[0]} -module visa_unit_mux_s -instance unit_mux0
hier clock {serial_cfg_out[0]} -group VISACFGCLK_GROUP -module visa_unit_mux_s -instance unit_mux0
hier port domain {serial_cfg_out[2:1]} -clock {serial_cfg_out[0]} -module visa_unit_mux_s -instance unit_mux0

# Stable ports
hier stable reg_start_index -module visa_unit_mux_s -instance unit_mux0
hier stable customer_disable -module visa_unit_mux_s -instance unit_mux0
hier stable fscan_mode -module visa_unit_mux_s -instance unit_mux0
hier stable visa_enabled -module visa_unit_mux_s -instance unit_mux0
hier stable visa_resetb -module visa_unit_mux_s -instance unit_mux0
hier stable all_disable -module visa_unit_mux_s -instance unit_mux0
hier stable visa_unit_id -module visa_unit_mux_s -instance unit_mux0

# Input clocks
hier clock {src_clk[0]} -module visa_unit_mux_s -instance unit_mux0

# Input lane to input clock affiliations
hier port domain {lane_in[0:0][7:0]} -clock {src_clk[0]} -module visa_unit_mux_s -instance unit_mux0

#=======================================#
# CDC directives for instance unit_mux1 #
#=======================================#

# Common properties
hier block -user_specified visa_unit_mux_s -instance unit_mux1

# Output lanes and clocks
netlist clock {unit_mux1.ss_clk_out[*]} -group VISA_SSCLK_GROUP -module visa_unit_mux_s
hier clock ss_clk_out -group VISA_SSCLK_GROUP -module visa_unit_mux_s -instance unit_mux1
hier port domain {lane_out[0]} -clock {ss_clk_out[0]} -module visa_unit_mux_s -instance unit_mux1
hier port domain {lane_out[1]} -clock {ss_clk_out[1]} -module visa_unit_mux_s -instance unit_mux1

# Xbar lanes and clocks
netlist clock {unit_mux1.xbar_ss_clk_out[*]} -group VISA_SSCLK_GROUP -module visa_unit_mux_s
hier clock xbar_ss_clk_out -group VISA_SSCLK_GROUP -module visa_unit_mux_s -instance unit_mux1
hier port domain {xbar_out[0]} -clock {xbar_ss_clk_out[0]} -module visa_unit_mux_s -instance unit_mux1

# Serial configuration
hier clock {serial_cfg_in[0]} -group VISACFGCLK_GROUP -module visa_unit_mux_s -instance unit_mux1
hier port domain {serial_cfg_in[2:1]} -clock {serial_cfg_in[0]} -module visa_unit_mux_s -instance unit_mux1
hier clock {serial_cfg_out[0]} -group VISACFGCLK_GROUP -module visa_unit_mux_s -instance unit_mux1
hier port domain {serial_cfg_out[2:1]} -clock {serial_cfg_out[0]} -module visa_unit_mux_s -instance unit_mux1

# Stable ports
hier stable reg_start_index -module visa_unit_mux_s -instance unit_mux1
hier stable customer_disable -module visa_unit_mux_s -instance unit_mux1
hier stable fscan_mode -module visa_unit_mux_s -instance unit_mux1
hier stable visa_enabled -module visa_unit_mux_s -instance unit_mux1
hier stable visa_resetb -module visa_unit_mux_s -instance unit_mux1
hier stable all_disable -module visa_unit_mux_s -instance unit_mux1
hier stable visa_unit_id -module visa_unit_mux_s -instance unit_mux1

# Input clocks
hier clock {src_clk[0]} -module visa_unit_mux_s -instance unit_mux1

# Input lane to input clock affiliations
hier port domain {lane_in[1:0][7:0]} -clock {src_clk[0]} -module visa_unit_mux_s -instance unit_mux1
