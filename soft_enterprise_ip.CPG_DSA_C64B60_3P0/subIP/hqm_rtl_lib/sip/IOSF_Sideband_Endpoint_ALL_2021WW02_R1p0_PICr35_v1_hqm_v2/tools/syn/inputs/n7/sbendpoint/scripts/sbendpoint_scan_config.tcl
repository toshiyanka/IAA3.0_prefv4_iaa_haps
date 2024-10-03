# -------------------------------------------------------------------------------------------------------------------------------------------------
#                                                         RDT DFT DESIGN CONSTRAINTS FILE
# -------------------------------------------------------------------------------------------------------------------------------------------------
# Design unit:  sbendpoint
# Information extracted from: /nfs/fm/disks/fm_infrach_00003/DANA.SBE.DC.DBG/IOSF_Sideband_Endpoint_ALL_2016WW18_R1p0_PICr13/target/sbe/p1273/aceroot/results/DC/sbendpoint/spyglassdft/outputs/sbendpoint.ip_info
# Created by: DTS ISAF flow translate_ip_info script
# Creation date: 07/13/2016
# -------------------------------------------------------------------------------------------------------------------------------------------------


#{{{  ---------------------------------------------------------- TRANSLATED SECTION --------------------------------------------------------------

# All constraints in the section below were translated from the global defaults file and/or ip_info file.  Global default constraints
# can be identified by the keywords in their comment, ?DFT GLOBAL?.   A chassis compliant design should have all of the
# DFT GLOBAL testmode constrained ports in this section and should not require additional testmode constraints to pass scan
# DRC.  If the user requires additional testmode constraints to pass scan DRC they should work with the IP owner to made the IP
# chassis scan compliant and eliminate all additional testmode signals.  Users should not add or modify any constraints in this
# section.  All user constraints must be placed in the user section at the bottom of this file or they will be ignored when
# converting constraints back to IP info format.

#{{{ - Configuration Section

set_dft_insertion_configuration -preserve_design_name true 
set_dft_insertion_configuration -synthesis_optimization none 

set_dft_drc_configuration -internal_pins enable 

set_scan_configuration -style multiplexed_flip_flop -max_length 200 -add_lockup false -clock_mixing no_mix -replace false -voltage_mixing false -power_domain_mixing false 

set_dft_configuration -scan enable 

global G_DESIGN_NAME 

global G_SYN_REPORTS 

lappend G_SYN_REPORTS(syn_final) isaf_audit_package 

setvar G_IGNORE_DFX_HANDLER_VAR_FOR_DRC 1 
setvar G_DFX_HANDLER_SCAN_IN_PINS       "test_si*"
setvar G_DFX_HANDLER_SCAN_OUT_PINS      "test_so*"
setvar G_DFX_HANDLER_SCAN_ENABLE_PIN    "test_se"
setvar G_DFX_ADDITIONAL_TEST_MODE_PIN   "*fscan_clkungate"
setvar G_DFX_HANDLER_TEST_MODE_PIN      "*fscan_clkungate_syn"
setvar G_DFX_TESTMODE_PORTS             "*fscan_clkungate_syn"
setvar G_PGCB_TEST_MODE_PIN             "*fscan_mode"
if {[sizeof_collection [get_ports -quiet *fscan_shiften*]] == 1} {
   setvar G_DFX_HANDLER_SCAN_ENABLE_PIN    "*fscan_shiften*"
}

# Section below is needed for RDTSyn flow to properly constraint all
# PGCB signals and prevent scan DRC violations
setvar G_DFX_PGCB_UNIT                        "pgcbunit"
setvar G_DFX_PGCB_OVR_CELL                    "*dfxval_*_b_reg"
setvar G_DFX_PGCB_CONSTANT_LOW                "*fdfx_pgcb_ovr \
                                               *fscan_ret_ctrl \
                                               *pgcb_tck"
setvar G_DFX_PGCB_CONSTANT_HIGH               "*fdfx_pgcb_bypass"
setvar G_DFX_PGCB_TEST_MODE                   "*fscan_mode"
setvar G_DFX_PGCB_OVR_UNIT                    "pgcbdfxovr"
setvar G_DFX_PGCB_OVR_CONSTANT_HIGH           "dfxovr_isol_en_b"
setvar G_DFX_PGCB_OVR_CONSTANT_LOW            "dfxovr_sleep"
setvar G_DFX_PGCB_OVR_SLEEP_REG_CONSTANT_LOW  "*dfxval_sleep_reg"

set fp [open ./scripts/pgcb_dfx_constraints.tcl w]
if {[info proc syn_dft_generate_pgcb_dfx_constraints] != "" } {
   syn_dft_generate_pgcb_dfx_constraints $fp
} else {
   rdt_print_error "syn_dft_generate_pgcb_dfx_constraints is not defined"
}

close $fp

source ./scripts/pgcb_dfx_constraints.tcl

# Waivers below added to work around current limitation of netlist checker in
# RDTSyn scan insertion flow.  These lines should be removed once the RDTSyn scan
# insertion flow has been enhanced to allow the netlist checker to properly handle
# IP level checks where the DFX handler/CDU is not present.
# setvar G_RULE_WAIVERS(3) "SKIP"
# setvar G_RULE_WAIVERS(4) "SKIP"
# setvar G_RULE_WAIVERS(5) "SKIP"
# setvar G_RULE_WAIVERS(6) "SKIP"
# setvar G_RULE_WAIVERS(7) "SKIP"
# setvar G_RULE_WAIVERS(8) "SKIP"
# setvar G_RULE_WAIVERS(9) "SKIP"

identify_clock_gating 

#}}} - End Configuration Section

#{{{ - Clock Section

# DFT GLOBAL: Fabric Scan Clock. Master scan clock(s) for all scan operations. Drives all the clock controllers and scan data pipelining logic.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_scanclk*"
if {[sizeof_collection [get_ports *fscan_scanclk*]] > 0} {
    foreach_in_collection port [get_ports *fscan_scanclk*] {
        set portname [get_object_name $port]
        echo "Setting DFx scan clock definition on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname] -type ScanClock -timing [list 45 55]
   }
} else {
   echo "No ports matched DFx regular expression *fscan_scanclk*"
}

# Must add comment for constraint
echo "Attempting to apply DFx constraints on pins/ports matching expression agent_clk"
if {[sizeof_collection [get_ports agent_clk]] > 0} {
    foreach_in_collection port [get_ports agent_clk] {
        set portname [get_object_name $port]
        echo "Setting DFx scan clock definition on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname] -type ScanClock -timing [list 45 55]
   }
} else {
   echo "No ports matched DFx regular expression agent_clk"
}

# Must add comment for constraint
echo "Attempting to apply DFx constraints on pins/ports matching expression sbebase/gated_side_clk"
if {[sizeof_collection [get_pins sbebase/gated_side_clk]] > 0} {
    foreach_in_collection port [get_pins sbebase/gated_side_clk] {
        set portname [get_object_name $port]
        echo "Setting DFx scan clock definition on port $portname"
        set_dft_signal -view existing_dft -hookup_pin [get_pins $portname] -type ScanClock -timing [list 45 55]
   }
} else {
   echo "No ports matched DFx regular expression sbebase/gated_side_clk"
}

# Must add comment for constraint
echo "Attempting to apply DFx constraints on pins/ports matching expression sbebase/i_sbcasyncclkreq_side_clk/clk_gated"
if {[sizeof_collection [get_pins sbebase/i_sbcasyncclkreq_side_clk/clk_gated]] > 0} {
    foreach_in_collection port [get_pins sbebase/i_sbcasyncclkreq_side_clk/clk_gated] {
        set portname [get_object_name $port]
        echo "Setting DFx scan clock definition on port $portname"
        set_dft_signal -view existing_dft -hookup_pin [get_pins $portname] -type ScanClock -timing [list 45 55]
   }
} else {
   echo "No ports matched DFx regular expression sbebase/i_sbcasyncclkreq_side_clk/clk_gated"
}

# Must add comment for constraint
echo "Attempting to apply DFx constraints on pins/ports matching expression side_clk"
if {[sizeof_collection [get_ports side_clk]] > 0} {
    foreach_in_collection port [get_ports side_clk] {
        set portname [get_object_name $port]
        echo "Setting DFx scan clock definition on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname] -type ScanClock -timing [list 45 55]
   }
} else {
   echo "No ports matched DFx regular expression side_clk"
}

#}}} - End Clock Section

#{{{ - Reset Section

# Sideband endpoint reset
echo "Attempting to apply DFx constraints on pins/ports matching expression side_rst_b"
if {[sizeof_collection [get_ports side_rst_b]] > 0} {
    foreach_in_collection port [get_ports side_rst_b] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname] -type Reset -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression side_rst_b"
}

#}}} - End Reset Section

#{{{ - Scan Constraints Section

# DFT GLOBAL: Mandatory signal common to all.
echo "Attempting to apply DFx constraints on pins/ports matching expression *dfxovr_isol_en_b*"
if {[sizeof_collection [get_ports *dfxovr_isol_en_b*]] > 0} {
    foreach_in_collection port [get_ports *dfxovr_isol_en_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *dfxovr_isol_en_b*"
}

# DFT GLOBAL: Mandatory signal common to all.
echo "Attempting to apply DFx constraints on pins/ports matching expression *dfxovr_sleep*"
if {[sizeof_collection [get_ports *dfxovr_sleep*]] > 0} {
    foreach_in_collection port [get_ports *dfxovr_sleep*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *dfxovr_sleep*"
}

# DFT GLOBAL: Mandatory signal common to all.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fdfx_pgcb_bypass*"
if {[sizeof_collection [get_ports *fdfx_pgcb_bypass*]] > 0} {
    foreach_in_collection port [get_ports *fdfx_pgcb_bypass*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fdfx_pgcb_bypass*"
}

# DFT GLOBAL: Mandatory signal common to all.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fdfx_pgcb_ovr*"
if {[sizeof_collection [get_ports *fdfx_pgcb_ovr*]] > 0} {
    foreach_in_collection port [get_ports *fdfx_pgcb_ovr*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fdfx_pgcb_ovr*"
}

# DFT GLOBAL: Mandatory signal common to all. equivalent to dfx_pwrgood_rst_b. directly from powerok device pin.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fdfx_powergood*"
if {[sizeof_collection [get_ports *fdfx_powergood*]] > 0} {
    foreach_in_collection port [get_ports *fdfx_powergood*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fdfx_powergood*"
}

# DFT GLOBAL: Mandatory signal common to all.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fdfx_rst_b*"
if {[sizeof_collection [get_ports *fdfx_rst_b*]] > 0} {
    foreach_in_collection port [get_ports *fdfx_rst_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type reset -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fdfx_rst_b*"
}

# DFT GLOBAL: Fabric Scan Bypass Latch Reset bar. Reset input for scan operations that bypasses the internal agent reset logic and applies a reset directly to the latches within the agent.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_byplatrst_b*"
if {[sizeof_collection [get_ports *fscan_byplatrst_b*]] > 0} {
    foreach_in_collection port [get_ports *fscan_byplatrst_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type reset -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_byplatrst_b*"
}

# DFT GLOBAL: Fabric Scan Bypass Reset bar. Reset input for scan operations that bypasses the internal agent reset logic and applies a reset directly to the agent.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_byprst_b*"
if {[sizeof_collection [get_ports *fscan_byprst_b*]] > 0} {
    foreach_in_collection port [get_ports *fscan_byprst_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type reset -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_byprst_b*"
}

# DFT GLOBAL: Static signal used to override clock dividers.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_clkgenctrl*"
if {[sizeof_collection [get_ports *fscan_clkgenctrl*]] > 0} {
    foreach_in_collection port [get_ports *fscan_clkgenctrl*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_clkgenctrl*"
}

# DFT GLOBAL: Fabric Scan Clock Stop. Used to release the clock stop value and shift out captured state. In functional and scan mode this signal is at logic zero.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_clkstop*"
if {[sizeof_collection [get_ports *fscan_clkstop*]] > 0} {
    foreach_in_collection port [get_ports *fscan_clkstop*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_clkstop*"
}

# DFT GLOBAL: Fabric Scan Clock Ungate. The fscan_clkungate signal is the dynamic async signal routed to te signal of RTL inserted clock gating cells.  The fscan_clkungate_syn signal is the dynamic async signal routed to te signal of synthesis inserted clock gate cells (never used in RTL)
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_clkungate*"
if {[sizeof_collection [get_ports *fscan_clkungate*]] > 0} {
    foreach_in_collection port [get_ports *fscan_clkungate*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        if { [regexp {_syn$} $portname] == 1 } {
           set_dft_signal -view spec -port [get_ports $portname ] -type TestMode -active_state 1 -usage clock_gating
        } else {
           set_dft_signal -view existing_dft -port [get_ports $portname ] -type TestMode -active_state 1 
        }
   }
} else {
   echo "No ports matched DFx regular expression *fscan_clkungate*"
}

# DFT GLOBAL: Fabric EDT Clock. Mentor TestKompress EDT logic clock signal. Needed in an agent that is implementing EDT compression.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_edtclk*"
if {[sizeof_collection [get_ports *fscan_edtclk*]] > 0} {
    foreach_in_collection port [get_ports *fscan_edtclk*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_edtclk*"
}

# DFT GLOBAL: Fabric EDT Update. Mentor TestKompress EDT logic clock signal. Needed in an agent that is implementing EDT compression.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_edtupdate*"
if {[sizeof_collection [get_ports *fscan_edtupdate*]] > 0} {
    foreach_in_collection port [get_ports *fscan_edtupdate*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_edtupdate*"
}

# DFT GLOBAL: Fabric Scan Latch Closed bar. Controls the latch closed during scan operations.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_latchclosed_b*"
if {[sizeof_collection [get_ports *fscan_latchclosed_b*]] > 0} {
    foreach_in_collection port [get_ports *fscan_latchclosed_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_latchclosed_b*"
}

# DFT GLOBAL: Fabric Scan Latch Open Enable. Controls the latch open during scan operations.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_latchopen*"
if {[sizeof_collection [get_ports *fscan_latchopen*]] > 0} {
    foreach_in_collection port [get_ports *fscan_latchopen*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_latchopen*"
}

# DFT GLOBAL: Fabric Scan Mode. This signal enables the scan mode for this agent.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_mode"
if {[sizeof_collection [get_ports *fscan_mode]] > 0} {
    foreach_in_collection port [get_ports *fscan_mode] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type TestMode -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_mode"
}

# DFT GLOBAL: Fabric Scan At-speed Mode. This signal enables the at-speed mode for this agent.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_mode_atspeed"
if {[sizeof_collection [get_ports *fscan_mode_atspeed]] > 0} {
    foreach_in_collection port [get_ports *fscan_mode_atspeed] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_mode_atspeed"
}

# DFT GLOBAL: Dynamic Async signal mapped to ram output enable gate. This is used to block X values from the array prior to executing a read cycle on known data so as to not pollute downstream logic with X values.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_ram_odis_b*"
if {[sizeof_collection [get_ports *fscan_ram_odis_b*]] > 0} {
    foreach_in_collection port [get_ports *fscan_ram_odis_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_ram_odis_b*"
}

# DFT GLOBAL: Dynamic Async signal mapped to arrays read port to disable read during scan shift so as to not disturb the array.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_ram_rddis_b*"
if {[sizeof_collection [get_ports *fscan_ram_rddis_b*]] > 0} {
    foreach_in_collection port [get_ports *fscan_ram_rddis_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_ram_rddis_b*"
}

# DFT GLOBAL: Dynamic Async signal mapped to arrays write port to disable write during scan shift so as to not disturb the array.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_ram_wrdis_b*"
if {[sizeof_collection [get_ports *fscan_ram_wrdis_b*]] > 0} {
    foreach_in_collection port [get_ports *fscan_ram_wrdis_b*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_ram_wrdis_b*"
}

# DFT GLOBAL: Mandatory signal common to all.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_ret_ctrl*"
if {[sizeof_collection [get_ports *fscan_ret_ctrl*]] > 0} {
    foreach_in_collection port [get_ports *fscan_ret_ctrl*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 0 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 0 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_ret_ctrl*"
}

# DFT GLOBAL: Fabric Scan Reset Bypass Enable. Enables the ability for the bypass reset signals to be active.  0: Reset bypass and Latch reset bypass are ignored.  1: Reset bypass and Latch reset bypass are active.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_rstbypen*"
if {[sizeof_collection [get_ports *fscan_rstbypen*]] > 0} {
    foreach_in_collection port [get_ports *fscan_rstbypen*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_rstbypen*"
}

# DFT GLOBAL: Fabric Scan Shift Enable. Controls shifting of data and control chains within the agent.
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_shiften*"
if {[sizeof_collection [get_ports *fscan_shiften*]] > 0} {
    foreach_in_collection port [get_ports *fscan_shiften*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view spec -port [get_ports $portname ] -type scanenable -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_shiften*"
}

# DFT GLOBAL: Dynamic Async signal controlling shift or capture logic in scan controllers (SRC, SCC, SASC).
echo "Attempting to apply DFx constraints on pins/ports matching expression *fscan_state*"
if {[sizeof_collection [get_ports *fscan_state*]] > 0} {
    foreach_in_collection port [get_ports *fscan_state*] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression *fscan_state*"
}

# Testmode initialization for fabric functional clock for sideband router
# Skipping scan clock waveform constraint "agent_clk"; constraint ommitted

#HSD: 1406707681, 1406707678 should declara only one value of fscan_byprst_b and default is active state 0

# Dynamic async signal mapped onto functional reset for Flip-flops when fscan_rstbypen is set.
#echo "Attempting to apply DFx constraints on pins/ports matching expression fscan_byprst_b"
#if {[sizeof_collection [get_ports fscan_byprst_b]] > 0} {
#    foreach_in_collection port [get_ports fscan_byprst_b] {
#        set portname [get_object_name $port]
#        echo "Setting DFx constant of 1 on port $portname"
#        set_dft_signal -view existing_dft -port [get_ports $portname ] -type Constant -active_state 1 
#   }
#} else {
#   echo "No ports matched DFx regular expression fscan_byprst_b"
#}

# Static signal routed to the muxes used for reset bypass
echo "Attempting to apply DFx constraints on pins/ports matching expression fscan_rstbypen"
if {[sizeof_collection [get_ports fscan_rstbypen]] > 0} {
    foreach_in_collection port [get_ports fscan_rstbypen] {
        set portname [get_object_name $port]
        echo "Setting DFx constant of 1 on port $portname"
        set_dft_signal -view existing_dft -port [get_ports $portname ] -type Constant -active_state 1 
   }
} else {
   echo "No ports matched DFx regular expression fscan_rstbypen"
}

# Testmode initialization for fabric functional clock for sideband router
# Skipping scan clock waveform constraint "side_clk"; constraint ommitted

#}}} - End Scan Constraints Section

#{{{ - Nonscan Section

setvar G_DFX_NONSCAN_INSTANCES "*_WTAP_* *_bist_wrapper_* *_mbist_* *_no_scan* *_nonscan* *_noscan* *_stap_* *_tap_* *_visa_*"

setvar G_DFX_NONSCAN_DESIGNS "*_WTAP_* *_bist_wrapper_* *_mbist_* *_no_scan* *_nonscan* *_noscan* *_stap_* *_tap_* *_visa_*"

# DFT GLOBAL: JTAG is test only logic and should not be scanned.
set_scan_element false [get_cells -hier *_WTAP_*]

# DFT GLOBAL: MBIST logic is test only logic and should not be scanned. It is assumed that manufacturing will run MBIST tests which will cover logic.
set_scan_element false [get_cells -hier *_bist_wrapper_*]

# DFT GLOBAL: MBIST logic is test only logic and should not be scanned. It is assumed that manufacturing will run MBIST tests which will cover logic.
set_scan_element false [get_cells -hier *_mbist_*]

# DFT GLOBAL: Registers tagged with *_no_scan* are architecturally planned non-scan testable logic and should not be scanned.
set_scan_element false [get_cells -hier *_no_scan*]

# DFT GLOBAL: Registers tagged with *_nonscan* are architecturally planned non-scan testable logic and should not be scanned.
set_scan_element false [get_cells -hier *_nonscan*]

# DFT GLOBAL: Registers tagged with *_noscan* are architecturally planned non-scan testable logic and should not be scanned.
set_scan_element false [get_cells -hier *_noscan*]

# DFT GLOBAL: JTAG is test only logic and should not be scanned.
set_scan_element false [get_cells -hier *_stap_*]

# DFT GLOBAL: JTAG is test only logic and should not be scanned.
set_scan_element false [get_cells -hier *_tap_*]

# DFT GLOBAL: VISA is test only logic and should not be scanned. It is assumed that manufacturing will run VISA patgen test to cover logic.
set_scan_element false [get_cells -hier *_visa_*]

# The line below is needed to prevent elements from being scan flop replaced
if { [sizeof_collection  [get_cells * -hierarchical -filter "scan_element == false"]] > 0 } {
   set_scan_configuration -exclude_elements [get_cells * -hierarchical -filter "scan_element == false"]
}

#}}} - End Nonscan Section


#}}}  -------------------------------------------------------- END TRANSLATED SECTION ------------------------------------------------------------



#{{{  ------------------------------------------------------- FROM SPYGLASS OPTIONS FILE ---------------------------------------------------------
#}}}  ----------------------------------------------------- END FROM SPYGLASS OPTIONS FILE -------------------------------------------------------

#{{{  --------------------------------------------------------------- USER SECTION ------------------------------------------------------------------
# ALL user constraints should be placed in this section.  DO NOT add/change/remove constraints from any other section in this
# file as the changes will be completely  ignored by the translator when converting back to ip_info format.



#}}}  ------------------------------------------------------------ END USER SECTION ---------------------------------------------------------------

set_scan_state test_ready
set_scan_configuration -style multiplexed_flip_flop -max_length 200 -add_lockup false -clock_mixing no_mix -replace false

