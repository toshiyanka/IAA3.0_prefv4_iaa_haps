####################################################################################################
# Hier-CDC Constraints
# Questa CDC Version 10.4f_5 linux_x86_64 26 May 2017
# Created: Mon Mar 12 17:53:38 2018
####################################################################################################

# INPUT PORTS

# hier constant { fdfx_earlyboot_exit } 1'b1 -module { dfxsecure_plugin }
# hier clock { fdfx_policy_update }  -group { DFXSECUREPLUGIN_GROUP } -module { dfxsecure_plugin }
# hier stable { fdfx_powergood } -module { dfxsecure_plugin }
# hier port domain { fdfx_secure_policy } -ignore -module { dfxsecure_plugin }
# hier stable { oem_secure_policy } -module { dfxsecure_plugin }
# hier constant { sb_policy_ovr_value } 3'b000 -module { dfxsecure_plugin }


# OUTPUT PORTS

# hier stable { dfxsecure_feature_en } -module { dfxsecure_plugin }
# hier stable { visa_all_dis } -module { dfxsecure_plugin }
# hier stable { visa_customer_dis } -module { dfxsecure_plugin }


####################################################################################################
# Hier-CDC Constraints
# Questa CDC Version 10.4f_5 linux_x86_64 26 May 2017
# Created: Mon Jul 23 11:47:23 2018
####################################################################################################

# INPUT PORTS

# hier constant { fdfx_earlyboot_exit } 1'b1 -module { dfxsecure_plugin }
# hier clock { fdfx_policy_update }  -group { DFXSECUREPLUGIN_GROUP } -module { dfxsecure_plugin }
# hier stable { fdfx_powergood } -module { dfxsecure_plugin }
# hier port domain { fdfx_secure_policy } -ignore -module { dfxsecure_plugin }
# hier stable { oem_secure_policy } -module { dfxsecure_plugin }
# hier constant { sb_policy_ovr_value } 3'b000 -module { dfxsecure_plugin }


# OUTPUT PORTS

# hier stable { dfxsecure_feature_en } -module { dfxsecure_plugin }
# hier stable { visa_all_dis } -module { dfxsecure_plugin }
# hier stable { visa_customer_dis } -module { dfxsecure_plugin }


cdc preference reconvergence -depth 2
cdc preference -detect_pure_latch_clock
cdc preference -filtered_report
netlist clock -group DFXSECUREPLUGIN_GROUP fdfx_policy_update 

netlist constant fdfx_earlyboot_exit 1'b1 -module rcfwl_dfxsecure_plugin 

cdc signal oem_secure_policy -stable -module rcfwl_dfxsecure_plugin 

netlist constant sb_policy_ovr_value 1'b0 -module rcfwl_dfxsecure_plugin 

cdc signal dfxsecure_feature_lch -stable -module rcfwl_dfxsecure_plugin 

cdc signal fdfx_powergood -stable -module rcfwl_dfxsecure_plugin

