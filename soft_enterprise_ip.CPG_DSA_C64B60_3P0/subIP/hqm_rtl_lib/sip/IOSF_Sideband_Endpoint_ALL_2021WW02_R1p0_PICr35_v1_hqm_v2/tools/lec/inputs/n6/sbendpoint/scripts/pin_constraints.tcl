
# dhm flow test design only
if {[regexp  $SVAR(design_name) "dhm"]} {

  add_pin_constraints 0 scan_mode  -both
  add_pin_constraints 0 SCANENABLE  -both
  add_ignored_inputs SCANIN_* -both
  add_ignored_outputs SCANOUT_* -both

 if { [regexp $TEV(G_FLOW_VARIANT) "fev_r2g"] } {
  # constant 0 FF ,from svf file ,vsdc does not help
  add_instance_constraints 0 pd_state\[1\] -module dhm_sleep_logic_1 -golden
  add_instance_constraints 0 pd_state\[2\] -module dhm_sleep_logic_1 -golden
  add_instance_constraints 0 u_dhm_unit_0/u_dhm_core/clean.u_convert_8_8/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_1/u_dhm_core/clean.u_convert_8_8/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_2/u_dhm_core/clean.u_convert_8_8/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_0/u_dhm_core/u_convert_64_8/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_0/u_dhm_core/u_convert_64_8/state_reg\[2\] -golden
  add_instance_constraints 0 u_dhm_unit_1/u_dhm_core/u_convert_64_8/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_1/u_dhm_core/u_convert_64_8/state_reg\[2\] -golden
  add_instance_constraints 0 u_dhm_unit_2/u_dhm_core/u_convert_64_8/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_2/u_dhm_core/u_convert_64_8/state_reg\[2\] -golden
  add_instance_constraints 0 u_dhm_unit_0/u_dhm_core/without_ram.u_not_mem/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_1/u_dhm_core/without_ram.u_not_mem/state_reg\[1\] -golden
  add_instance_constraints 0 u_dhm_unit_2/u_dhm_core/without_ram.u_not_mem/state_reg\[1\] -golden

  for {set i 4} {$i < 64} {incr i} {
    add_instance_constraints 0  u_dhm_lut/lut_in_reg\[$i\] -golden
    add_instance_constraints 0  u_dhm_lut/lut_out_reg\[$i\] -golden
  }
 }
}


# carmel flow test design only
if {[regexp  $SVAR(design_name) "carmel"]} {
  add_pin_constraints 0 pdft_scen_i -both
  add_ignored_outputs pdft_sco_o* -both
  add_pin_constraints 0 pdft_scan_mode_i -both
  add_pin_constraints 1 pwron -both
}

