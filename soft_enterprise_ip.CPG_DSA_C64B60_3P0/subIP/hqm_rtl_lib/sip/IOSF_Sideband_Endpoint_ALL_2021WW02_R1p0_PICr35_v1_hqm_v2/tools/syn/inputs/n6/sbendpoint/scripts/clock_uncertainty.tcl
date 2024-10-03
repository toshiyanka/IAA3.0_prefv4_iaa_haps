set max_delay_ratio 2
set sbe_fixed_timing_speedfix "$SEV(build_dir)/ext_inputs/fe_collateral/SBE_fixed_timing_speedfix.tcl"

set side_clk_period  [get_attribute [get_clocks side_clk]  period]
set agent_clk_period [get_attribute [get_clocks agent_clk] period]
    
set_max_delay [expr $side_clk_period  * $max_delay_ratio] -from [get_clocks agent_clk] -to [get_clocks side_clk]
set_max_delay [expr $agent_clk_period * $max_delay_ratio] -from [get_clocks side_clk]  -to [get_clocks agent_clk]

if { [file exists ${sbe_fixed_timing_speedfix}]} {
   sh rm ${sbe_fixed_timing_speedfix}
}

set doublesync_inst [get_cells * -hier -filter "ref_name=~ *doublesync*"]
foreach_in_collection i $doublesync_inst {
set inst_name [get_object_name $i]
set dpin [get_pins ${inst_name}/d]
echo [get_object_name $dpin]
set mytp [get_timing_paths -to $dpin]
  if { [sizeof_collection $mytp] > 0 } {
    echo ==>  [get_object_name $mytp ]==> [get_object_name $dpin] ==> [sizeof_collection $mytp]
    foreach_in_collection p $mytp { 
      #echo ====>  [get_object_name $p ]
      set mystartclk [get_object_name [get_attribute $p startpoint_clock]]
      set myendclk [get_object_name [get_attribute $p endpoint_clock]]
      echo ---> "start clock: $mystartclk, end clock: $myendclk"
      if { $mystartclk != "" } {
        set mystartclk_period [get_attribute [get_clocks $mystartclk] period]
        set myendclk_period [get_attribute [get_clocks $myendclk] period]
        if {$mystartclk_period < $myendclk_period} {
          set myfastclk_period $mystartclk_period
        } else {
          set myfastclk_period $myendclk_period
        }
      #  echo "set_max_delay $myfastclk_period -from \[get_clocks  $mystartclk \] -through \[get_pins [get_object_name $dpin] \] " >> ${sbe_fixed_timing_speedfix}
      }
    }
  }
}
#echo "INFO-- sourcing  ./outputs/SMD_dblsync.tcl"
#rdt_source_if_exists  ./outputs/SMD_dblsync.tcl
