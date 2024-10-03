// Load top level IP RTL

set sv_args "-force -ignore_synthesis_off_sections On -vcs_compatibility -mfcu -no_duplicate_modules_warnings -verbose -format sv2009"

set_design_include_directories $env(IP_ROOT)/source/rtl/include

if {$sv_mode} {
   read_verilog $env(IP_ROOT)/source/rtl/ip_top.sv  $sv_args
} else {
   read_verilog $env(IP_ROOT)/source/rtl/ip_top.sv
}

