# Dynamo Generated Constraints

# Module Name:           sbrccfroot_sbr_generic
# Prefix:                iosfsbr_cnlsoc_2015ww02_
# Baseinstance Name:     sbrccfroot
# PGCB Disabled
# PSMI Disabled
# Chassis Compatibility

# Get and store the clock periods of the input clocks
set sbr_clk_period [get_attribute [get_clock sbr_clk] period]
set fabric_reset sbr_rst_b

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              sbrsa
# Port Name:                sbrccfroot
# Port Number:              0 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p0_pok
# CG Enable Name:           p0_cg_en
# IOSF ING ISM:             p0_fabric_side_ism_agent
# IOSF ING IN:              p0_fabric_m
# IOSF ING OUT:             p0_fabric_m
# IOSF EGR ISM:             p0_fabric_side_ism_fabric
# IOSF EGR IN:              p0_fabric_t
# IOSF EGR OUT:             p0_fabric_t

# CG Enable for Port 0
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 0 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 0 finished"
# ISMs for Port 0
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 0 finished"
# Ingress Path for Port 0
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 0 finished"
# Egress Path for Port 0
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p0_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p0_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 0 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              sbrccf0
# Port Name:                sbrccfroot
# Port Number:              1 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p1_pok
# CG Enable Name:           p1_cg_en
# IOSF ING ISM:             p1_agent_side_ism_fabric
# IOSF ING IN:              p1_agent_t
# IOSF ING OUT:             p1_agent_t
# IOSF EGR ISM:             p1_agent_side_ism_agent
# IOSF EGR IN:              p1_agent_m
# IOSF EGR OUT:             p1_agent_m

# CG Enable for Port 1
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 1 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 1 finished"
# ISMs for Port 1
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_agent_side_ism_fabric*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_agent_side_ism_agent*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 1 finished"
# Ingress Path for Port 1
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_agent_teom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_agent_tnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_agent_tpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_agent_tpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_agent_tnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_agent_tpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 1 finished"
# Egress Path for Port 1
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_agent_mnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p1_agent_mpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_agent_meom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_agent_mnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_agent_mpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p1_agent_mpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 1 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              sbrccf1
# Port Name:                sbrccfroot
# Port Number:              2 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p2_pok
# CG Enable Name:           p2_cg_en
# IOSF ING ISM:             p2_agent_side_ism_fabric
# IOSF ING IN:              p2_agent_t
# IOSF ING OUT:             p2_agent_t
# IOSF EGR ISM:             p2_agent_side_ism_agent
# IOSF EGR IN:              p2_agent_m
# IOSF EGR OUT:             p2_agent_m

# CG Enable for Port 2
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 2 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 2 finished"
# ISMs for Port 2
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_agent_side_ism_fabric*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_agent_side_ism_agent*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 2 finished"
# Ingress Path for Port 2
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_agent_teom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_agent_tnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_agent_tpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_agent_tpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_agent_tnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_agent_tpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 2 finished"
# Egress Path for Port 2
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_agent_mnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p2_agent_mpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_agent_meom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_agent_mnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_agent_mpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p2_agent_mpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 2 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              ccf_pll
# Port Name:                sbrccfroot
# Port Number:              3 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p3_pok
# CG Enable Name:           p3_cg_en
# IOSF ING ISM:             p3_fabric_side_ism_agent
# IOSF ING IN:              p3_fabric_m
# IOSF ING OUT:             p3_fabric_m
# IOSF EGR ISM:             p3_fabric_side_ism_fabric
# IOSF EGR IN:              p3_fabric_t
# IOSF EGR OUT:             p3_fabric_t

# CG Enable for Port 3
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 3 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 3 finished"
# ISMs for Port 3
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 3 finished"
# Ingress Path for Port 3
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 3 finished"
# Egress Path for Port 3
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p3_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p3_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 3 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              ncevents
# Port Name:                sbrccfroot
# Port Number:              4 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p4_pok
# CG Enable Name:           p4_cg_en
# IOSF ING ISM:             p4_fabric_side_ism_agent
# IOSF ING IN:              p4_fabric_m
# IOSF ING OUT:             p4_fabric_m
# IOSF EGR ISM:             p4_fabric_side_ism_fabric
# IOSF EGR IN:              p4_fabric_t
# IOSF EGR OUT:             p4_fabric_t

# CG Enable for Port 4
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 4 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 4 finished"
# ISMs for Port 4
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 4 finished"
# Ingress Path for Port 4
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 4 finished"
# Egress Path for Port 4
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p4_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p4_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 4 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              ncracu
# Port Name:                sbrccfroot
# Port Number:              5 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p5_pok
# CG Enable Name:           p5_cg_en
# IOSF ING ISM:             p5_fabric_side_ism_agent
# IOSF ING IN:              p5_fabric_m
# IOSF ING OUT:             p5_fabric_m
# IOSF EGR ISM:             p5_fabric_side_ism_fabric
# IOSF EGR IN:              p5_fabric_t
# IOSF EGR OUT:             p5_fabric_t

# CG Enable for Port 5
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 5 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 5 finished"
# ISMs for Port 5
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 5 finished"
# Ingress Path for Port 5
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 5 finished"
# Egress Path for Port 5
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p5_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p5_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 5 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              sbo
# Port Name:                sbrccfroot
# Port Number:              6 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p6_pok
# CG Enable Name:           p6_cg_en
# IOSF ING ISM:             p6_fabric_side_ism_agent
# IOSF ING IN:              p6_fabric_m
# IOSF ING OUT:             p6_fabric_m
# IOSF EGR ISM:             p6_fabric_side_ism_fabric
# IOSF EGR IN:              p6_fabric_t
# IOSF EGR OUT:             p6_fabric_t

# CG Enable for Port 6
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 6 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 6 finished"
# ISMs for Port 6
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 6 finished"
# Ingress Path for Port 6
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 6 finished"
# Egress Path for Port 6
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p6_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p6_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 6 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              ncdecs
# Port Name:                sbrccfroot
# Port Number:              7 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p7_pok
# CG Enable Name:           p7_cg_en
# IOSF ING ISM:             p7_fabric_side_ism_agent
# IOSF ING IN:              p7_fabric_m
# IOSF ING OUT:             p7_fabric_m
# IOSF EGR ISM:             p7_fabric_side_ism_fabric
# IOSF EGR IN:              p7_fabric_t
# IOSF EGR OUT:             p7_fabric_t

# CG Enable for Port 7
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 7 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 7 finished"
# ISMs for Port 7
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 7 finished"
# Ingress Path for Port 7
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 7 finished"
# Egress Path for Port 7
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p7_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p7_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 7 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              cohtrk
# Port Name:                sbrccfroot
# Port Number:              8 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p8_pok
# CG Enable Name:           p8_cg_en
# IOSF ING ISM:             p8_fabric_side_ism_agent
# IOSF ING IN:              p8_fabric_m
# IOSF ING OUT:             p8_fabric_m
# IOSF EGR ISM:             p8_fabric_side_ism_fabric
# IOSF EGR IN:              p8_fabric_t
# IOSF EGR OUT:             p8_fabric_t

# CG Enable for Port 8
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 8 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 8 finished"
# ISMs for Port 8
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 8 finished"
# Ingress Path for Port 8
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 8 finished"
# Egress Path for Port 8
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p8_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p8_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 8 finished"

# Module Name:              sbrccfroot_sbr_generic
# Router Name:              iosfsb_sniff
# Port Name:                sbrccfroot
# Port Number:              9 
# Router Clock Name:        sbr_clk
# Router Clock Request:     sbr_clk_clkreq
# Router Clock Acknowledge: sbr_clk_clkack
# Port Clock Name:          sbr_clk
# Port Clock Request:       sbr_clk_clkreq
# Port Clock Acknowledge:   sbr_clk_clkack
# Pok Name:                 p9_pok
# CG Enable Name:           p9_cg_en
# IOSF ING ISM:             p9_fabric_side_ism_agent
# IOSF ING IN:              p9_fabric_m
# IOSF ING OUT:             p9_fabric_m
# IOSF EGR ISM:             p9_fabric_side_ism_fabric
# IOSF EGR IN:              p9_fabric_t
# IOSF EGR OUT:             p9_fabric_t

# CG Enable for Port 9
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_cg_en              } -filter {@port_direction==out}]
puts "Output Delay set for Port 9 cg_en finished"
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_pok                } -filter {@port_direction==in}]
puts "Input Delay for Port 9 finished"
# ISMs for Port 9
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_fabric_side_ism_agent*        } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_fabric_side_ism_fabric*        } -filter {@port_direction==out}]
puts "ISM Path Delay for Port 9 finished"
# Ingress Path for Port 9
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_fabric_meom       } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_fabric_mnpput     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_fabric_mpayload*  } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_fabric_mpcput     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_fabric_mnpcup    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_fabric_mpccup    } -filter {@port_direction==out}]
puts "Ingress Path Delay for Port 9 finished"
# Egress Path for Port 9
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_fabric_tnpcup     } -filter {@port_direction==in}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]   [get_ports {p9_fabric_tpccup     } -filter {@port_direction==in}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_fabric_teom      } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_fabric_tnpput    } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_fabric_tpayload* } -filter {@port_direction==out}]
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY]  [get_ports {p9_fabric_tpcput    } -filter {@port_direction==out}]
puts "Egress Path Delay for Port 9 finished"


set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]  [get_ports ${fabric_reset} -filter {@port_direction==in}] -add_delay
puts "${fabric_reset} Reset Delay for Clock sbr_clk added"

set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]  [get_ports {fscan_*} -filter {@port_direction==in}]  -add_delay
set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY] [get_ports {*avisa*         } -filter {@port_direction==out}] -add_delay
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]  [get_ports {visa_ser_cfg_in*} -filter {@port_direction==in}]  -add_delay
puts "DFX Delay for Clock sbr_clk added"

set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_STRAP_DELAY]  [get_ports {cfg_*}   -filter {@port_direction==in}]  -add_delay

set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_RELAXED_DELAY]  [get_ports {fdfx_*}             -filter {@port_direction==in}] -add_delay
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]    [get_ports {oem_secure_policy*} -filter {@port_direction==in}] -add_delay

set_output_delay -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_OUTPUT_DELAY] [get_ports {sbr_clk_clkreq} -filter {@port_direction==out}]
set_input_delay  -clock [get_clock sbr_clk] [expr $sbr_clk_period * $SBR_INPUT_DELAY]  [get_ports {sbr_clk_clkack} -filter {@port_direction==in}]
puts "Asynchronous Clock Request handshake Signals present, applied constraints against sbr_clk"

