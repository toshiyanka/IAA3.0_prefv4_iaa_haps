# design information
set G_REF_DESIGN_NAME sbendpoint
set G_TAR_DESIGN_NAME sbendpoint

set G_CONF_MAP 1
set G_CONF_VALID_MODEL ""
lappend G_CONF_VALID_MODEL "latch_fold"
lappend G_CONF_VALID_MODEL "seq_constant"
lappend G_CONF_VALID_MODEL "GATED_clock"
lappend G_CONF_VALID_MODEL "seq_constant_feedback"
lappend G_CONF_VALID_MODEL "balanced_modeling"
lappend G_CONF_VALID_MODEL "seq_constant_x_to 0"
lappend G_CONF_VALID_MODEL "LATCH_Transparent"
lappend G_CONF_VALID_MODEL "nodff_to_dlat_zero"
lappend G_CONF_VALID_MODEL "nodff_to_dlat_feedback"

set G_REF_READ_OPTIONS "-systemverilog -noelaborate -gol"

#set G_CONF_RTL_UNDRIVEN_SIGNAL_0 1
set G_CONF_RTL_UNDEFINED_BBOX 1
set G_CONF_GATE_UNDEFINED_BBOX 1
set G_CONF_GATE_CLOCK 1
set G_CONF_NOTRANSLATE
#set G_CONF_GATE_UNDRIVEN_SIGNAL_0 $G_CONF_RTL_UNDRIVEN_SIGNAL_0

set G_CONF_NAME_MAP_TYPE "NAME_FIRST"
set G_CONF_PHASE_MAP 1
set G_CONF_MAP_UNREACH 0

set G_CONF_DC_RESOURCE_FILE "$env(WARD)/syn/reports/${G_DESIGN_NAME}.syn_final.resources"
set G_CONF_DP 1
set G_CONF_ANALYZE_OPTION "AUTO"
set G_CONF_ANALYZE_SETUP 1
set G_CONF_ANALYZE_ABORT 1
set G_CONF_COMPARE_THREADS 4

set G_CONF_COMPARE_TYPE "WRITE_HIER"
set G_CONF_DYNAMIC_HIER 1

set G_FV_LP 0

vpx set rule handling HRC3.3 -Warning
vpx set rule handling RTL19.3 -Warning
vpx set compare option -allgenlatch

set G_MULTI_DIM_TO_1DIM 1
#set G_CONF_STOP_CHECKPOINT $G_FLOW_STAGES(fev)

set G_LIBRARY_TYPE e05
set G_STDCELL_DIRS "/p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt"
set G_LIBRARY_TYPE e05
# setenv FEV_ERRGEN_RULES_CFG /p/sip/syn/scripts/FEV/p1274/flows/rdt/fev/cfg/custom.cfg
setenv FEV_ERRGEN_RULES_CFG $env(WARD)/fev/scripts/custom.cfg

setvar G_LOGSCAN_RULE ""

vpx set naming rule -field_delimiter \"_\" \"\" -both
