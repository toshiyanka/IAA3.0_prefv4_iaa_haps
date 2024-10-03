tclmode
vpx analyze abort -compare -verbose
vpx report floating signals -root -undriven >> reports/dfxsecure_plugin.hier.undriven.rpt
vpx report unmapped points >> reports/dfxsecure_plugin.hier.unmapped.rpt
vpx report black box -nohidden >> reports/dfxsecure_plugin.hier.blackbox.rpt
vpx write mapped points reports/dfxsecure_plugin.hier.mapped.rpt -append
report_modules -root >> reports/dfxsecure_plugin.hier.mapped.unreach.rpt
report_mapped_points -unreach >> reports/dfxsecure_plugin.hier.mapped.unreach.rpt
vpxmode
