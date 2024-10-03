
proc @@ {args} {}
proc @@@ {args} {}

array set module_instances {
  visa_unit_mux_s {
    unit_mux0
    unit_mux1
  }
}

array set module_stable_ports {
  visa_unit_mux_s {
    reg_start_index
    customer_disable
    fscan_mode
    visa_enabled
    visa_resetb
    all_disable
    visa_unit_id
  }
}

array set instance_lanes {
  unit_mux0 {8 1 1}
  unit_mux1 {8 2 1}
}

array set instance_visa2 {
  unit_mux0 1
  unit_mux1 1
}

array set instance_clock_domains {
  unit_mux0 {
    0 {{0 0}}
  }
  unit_mux1 {
    0 {{1 0}}
  }
}

# Iterate over all instantiated module types
foreach {MODULE instances} [array get module_instances] {

  # Iterate over all instances of each module
  foreach INSTANCE $instances {

    foreach {lwidth outs xbar} $instance_lanes($INSTANCE) {}
    set llb [expr $lwidth - 1]

    @@@ CDC directives for instance $INSTANCE

    @@ Common properties
    hier block -user_specified $MODULE -instance $INSTANCE

    @@ Output lanes and clocks
    hier clock ss_clk_out -group VISA_SSCLK_GROUP -module $MODULE -instance $INSTANCE
    for { set olane 0 } { $olane < $outs } { incr olane } {
       hier port domain "lane_out\[$olane\]" -clock "ss_clk_out\[$olane\]" -module $MODULE -instance $INSTANCE
    }

    if { $xbar > 0 } {
       @@ Xbar lanes and clocks
       hier clock xbar_ss_clk_out -group VISA_SSCLK_GROUP -module $MODULE -instance $INSTANCE
       for { set xlane 0 } { $xlane < $xbar } { incr xlane } {
          hier port domain "xbar_out\[$xlane\]" -clock "xbar_ss_clk_out\[$xlane\]" -module $MODULE -instance $INSTANCE
       }
    }

    if { $instance_visa2($INSTANCE) } {
      @@ Serial configuration
      foreach dir {in out} {
        hier clock "serial_cfg_${dir}\[0\]" -group VISACFGCLK_GROUP -module $MODULE -instance $INSTANCE
        hier port domain "serial_cfg_${dir}\[2:1\]" -clock "serial_cfg_${dir}\[0\]" -module $MODULE -instance $INSTANCE
      }
    }

    @@ Stable ports
    foreach PORT $module_stable_ports($MODULE) {
      hier stable $PORT -module $MODULE -instance $INSTANCE
    }

    @@ Input clocks
    foreach {clk ranges} $instance_clock_domains($INSTANCE) {
      hier clock "src_clk\[$clk\]" -module $MODULE -instance $INSTANCE
    }

    @@ Input lane to input clock affiliations
    foreach {clk ranges} $instance_clock_domains($INSTANCE) {
      foreach rng $ranges {
        hier port domain "lane_in\[[join $rng :]\]\[$llb:0\]" -clock "src_clk\[$clk\]" -module $MODULE -instance $INSTANCE
      }
    }
  }
}

