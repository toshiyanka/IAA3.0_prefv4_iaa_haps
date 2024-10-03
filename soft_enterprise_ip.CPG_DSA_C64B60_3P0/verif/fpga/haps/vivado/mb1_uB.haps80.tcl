# Copyright (C) 1995-2018 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
############## RUN_VIVADO_HAPS.TCL ##############
### Purpose: Default TCL script for Integrated 
### Vivado Place and Route run.
### Target Vivado Release: Vivado 2017.2/Vivado 2018.1
### History: 
### Added Switch for Strategy mode to replace If
### Added PrepareReadback to write logic location file
### Added VerdiMode to write post par verilog file
### Added Property to Promte/Demote Warning/Error message
### Improved Incremental Flow commands for readability 
### $Header: //synplicity/ui201809pcp1/misc/run_vivado_haps_template.tcl#4 $
### End History
################################################# 
puts "Script version is \$Header: //synplicity/ui201809pcp1/misc/run_vivado_haps_template.tcl#4 $"
#################################################
###     SET DESIGN VARIABLES      ###
#################################################
set DesignName  	"mb1_uB"
set FamilyName  	"VIRTEX UltraScale FPGAs"
set DeviceName  	"XCVU440"
set PackageName 	"FLGA2892"
set SpeedGrade  	"-1-c"
set TopModule   	"mb1_uB"
set PartName    	"XCVU440-FLGA2892-1-c"
set DcpFile			""
set VivadoOptionFiles ""
set InputMode   	"EDIF"
set Flow   			"Standard" ;# Flow can be set to "Incremental" or "Standard"
set StrategyMode	"default"
set CompressOutputs "1"
#StrategyMode can be set to "timing_qor","fast_turn_around" or "default" 
#Only one StrategyMode can be specified at a time
set PrepareReadback "1"
set VerdiMode "0"
set PROJ_NAME mb1_uB
set EDIF _edif
if {""==""} {
	#set XdcOutputFile	"${DesignName}_post_par.xdc"
	set XdcOutputFile	"import_dcp.xdc"
} else {
	set XdcOutputFile	""
}
if {""==""} {
	#set DlyOutputFile	"${DesignName}_post_par.dly"
	set DlyOutputFile	"import_dcp.dly"
} else {
	set DlyOutputFile	""
}

#################################################
###     SETUP STRATEGY AND FLAGS    ###
#################################################
puts "StrategyMode is ${StrategyMode}"
switch -- $StrategyMode {
	"timing_qor" {
		set opt_design_flags    "-directive Explore"
		set place_design_flags  "-directive Explore"
		set route_design_flags  "-directive Explore"
	}
	"fast_turn_around" {
		set opt_design_flags    "-directive RuntimeOptimized"
		set place_design_flags  "-directive RuntimeOptimized"
		set route_design_flags  "-directive RuntimeOptimized"
	}
	default {
		set opt_design_flags    ""
		set place_design_flags  ""
		set route_design_flags  ""
	}
}
set check_hstdm_missing_constraints  "1"
set hstdm_missing_constraints_xdc "hstdm_missing_constraints.xdc"
### If "report_hstdm_missing_constraints" runs for too long, 
### try lowering the default max_paths value below; e.g., by a factor of 2
set hstdm_missing_constraints_max_paths 10000
### If "report_hstdm_missing_constraints" is not finding all the missing constraints,
### increase the nworst value; e.g., in increments of 3.  Runtime may increase.
set hstdm_missing_constraints_nworst 1
set pdelay_info_tcl "pdelay_info.tcl"
set pdelay_reports "pdelay_reports"
set write_bitstream_enable  "1"
set write_post_par_verilog  "0"
#Adding additional steps to modify read_xdc and link_design due to Vivado Buffer constraint issue (Xilinx CR-981618) with Vivado version 201[7|8].[1|2|2.1|3|3.1|4]
# Rename 
if {[regexp {^201[7-8]\.[1-4].*} [version -short]]} {
	set XdcList {}
	catch {rename read_xdc read_xdc_vivado}
	catch {rename link_design link_design_vivado}
	proc read_xdc { xdc } {
		global XdcList
		puts "Appending $xdc to xdclist"
		lappend XdcList $xdc
	}
	proc link_design { args } {
		global XdcList
		puts "Evaluating link_design"
		eval link_design_vivado $args
		puts "Reading xdc $XdcList"
		read_xdc_vivado $XdcList
		puts "Restoring original commands"
		rename read_xdc ""
		rename link_design ""
		rename read_xdc_vivado read_xdc
		rename link_design_vivado link_design
		set XdcList {}
	}
add_files ./$PROJ_NAME.edf
add_files ./$PROJ_NAME$EDIF.xdc
if {[file exists "dtd_ddr3_ht3_constr.tcl"]} {
  source dtd_ddr3_ht3_constr.tcl
}

read_xdc $::env(MODEL_ROOT)/verif/fpga/haps/vivado/lce_visal_19Apr_buskew_12mhz.xdc
link_design -top $PROJ_NAME
#################################################
###     SETUP DESIGN     ###
#################################################
set_property target_part ${PartName} [current_fileset -constrset]
set_property design_mode GateLvl [current_fileset]

### Turn off a restriction on the number of clock objects allowed in a list for create_*clock commands
catch {set_param sta.maxSourcesPerClock -1}

### Suppresses warning about multiple objects in a clock list
catch {set_msg_config -id {Constraints 18-633} -suppress}

### Suppresses warning about changing SEVERITY below
catch {set_msg_config -id {Vivado 12-4430} -suppress}

### Demotes error to warning about GTGREFCLK_ACTIVE inserted for multiview instrumentation
catch {set_property SEVERITY {warning} [get_drc_checks REQP-46]}
catch {set_property SEVERITY {warning} [get_drc_checks REQP-56]}
### Demotes error to warning message about RXTX_BITSLICE for HSTDM
catch {set_property SEVERITY {Warning} [get_drc_checks REQP-1932]}
catch {set_property SEVERITY {Warning} [get_drc_checks PDRC-194]}

### Promotes critical warning on unroutability to an error
catch {set_msg_config -id {Route 35-162} -new_severity ERROR}

# DRC for HAPS system
if {[file exists "haps_drc_vivado.tcl"]} {
	source -notrace haps_drc_vivado.tcl
	# HSTDM internal timing DRC is default on.
	# To disable these DRC, uncomment following two lines.
	# catch {set_property IS_ENABLED 0 [get_drc_checks {HATDM-1}]}
	# catch {set_property IS_ENABLED 0 [get_drc_checks {HATDM-2}]}
}

if {${InputMode} == "EDIF"} {
	set_property edif_top_file ${DesignName}.edf [current_fileset]
	if {[file exists ${DesignName}.edf]} { 
		read_edif ${DesignName}.edf 
	}
	set TopModule [find_top]
	if {[file exists ${DesignName}_edif.xdc]} {
		read_xdc ${DesignName}_edif.xdc 
	}
	if {[file exists "dtd_ddr3_ht3_constr.tcl"]} {
		source -notrace dtd_ddr3_ht3_constr.tcl
	}
} 

if {${InputMode} == "VM"} {
	if {[file exists ${DesignName}.vm]} { 
		read_verilog ${DesignName}.vm 
	}
	set TopModule [find_top]
	if {[file exists ${DesignName}.xdc]} { 
		read_xdc ${DesignName}.xdc 
	}
	set_property top ${TopModule} [current_fileset]
}

#################################################
###     SOURCE OPTION FILES IF THEY EXISTS ###
#################################################
if { [file exists umr3_pcie_options.tcl] } {
    puts "Adding UMRBus 3.0 PCIe IP"
    source umr3_pcie_options.tcl
}
if { [file exists haps80d_options.tcl] } {
    puts "Adding System IP FIFO for 32bit UMRBus 2.0"
    source haps80d_options.tcl
}
if {[file exists hapsip.tcl]} {
    source hapsip.tcl
}

foreach parOptionFile $VivadoOptionFiles {
	if {[file exists $parOptionFile]} {
		source $parOptionFile
	}
}

#################################################
###    RUN DESIGN     ###
#################################################
# run link_design
link_design -top ${TopModule}
if {[file exists "clock_groups.tcl"]} {
	source -notrace clock_groups.tcl
}
# check missing constraints between user and hstdm
if {$check_hstdm_missing_constraints} {
	puts "Checking HSTDM missing constraints!"
	catch {report_hstdm_missing_constraints -xdc ${hstdm_missing_constraints_xdc} -max_paths ${hstdm_missing_constraints_max_paths} -nworst ${hstdm_missing_constraints_nworst}}
}
if {[file exists ${hstdm_missing_constraints_xdc}]} {
	puts "Adding  ${hstdm_missing_constraints_xdc} to the design"
	read_xdc ${hstdm_missing_constraints_xdc} 
}
# load hstdm placement constraints
if {[file exists "run_hstdm_loc.xdc"]} {
	if {[file exists "run_hstdm_loc_pre.tcl"]} { 
		source -notrace run_hstdm_loc_pre.tcl
	}
	read_xdc run_hstdm_loc.xdc
}

#Evaluate options and run opt_design
eval opt_design $opt_design_flags

###     FOR INCREMENTAL FLOW     ###
puts "Flow is ${Flow}"
if {${Flow} == "Incremental"} {
#Use DCP from previous P&R run for Incremental Flow
	if {[file exists "${DesignName}.dcp"]} {
		puts "Using ${DesignName}.dcp for Incremental Place and Route" 
		read_checkpoint -incremental ${DesignName}.dcp
		report_incremental_reuse
	} else {
		puts "${DesignName}.dcp does not exist. Running Place and Route" 
	}
}
#Evaluate options and run place_design

### Xilinx recommends enabling this option (-no_bufg_opt) with 2017.[1|2] and 2018.1 to avoid possible placement failures -
if {[regexp {^201[7-8]\.[1-4].*} [version -short]]} {
	eval place_design -no_bufg_opt $place_design_flags
} else {
	eval place_design $place_design_flags
}


### On HAPS-80/80D connectors J4 and J11 (pins A[8] and A[9]) are dual purpose pins connected to I2C_SCL and I2C_SDA on slave SLRs (SLR0 and SLR2)
### Disable SYSMON prevents I2C functionality on these pins from getting activated and corrupting input signal due to pulldown
### Xilinx recommends adding a disable SYSMONE 
### https://www.xilinx.com/support/answers/65957.html   :  AR# 65957
### https://www.xilinx.com/support/answers/71744.html   :  AR# 71744
if { $DeviceName == "XCVU440" } {
	puts "Disabling SYSMONE for $DeviceName"
	create_cell -reference SYSMONE1 haps_dummy_sysmone_SLR0
	create_cell -reference SYSMONE1 haps_dummy_sysmone_SLR2
	place_cell haps_dummy_sysmone_SLR0 SYSMONE1_X0Y0/SYSMONE1
	place_cell haps_dummy_sysmone_SLR2 SYSMONE1_X0Y2/SYSMONE1
	set_property INIT_42 16'h0003 [get_cells haps_dummy_sysmone_SLR0]
	set_property INIT_42 16'h0003 [get_cells haps_dummy_sysmone_SLR2]
	set_property INIT_74 16'h8000 [get_cells haps_dummy_sysmone_SLR2]
	set_property INIT_74 16'h8000 [get_cells haps_dummy_sysmone_SLR0]
}

write_checkpoint -force post_place.dcp

#Evaluate options and run route_design
eval route_design $route_design_flags

if {[file exists "run_hstdm_postroute.tcl"]} { 
	source -notrace run_hstdm_postroute.tcl
}


proc get_haps_bitstream_identification {} {
	set bitstream_identification 0
	set number_of_bits_timestamp 20
	set version_string [version -short]
	set version_valid 0
	set version_year 0
	set version_number1 0
	set version_number2 0
	# version year ranges from 2016 to 2047
	set version_year_base 2016
	set version_year_max [expr {$version_year_base+(1<<5)-1}]
	if {[regexp {^(20[0-9][0-9])\.([1-7])} $version_string dummy version_year version_number1]} {
		#
	} elseif {[regexp {^(20[0-9][0-9])\.([1-7])\.([1-7])} $version_string dummy version_year version_number1 version_number2]} {
		#
	}
	if {$version_year>=$version_year_base && $version_year<=$version_year_max} {
		set version_valid 1
		set version_year [expr {$version_year-$version_year_base}]
	}
	set bitstream_pnr_version [expr {($version_number2) + ($version_number1<<3) + ($version_year<<6) + ($version_valid<<11)}]
	set bitstream_identification [expr {$bitstream_pnr_version<<$number_of_bits_timestamp}]
	# resolution is 15 minutes
	set clock_unit 900
	# timestamp ranges from 2018 Jan 1 GMT to 2047 Nov 27 GMT
	set clock_seconds_base [clock scan "2018 Jan 1 00:00:00 GMT" -format "%Y %b %d %T %Z"]
	set clock_seconds_max [expr {$clock_seconds_base+$clock_unit*((1<<$number_of_bits_timestamp)-1)}]
	set current_seconds [clock seconds]
	if {$current_seconds>=$clock_seconds_base && $current_seconds<=$clock_seconds_max} {
		set bitsteam_timestamp [expr {($current_seconds-$clock_seconds_base)/$clock_unit}]
		incr bitstream_identification $bitsteam_timestamp
	}
	return [format "%#010x" $bitstream_identification]
}


set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
if { (${DeviceName} == "XCKU040") || (${DeviceName} == "XCVU440") } {
	set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN {Enable} [current_design]
} else {
	set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN {Enable} [current_design]
}
set_property BITSTREAM.CONFIG.USR_ACCESS [get_haps_bitstream_identification] [current_design]
set_property BITSTREAM.GENERAL.COMPRESS {True} [current_design]
if {${PrepareReadback} == 1} {
	set_property BITSTREAM.CONFIG.PERSIST {Yes} [current_design]
	set_property CONFIG_MODE {S_SELECTMAP} [current_design]
} elseif {${PrepareReadback} == 2} {
	if {${DeviceName} != "XCVU440"} {
		# assume it is a Virtex 7 device "XC7V2000T"
		set_property BITSTREAM.CONFIG.PERSIST {Yes} [current_design]
		set_property CONFIG_MODE {S_SELECTMAP} [current_design]
	}
}	

#set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]
###################################################
###			Write last checkpoint				###
###################################################
write_checkpoint -force ${DesignName}.dcp

#################################################
###     GENERATE REPORTS     ###
#################################################
report_utilization -file area.txt
report_utilization -slr -file slr.txt
report_timing_summary -setup -nworst 3 -max_paths 3 -file ${DesignName}_timing_summary.txt
report_timing_summary -hold  -nworst 3 -max_paths 3 -file ${DesignName}_timing_summary_Min.txt
report_clock_utilization -verbose -file clock_utilization.txt
report_io -file pinloc.txt
report_drc -file post_route_drc.txt
report_clock_interaction -file ${DesignName}_clock_interaction.rpt

if {[catch {report_haps_pdelay -pdelay_info ${pdelay_info_tcl} -pdelay_reports ${pdelay_reports}} err]} {
	puts "WARNING: error during generating pdelay reports: $err"
}

#############################################################
###           GENERATE IO REG REPORT                      ###
#############################################################
if {[lsearch [tclapp::list_apps] xilinx::ultrafast] == -1} {
	if [catch {tclapp::install ultrafast} err] {
		puts "WARNING: Could not install ultrafast: $err"
	}
}
if [catch {xilinx::ultrafast::report_io_reg -file ${DesignName}_io_reg.rpt} err] {
	puts "WARNING: Could not create ${DesignName}_io_reg.rpt: $err"
}

#############################################################
###           GENERATE XDC and DLY FILES                  ###
# For Backannotation, use import_dcp.dly/xdc passed by UI ###
#############################################################

#set_property is_loc_fixed 1 [get_cells *]
write_xdc -no_fixed_only -constraints valid -exclude_timing -force ${XdcOutputFile}
compress_output_file ${XdcOutputFile}
write_sdf -force -mode sta -quiet ${DlyOutputFile}
compress_output_file ${DlyOutputFile}

if { ${write_post_par_verilog} == 1 || ${VerdiMode} == 1 } {
	write_verilog -force ${DesignName}_post_par.vm
}

#################################################
###     SAVE VIVADO PROJECT     ###
#################################################
save_project_as -force ${DesignName}
save_constraints_as ${DesignName}_vivado

#################################################
###     GENERATE BITSTREAM     ###
#################################################
# proc to generate logic location file for XCVU440 that is used by readback
proc write_readback_logic_location_file {filename} {
	set fp [open $filename w]
	array set validTil [list BRAM 1 CLEL_L 1 CLEL_R 1 CLE_M 1 CLE_M_R 1]
	foreach {pattern lut} {PRIMITIVE_GROUP==REGISTER 0 PRIMITIVE_GROUP==BLOCKRAM 0 PRIMITIVE_TYPE=~CLB.LUTRAM.* 1 PRIMITIVE_TYPE=~CLB.SRL.* 1} {
		if {$lut==1} {
			continue
		}
		foreach c [get_cells -hier -filter $pattern] {
			set bel [get_property BEL $c]
			set loc [get_property LOC $c]
			if {![regexp {^([A-Z_]+)_X([0-9]+)Y([0-9]+)} [get_tiles -of_objects $loc] tmp til x y]} {
				continue
			}
			set bel_e [lindex [split $bel .] 1]
			if {![info exists validTil($til)]} {
				continue
			}
			if {$lut==1} {
				if {![regexp {^([A-H])[1-6]LUT} $bel_e tmp l]} {
					continue
				}
				set bel_e LUT$l
			}
			
			puts -nonewline $fp "$til $x $y $bel_e $c"
			if {$til=="BRAM"} {
				puts $fp " $loc"
			} else {
			puts $fp ""
			}
		}
	}
	close $fp
}


if {${write_bitstream_enable} == 1} {
	### Xilinx recommends to turn off multi-threading for write_bitstream 
	if {[regexp {^2016\.[123].*} [version -short]]} {
		set_param bitgen.maxThreads 1 
	}
	

	if { (${DeviceName} == "XCVU440") } {
		write_readback_logic_location_file ${DesignName}.ll
		write_bitstream -force ${DesignName}.bit
	} else {
		write_bitstream -logic_location_file -force ${DesignName}.bit
	}

}

