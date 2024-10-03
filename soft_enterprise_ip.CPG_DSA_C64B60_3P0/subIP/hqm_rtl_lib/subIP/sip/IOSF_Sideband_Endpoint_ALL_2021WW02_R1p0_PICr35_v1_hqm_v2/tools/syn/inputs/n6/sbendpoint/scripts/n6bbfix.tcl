define_name_rules standard_names \
    -allowed "A-Za-z0-9_/\[\]\." \
    -first_restricted "0-9_" \
    -equal_ports_nets \
    -last_restricted "_" \
    -target_bus_naming_style "%s\[%d\]" \
    -add_dummy_nets \
    -max_length 400 \
    -case_insensitive \
    -collapse_name_space \
    -preserve_struct_ports \
    -dont_change_ports \
    -dont_change_bus_members

  define_name_rules standard_netnames \
    -allowed "A-Za-z0-9_/\[\]\." \
    -first_restricted "0-9_" \
    -equal_ports_nets \
    -last_restricted "_" \
    -target_bus_naming_style "%s\[%d\]" \
    -add_dummy_nets \
    -type net \
    -preserve_struct_ports \
    -dont_change_ports \
    -dont_change_bus_members

  define_name_rules reg_names \
    -type cell \
    -map {{{"\]", ""}, {"\[", "_"}}} \
    -dont_change_bus_members
  

report_name_rules > $SEV(rpt_dir)/dc.report_name_rules

change_names -rules standard_names  -hierarchy -log_changes $PRE_RPT(basename).change_names
change_names -rules standard_netnames  -hierarchy -log_changes $PRE_RPT(basename).change_names
change_names -rules reg_names  -hierarchy -log_changes $PRE_RPT(basename).change_names


