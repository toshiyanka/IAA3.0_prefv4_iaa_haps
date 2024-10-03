set vol_map(HS) 0.765
set vol_map(HT) 0.850
set vol_map(HF) 0.935

set vol_map(MS) 0.675
set vol_map(MT) 0.750
set vol_map(MF) 0.825

set vol_map(LS) 0.585
set vol_map(LT) 0.650
set vol_map(LF) 0.715

if {[info exists scenario]} {
  set scen_name $scenario
} elseif {$synopsys_program_name == "icc2_shell"} {
  set scen_name [get_object_name [current_scenario]]
} else {
  set scen_name [current_scenario]
}

puts "Working on Scenario: $scen_name"

set mode_name [lindex [split $scen_name "."] 0]
set vc_name   [lindex [split $scen_name "."] 1]
set oc_name   [lindex [split $scen_name "."] 2]

regexp {(.)(.)(.)$} $vc_name match bis mss sram
regexp {^(.)_} $oc_name match oc

if {$oc_name == "F_85"} {
  set vol_map(MF) 0.750
}

set gnd_net ""
set pwr_net ""

if { $synopsys_program_name == "dc_shell" || $synopsys_program_name == "icc2_shell"} {
    foreach_in_collection power_net [get_supply_nets] {
        redirect -variable rep {report_supply_net $power_net}
        if {[regexp "GND|vss|VSS" $rep]} {
            if {[regexp "Power Domain.*\\\*" $rep]} {
                set gnd_net [get_object_name $power_net]
            }
        } else {
            if {[regexp "Power Domain.*\\\*" $rep]} {
                set pwr_net [get_object_name $power_net]
            }
        }
    }
}

if { $synopsys_program_name == "pt_shell" } {
    redirect -variable rep {report_supply_net}
    set lines [split $rep "\n"]
    foreach line $lines {
        if {[regexp "Supply Net\\\s\+:\\\s\+(\\\S\+)" $line -> supply_name]} {
            puts "Foudn supply: $supply_name"
        }
        if {[regexp "primary_power\\\s\+:\\\s\+yes" $line]} {
            set pwr_net $supply_name
        }
        if {[regexp "primary_ground\\\s\+:\\\s\+yes" $line]} {
            set gnd_net $supply_name
        }
    }
}

puts "Setting voltage as $vol_map(${mss}${oc})"
set_voltage $vol_map(${mss}${oc})  -object_list $pwr_net
set_voltage 0.0                    -object_list $gnd_net

if {$synopsys_program_name == "pt_shell"} {
  puts "Reporting voltages for each supply net"
  puts [string repeat "-" 80]
  foreach_in_collection net [get_supply_nets] {
    puts "Found voltage [get_attribute $net voltage_max] for supply net [get_object_name $net]"
  }
  puts [string repeat "-" 80]
}

