
# --- List of set_port_attributes for the hqm_sip ports


if {![info exists ::__IP_SRSN_DISABLE] || ([info exists ::__IP_SRSN_DISABLE] && !$::__IP_SRSN_DISABLE)} {

  set_port_attributes -receiver_supply ss_vcccfn       -ports [find_objects . -regexp -pattern {[a-qt-z].*}          -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn       -ports [find_objects . -regexp -pattern {[a-qt-z].*}          -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn       -ports [find_objects . -regexp -pattern {r[et].*}             -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn       -ports [find_objects . -regexp -pattern {r[et].*}             -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn       -ports [find_objects . -regexp -pattern {s[a-qs-z].*}         -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn       -ports [find_objects . -regexp -pattern {s[a-qs-z].*}         -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_[ipt].*}          -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_[ipt].*}          -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_mst.*}            -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_mst.*}            -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_ri.*}             -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_ri.*}             -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_scrbd.*}          -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn       -ports [find_objects . -regexp -pattern {rf_scrbd.*}          -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_msi.*}            -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_msi.*}            -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_[a-hj-lnoqu-z].*} -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_[a-hj-lnoqu-z].*} -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_r[a-hj-z].*}      -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_r[a-hj-z].*}      -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_sch.*}            -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_sch.*}            -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_s[en].*}          -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn_gated -ports [find_objects . -regexp -pattern {rf_s[en].*}          -object_type port -direction in]
  set_port_attributes -receiver_supply ss_vcccfn_gated -ports [find_objects . -regexp -pattern {sr_.*}               -object_type port -direction out] 
  set_port_attributes -driver_supply   ss_vcccfn_gated -ports [find_objects . -regexp -pattern {sr_.*}               -object_type port -direction in]

}

