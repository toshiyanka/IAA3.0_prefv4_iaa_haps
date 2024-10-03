
if {[current_design_name] != ""} {
  puts "######## Tariq W/A ####"
  set_preferred_routing_direction -layers {tm1 } -direction vertical
  set_preferred_routing_direction -layers {tm0} -direction horizontal
}


