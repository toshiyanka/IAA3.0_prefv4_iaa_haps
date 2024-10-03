proc iso_bind {} {

    set value(one)  1
    set value(zero) 0

    foreach power_domain [query_power_domain *] {

        puts " power domain: $power_domain"
    #   puts " power domain $power_domain detail: [query_power_domain $power_domain -detailed]"

        foreach isolation [query_isolation * -domain $power_domain] {

            puts "    isolation: $isolation"
            set isolation_strategy @$power_domain.isolation.$isolation
            array unset isolation_detail
            array   set isolation_detail [query_isolation $isolation -domain $power_domain -detailed]
        #   foreach isolation_detail_key [array names isolation_detail] {
        #       puts "    isolation $isolation_detail_key: $isolation_detail($isolation_detail_key)"
        #   }

            set PARAMETERS {}
            set ports      {}
            lappend PARAMETERS [list ISOLATION_STRATEGY_NAME $isolation_strategy]
            lappend PARAMETERS [list ISOLATION_SENSE         $isolation_detail(isolation_sense)]
            lappend PARAMETERS [list ISOLATION_CLAMP  $value($isolation_detail(clamp_value))]
            lappend PARAMETERS [list ISOLATION_POWER_NAME    $isolation_detail(isolation_power_net)]
            lappend PARAMETERS [list ISOLATION_CONTROL_NAME  $isolation_detail(isolation_signal)]
            lappend PARAMETERS [list ISOLATION_INPUT_NAME    UPF_GENERIC_DATA]
            lappend PARAMETERS [list ISOLATION_OUTPUT_NAME   UPF_GENERIC_OUTPUT]
            lappend ports      [list isolation_power         $isolation_detail(isolation_power_net)]
            lappend ports      [list isolation_control       $isolation_detail(isolation_signal)]
            lappend ports      [list isolation_input         UPF_GENERIC_DATA]
            lappend ports      [list isolation_output        UPF_GENERIC_OUTPUT]
            puts "       parameters: $PARAMETERS"
            puts "       ports:      $ports"

            bind_checker bind_iso_checker -module iso_checker -elements $isolation_strategy -parameters $PARAMETERS -ports $ports

        }

    }

}

iso_bind

