#################################################
###     SET DESIGN VARIABLES      ###
#################################################
set RUN_VIVADO_HAPS_TEMPLATE_TCL_HEADER {$Header: //synplicity/ui_dev/misc/vivado_flags_template.tcl#205 $}
puts "Script version is $RUN_VIVADO_HAPS_TEMPLATE_TCL_HEADER"
#################################################
###     SET DESIGN VARIABLES      ###
#################################################
set DesignName  	"mb1_uD"
set FamilyName  	"VIRTEX UltraScale FPGAs"
set DeviceName  	"XCVU440"
set PackageName 	"FLGA2892"
set SpeedGrade  	"-1-c"
set TopModule   	"mb1_uD"
set PartName    	"XCVU440-FLGA2892-1-c"
set DcpFile			""
set VivadoOptionFiles ""
set InputMode   	"EDIF"
set Flow   			"Standard" ;# Flow can be set to "Incremental" or "Standard"
set StrategyMode	"custom"
set ProductType		"protocompiler";
set PrepareReadback "1"
set VerdiMode       "0"
set VivadoPostLinkOptionFiles "$env(WORKAREA)/verif/fpga/haps/vivado/par_options_mb1_uD.tcl"
set EnablePARFFFlow	""
set FastTaTMode		"";
set DisableSLLTDM               ""

