proc primary_power_off {} {
 foreach PD [query_power_domain *] {
	array set pd_detail [query_power_domain $PD -detailed]
	set PD_NAME [list PD_NAME $pd_detail(domain_name)]
	set PPN_NAME [list PPN_NAME $pd_detail(primary_power_net)]
	set PPN [list PPN $pd_detail(primary_power_net)]
	set ports_list {}
	lappend ports_list $PPN
	set params_list {}
	lappend params_list $PD_NAME $PPN_NAME

     puts "params = $params_list"
     puts "ports = $ports_list"
 foreach k [array names pd_detail] {
                puts "$k : $pd_detail($k)"
                }
        
	bind_checker i_primary_power_off \
		-module primary_power_off \
		-elements [list @$PD ] \
		-parameters $params_list \
		-ports $ports_list
	array unset pd_detail
 }
}


proc sw_output_off {} {
 foreach PSW [query_power_switch *] {
 	array set sw_detail [query_power_switch $PSW -detailed]
        set PSW_NAME [list PSW_NAME $sw_detail(switch_name)]
        set port_spec         $sw_detail(output_supply_port)
        set PSW_OUT_PORT_ST   [lindex $port_spec 1]
        set PSW_OUT_PORT_NAME [list PSW_OUT_PORT_NAME $PSW_OUT_PORT_ST]
        set PSW_OUT_PORT      [list PSW_OUT_PORT      $PSW_OUT_PORT_ST]

        set ports_list {}
        lappend ports_list $PSW_OUT_PORT

        set params_list {}
        lappend params_list $PSW_NAME $PSW_OUT_PORT_NAME

        #Bind instance i_sw_out_off of module sw_out_off to this power switch
        #In effect every power switch gets an instance of sw_out_off
        bind_checker i_sw_out_off \
                -module sw_out_off \
                -elements [list @$PSW ] \
                -parameters $params_list \
                -ports $ports_list
        array unset sw_detail
 }
}


sw_output_off

primary_power_off
