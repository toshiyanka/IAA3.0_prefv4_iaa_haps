
//- Questa CDC Version 10.4f_5 linux_x86_64 26 May 2017

//-----------------------------------------------------------------
// CDC Hierarchical Control File
// Created Mon Mar 12 17:50:47 2018
//-----------------------------------------------------------------

module dfxsecure_plugin_ctrl; // Hierarchical CDC warning: Do not change the module name

// INPUT PORTS

// 0in set_cdc_signal -stable fdfx_powergood -module dfxsecure_plugin 
// 0in set_constant fdfx_earlyboot_exit -module dfxsecure_plugin 1'b1
// 0in set_cdc_clock fdfx_policy_update -group DFXSECUREPLUGIN_GROUP -module dfxsecure_plugin
// 0in set_constant sb_policy_ovr_value -module dfxsecure_plugin 1'b0
// 0in set_cdc_signal -stable oem_secure_policy -module dfxsecure_plugin 
// Reason for -clock: Port fdfx_secure_policy has single fanout in single clock domain
// 0in set_cdc_port_domain fdfx_secure_policy -clock fdfx_policy_update -module dfxsecure_plugin 


// OUTPUT PORTS

// 0in set_cdc_signal -stable dfxsecure_feature_en -module dfxsecure_plugin 
// 0in set_cdc_signal -stable visa_all_dis -module dfxsecure_plugin 
// 0in set_cdc_signal -stable visa_customer_dis -module dfxsecure_plugin 
endmodule
