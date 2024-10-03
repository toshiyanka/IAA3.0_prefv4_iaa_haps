################################################################################
# USER's SCAN CONFIGURATION FILE
#
# This is the scan-config template file.  User is expected to edit this
# file based on the scan-architecture of each partition/design. Each partition 
# or design is required to have one file to direct how Synopsys DFTC performs 
# scan-insertion. Without this file, RDTsyn will default the scan-insertion step and attempt to
# auto-insert scan-chain; However,  without proper setting defined by user,
# the resultant scan-chain will not reflect the intended scan architecture for a design.
# test-coverage will not be consistent and low
# Owner: Vrpradeep Bharadwaj
#
# IMPORTANT:
# ----------
# RDTsyn flow strongly recommended this file as a requirement for a design/partition 
# to be scan-inserted. In addition, G_INSERT_SCAN needs to be set to 1.
#
#
# How to enable Scan-Insertion using Synopsys DFTC
#
# 1. Setup RDTSYN synthesis environment
# 2. Set G_INSERT_SCAN to 1 in block_setup.tcl
#
# 3. Set G_DFX_NONSCAN_DESIGNS [list <design names> ] in block_setup.tcl on design
#    which you donot want to scan (such as EDT or WTAP controller).
#
# 4. Set G_DFX_NONSCAN_INSTANCES [list of instance names ] in block_setup.tcl on instances 
#    which you donot want to scan (such as EDT or WTAP controller).
#
#		NOTE: specified design will not get scanned or have their flops swapped to scan-Flops.
#
# 5. Edit this template to define all required DFT signals
# 6. Copy this template file to ./scripts and rename as <design>_scan_config.stcl
#################################################################################

##############################################################################
# These commands are predefined in insert_dft.tcl in RDT flow
# User can update these value as needed
#
# set_dft_insertion_configuration -preserve_design_name true -synthesis_optimization none -unscan true"
#
# Setting to enable internal pins such as clock, scan-enable to be specified
# set_dft_drc_configuration -clock_gating_init_cycles 4 -internal_pins enable"
#
# We are not doing at-speed SCAN only normal scan with fixed clock frequency
# set_scan_configuration -style multiplexed_flip_flop"
# set_scan_configuration -clock_mixing mix_clocks"
# set_scan_configuration -insert_terminal_lockup true -add_lockup true"
# set_scan_configuration -replace false"
# set_scan_configuration -create_dedicated_scan_out_ports false"
# set_scan_configuration -chain_count [llength $dfx_scan_in]"
#
# Remove latches from being used for scan-chain. latch is transparent in scan
# set_scan_element false \[all_registers -level_sensitive\]"
#
##############################################################################

##############################################################################
# Define all the clocks to be included into SCAN clocks list, 1 per line.
# Whichever the "real" clocks you have defined for your block synthesis, you 
# should define here as well.
# Modify
##############################################################################
# example 0101 clock
#set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port [get_ports bb_cclk]
#
# example 1010 clock
#set_dft_signal -view existing_dft -type ScanClock -timing {55 45} -port [get_ports bb_cclk]

##############################################################################
# Define all the resets to be included into SCAN reset list
# Modify
##############################################################################
# example
#set_dft_signal -view existing_dft -port [get_ports {sbi_rst_100_core_b int_core_pok_rst_bbc_b fscan_byprst_b pcie2_powergoodrst_b}] -type Reset -active_state 0

##############################################################################
# Define other signal constraints as specified on the IOSF interface for
# supporting SCAN insertion and scan control
# Modify
##############################################################################
# example
#set_dft_signal -view existing_dft -port [get_ports {fscan_latchopen fscan_clkungate}] -type Constant -active_state 1

##############################################################################
# DEFINING SCANENABLE SIGNALS
#
# Define scan enable
# Modify
##############################################################################
# example
#set_dft_signal -view existing_dft -port [get_ports {fscan_shiften}] -type ScanEnable -active_state 1


##############################################################################
# EXCLUDE ELEMENT FROM BEING SCANNED
#
# Exclude the any elements from being used as part of the scan chain.
# Reason: These are redundant logic and the clocks to these flops are tied to
#         ground. Or this is the test unit and hence the flops should not be scanned
# 
# NOTE: This is in addition to the G_DFX_NONSCAN_DESIGNS if there is any
#
# Modify
##############################################################################
# set_scan_configuration -exclude_elements [list ststap_wrapper1]
# or you can use the command below
# set_scan_element false [get_cells vxunit_brv_wrapper1/psf_sata_south/i_clkgate/south_port_idle_flop_reg_0_0]


##############################################################################
# USING WILDCARD to specify DFX signals
# There is situation where you need to define set_dft_signal to a bus or some
# common name.  In that case,  you can use the wildcard to search to pins/nets
# and create a loop to set_dft_signal to individual pin/net.
#
# DO NOT USE WildCard * directly with set_dft_signal.
# Using WildCard * directly will prevent fastcan to reuse the same contraints
#
#
##############################################################################
#example
#set pins [get_pins {stvisa_wrapper1/STVISA1/stap_visa_outbytesel_lvl1_lane0[*]}]
#foreach_in_collection pin $pins {
#   set_dft_signal -view existing_dft -hookup_pin [get_object_name $pin] -type constant -active_state 0
#}


#########################################################################################
# SCAN-IN and SCAN-OUT DEFINITION
#
# 1. CONNECTING TO EXISTING SCAN-IN and SCAN-OUT PORTS
#
# In case that you have existing scan-in and scan-out port/pin that you would
# want to hook up the newly created scan-chains, you must explicitly specify the details.
# below is the sample of how code should look like
#
# set scanOut_pin ""		#define your scan_in_port or pin
# set scanIn_pin ""			#define your scan_out_port or pin
# set_dft_signal -view existing_dft -ScanDataIn [-port|-hookup_pin] $scanIn_pin
# set_dft_signal -view spec -ScanDataIn [-port|-hookup_pin] $scanIn_pin
#
# set_dft_signal -view existing_dft -ScanDataOut [-port|-hookup_pin] $scanOut_pin
# set_dft_signal -view spec -ScanDataOut [-port|-hookup_pin] $scanOut_pin
# set_scan_path chain_<#> -view spec -scan_data_in $scanIn_pin -scan_data_out $scanOut_pin
#
# 2. NO SCAN-IN or SCAN-OUT ports existed in RTL
#
# In the case where there is no existing scan-in and scan-out port in RTL,  DFTC will
# auto create new scan-in and scan-out ports for each scan-chain it created.
# the naming convention is based on Synopsys variable
# 	test_scan_in_naming_style <test_si%s%s>
# 	test_scan_out_naming_style <test_so%s%s>
#

# Apply Scan Specification to DC-DFT
# create_test_protocol
