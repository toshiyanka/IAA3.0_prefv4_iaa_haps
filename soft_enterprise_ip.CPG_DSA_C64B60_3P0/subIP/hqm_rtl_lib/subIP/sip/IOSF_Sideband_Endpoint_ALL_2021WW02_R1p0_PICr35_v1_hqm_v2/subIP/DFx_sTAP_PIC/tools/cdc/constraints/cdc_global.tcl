#Start of Section A

set qsDebug { nl_path_split -blackbox_unresolved_modules cdc_optimize_perf3 hcdc_check_hier cdc_support_multi_through allow_diff_flags cdc_vclk_for_hier_cdc }; 

cdc preference hier -ctrl_file_models 
cdc synchronizer dff -min 2 -max 5 

netlist constant propagation -enable 
# Based upon feedback from CRC/BXT projects, -reset is removed from above global directive 

cdc report scheme two_dff -severity violation
cdc report scheme bus_two_dff -severity violation
cdc report scheme single_source_reconvergence -severity caution 

#Based on convergence in WW41-2014 CDC WG, following schemes are turned to violations
 
cdc report scheme pulse_sync -severity violation 
cdc report scheme two_dff_phase -severity violation
cdc report scheme bus_two_dff_phase -severity violation
cdc report scheme shift_reg -severity violation
cdc report scheme async_reset -severity violation
cdc report scheme four_latch -severity violation
cdc report scheme bus_four_latch -severity violation

#Based on convergence in WW43-2014 CDC WG, following directive was added
cdc preference hier -conflict_check

configure license queue on

cdc preference -fifo_scheme
#Identify fifo CDC schemes. Default: fifo CDC schemes are reported as memory_sync or multi_bits schemes.

cdc preference -handshake_scheme
#Identify handshake CDC schemes. Default: handshake CDC schemes are reported as dmux or multi_bits schemes.

cdc preference -enable_internal_resets
#Infer internal reset signals as rests. Default: only reset signals derived from primary ports are inferred as resets.Based upon feedback from CRC/BXT projects, this directive is added 


if {$env(CDC_PREFERENCE_BIT_RECON) == "TRUE"} {
cdc preference reconvergence -bit_recon
} else {
   puts "cdc preference reconvergence -bit_recon is not set"
}


if {[info exists env(CDC_PREFERENCE_RECON_DEPTH)]  && $::env(RECON_DEPTH) > 0 } { 
	cdc  preference reconvergence -depth $env(RECON_DEPTH)
} elseif { [info exists env(CDC_PREFERENCE_RECON_DEPTH)]  && $::env(RECON_DEPTH) == 0 } { 
	cdc  preference reconvergence -depth $env(RECON_DEPTH)
puts "Reconvergence POR depth is 2. For further reference, check https://intelpedia.intel.com/images/d/db/Reconvergence_CDC_methodology.pdf"
puts " "
} elseif { [info exists env(CDC_PREFERENCE_RECON_DEPTH)]  && $::env(RECON_DEPTH) < 0 } {  
       puts " Recon Depth is set as a negative number : Set RECON_DEPTH variable value to be 0 or greater." 
       puts "  "
       exit 2	
} else {
 puts " CDC runs is done with Reconvergence (Depth: 0)"

}

#For reconvergence, start with a depth of 0, For further reference, check https://intelpedia.intel.com/images/d/db/Reconvergence_CDC_methodology.pdf

#End of Section A

# Section B: Clocks

# Section C: Resets 

# Section D: Static and Stable signals

# Section E: Waivers
