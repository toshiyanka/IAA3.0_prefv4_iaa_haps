package PowerGatingCommonPkg;


	`include "ovm_macros.svh"
	`include "sla_macros.svh"
	import ovm_pkg::*;
	import sla_pkg::*;
	import PowerGatingParamsPkg::*;

	typedef class PowerGatingSIPFSM;
	`include "PowerGatingCommonDefines.svh"
	`include "PowerGating.svh"
	`include "PowerGatingSIPFabricConfig.svh"
	`include "PowerGatingConfig.svh"
	`include "PowerGatingParamConfig.svh"
	`include "PowerGatingFabricState.svh"
	//`include "PowerGatingSIPState.svh"	
	`include "PowerGatingSeqItem.svh"
	`include "PowerGatingMonitorSeqItem.svh"
	`include "PowerGatingBaseFSM.svh"
	`include "PowerGatingFabricFSM.svh"	
	`include "PowerGatingSIPFSM.svh"
	//col change
	`include "PowerGatingFabricFSM_Col.svh"	
	`include "PowerGatingSIPFSM_Col.svh"
	`include "PowerGatingMonitor_Col.svh"
	//END col change
	`include "PowerGatingMainSIPFSM.svh"		
	`include "PowerGatingMonitor.svh"
	`include "PowerGatingPrinter.svh"
	`include "PowerGatingBaseAgent.svh"
	`include "PowerGatingBaseDriver.svh"

endpackage: PowerGatingCommonPkg
