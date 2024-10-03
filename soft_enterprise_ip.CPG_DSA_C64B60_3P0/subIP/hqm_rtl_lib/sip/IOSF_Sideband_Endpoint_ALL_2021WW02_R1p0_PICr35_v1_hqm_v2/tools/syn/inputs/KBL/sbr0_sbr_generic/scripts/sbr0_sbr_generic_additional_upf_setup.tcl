if {${G_UPF} == "1"} {
   set_voltage -object_list "vss"                               0.0
   set_voltage -object_list "vccprim_core"                      $::env(SIP_LIBRARY_VOLTAGE)
   set_voltage -object_list "vccprim_core_gated_sbr0" $::env(SIP_LIBRARY_VOLTAGE)
}
