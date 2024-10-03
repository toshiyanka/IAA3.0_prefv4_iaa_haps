
# --- List of set_port_attributes for the hqm ports

if {![info exists ::__IP_SRSN_DISABLE] || ([info exists ::__IP_SRSN_DISABLE] && !$::__IP_SRSN_DISABLE)} {

  set_port_attributes -receiver_supply ss_vcccfn -ports [find_objects . -pattern * -object_type port -direction out]
  set_port_attributes -driver_supply   ss_vcccfn -ports [find_objects . -pattern * -object_type port -direction in]

}

