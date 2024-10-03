##############################################################################################################################################
## Integration UPF Merge Documnetation : https://wiki.ith.intel.com/display/ConnectivityIntegration/Merge+UPF
## Details on Constructs in UPF Merge: https://wiki.ith.intel.com/display/ConnectivityIntegration/Merge+UPF+Constructs+Information
## Cheetah upf_utils Documentaiton: https://wiki.ith.intel.com/display/cheetah/UPF+Utils
## Methodology Documentation : https://wiki.ith.intel.com/pages/viewpage.action?pageId=1211322382
##############################################################################################################################################

## This is a template for UPF merge config file
## The naming convention for this file should be <block/partition name>_merge_upf_config.tcl
## In Cheetah, these config files MUST be placed under $WORKAREA/integration/upf_utils/config

###### Template for <block/partition_name>_merge_upf_config.tcl

####################################################################################################
#### pre_hook and post_hook

## pre_hook {fp upf_file}
## Procedure to stick in any code at the begining of the merged output file
proc pre_hook { fp upf_file} {
  puts $fp "# These are lines from the pre-hook"
  puts $fp "# pre-hook can set variables etc"
}

## post_hook {fp upf_file}
## Procedure to stick in any code at the end of the merged output file
proc post_hook { fp upf_file} {
  puts $fp "# These are lines from the post-hook"
  puts $fp "# post-hook can be used to unset variables etc"
}

####################################################################################################

####################################################################################################
#### variables and files manipulation

## set_var "var_name1 value1 var_name2 value2" (Default: "")
## Set and override variables and values to be set in UPF context. 
set_var synopsys_program_name dc_shell

## set_env_var "var_name1 value1 var_name2 value2" (Default: "")
## Set and override Environment variables and values to be set in UPF context. 
set_env_var SOC_INTEG_ROOT absolute_soc_integ_path 

## escape_env_var {env_list}
## Allows variablization of path for if Env variable in env_list exists
escape_env_var [list "SOC_INTEG_ROOT"]

####################################################################################################

####################################################################################################
#### domains and signals manipulation

## merge_signals  "merged_name {orig_sig1 orig_sig2 ...} merged_name {orig_sig1 orig_sig2 ...} ..." (Default: "")
## Information on which signals can be merged into a new one. 
## Example below merges vss_1 and vss_2 into vss_merged
merge_signal vss_merged {vss_1 vss_2}

## merge_domains "merged_domain_name" "primary_domain" {orig_domain1 orig_domain2}
## Merge domains specified by user.Produce merged domain with given name, and has same primary characteristics as primary domain
merge_domains merged_output_name primary_domain {domain1 domain2}

## use_domain_name "given_name" {domain1 domain2}
## By default new pd name is combination of all merged domain names
use_domain_name specified_name {domain1 domain2}

## dont_merge_any_domain  
## No domain merging will happen. Only flattening of domains will happen
dont_merge_any_domain

## dont_merge_top_domain
## Top-level domain is not merged with other domains
dont_merge_top_domain

## dont_merge_domain {domain1 domain2}
## Each domain present in this list will appear as seperate domain and will not be merged with any other domain
dont_merge_domain {domain1 domain2}

## print_gated_first 
## If specified, merged-gated domains will be merged and dumped before merged-ungated domains. The top-level will always be merged and printed first
print_gated_first

## order_domains {first_domain second_domain}
## User specified order in which the domains will be printed in the merged UPF file. This list should not include the top-level domain name
order_domains {first_domain_name second_domain_name}

####################################################################################################

####################################################################################################
#### disabling insertion OR auto-insertion of mapping cells
#### IMPORTANT: auto-insertion requires upf_global_defs.tcl to be loaded, or other file that contain default cell definition

## disable_map_iso_cell_insertion
## If specified, remove all map_isolation_cell from output
disable_map_iso_cell_insertion

## disable_map_ret_cell_insertion
## If specified, remove all map_retention_cell from output
disable_map_ret_cell_insertion

## disable_auto_map_ps_cell_insertion
## If specified, disable auto insertion of missing map_power_switch
disable_auto_map_ps_cell_insertion

## disable_auto_map_iso_cell_insertion
## If specified, disable auto insertion of missing isolation cell.
disable_auto_map_iso_cell_insertion

## disable_auto_map_ret_cell_insertion
## If specified, disable auto insertion of missing retention cell.
disable_auto_map_ret_cell_insertion

####################################################################################################

####################################################################################################
#### other configs

## skip_load_upfs "file_regexp_list" (Default: "")
## All load_upfs of file that ?file_regexp? will not be descended into and will be preserved as-is with "load_upf"}
## Below: regexp is performed to determine skip loading for UPF file containing ip123 in name!
skip_load_upfs "ip123"

## skip_power_domain_elements {instance1 instance2}
## User specified list of instances for which the SRSN needs to be preserved
skip_power_domain_elements {instance1 instance2}

## Only choose 1 from use_top_pst or use_pst
## use_top_pst 
## If specified, PST printed in output merged_file will be equivalent to the top partition pst.
use_top_pst

## use_pst "pst_details"
## Collage by default prints worst-case scenario PST, this allows user to print customized PST for top-level UPF
use_pst "
add_port_state vss -state \"ps_VSS_0p0 0.0\"
add_port_state vccst -state \"ps_VCCST_LV 0.65\" -state \"ps_VCCST_HV 1.10\" -state \"ps_VCCST_OFF off\"
create_pst pst -supplies \" vccst vss\"

add_pst_state S_VCCST_OFF               -pst pst -state \"ps_VCCST_OFF	ps_VSS_0p0\"
"

## print_pd_elements_separate_lines
## If specified, print elements into multiple lines. Else print into single line
print_pd_elements_separate_lines

## print_spa_separate_lines
## If specified, print spa into multiple lines, with repeated driver_supply and receiver_supply. Else print into single braces.
print_spa_separate_lines

## preserve_srsn_for_instances "{inst1 inst2}" 
## If specified, the SRSN will be preserved for these instances from the IP UPF file
preserve_srsn_for_instances "{inst1 inst2}"

## replace_hier_seperator "user_specified_string" (Default is _ )
## User specified string that will used to replace "/" in UPF names. Defaults to "_"}
replace_hier_seperator " "

## disable_conformal_naming "value" (Default is 0)
## Value of 1 will disable the naming convention introduced for conformal Hier Vs. Flat checking.
disable_conformal_naming 1

## dont_preserve_gated_supplies "value" (Default is 0)
## Setting to 1 will not preserve the gated supply names in the merged files.
dont_preserve_gated_supplies 1

## add_hip_iso_for_domain {domain1 domain2}
## User specified domain list to add isolation strategies on HIP boundary for VCS if included in implementation UPFs
add_hip_iso_for_domain {domain1 domain2}

## use_get_ports "value" (Default is 0)
## If 1, use get_ports while specifying objects in set_related_supply_net commands.
use_get_ports 1

## split_ip_power_switch, must be used in conjuction with ip_power_switch_ctrl_ack
## If specified, All the IP power switch will be split into 2 power switches.
split_ip_power_switch

## ip_power_switch_ctrl_ack {input_PSW:control:ack}
## User specified input IP power switch name and control ack enable to be used for the 2 PS after split.
ip_power_switch_ctrl_ack {input_PSW_name:new_control_net:new_ack_net}

####################################################################################################
