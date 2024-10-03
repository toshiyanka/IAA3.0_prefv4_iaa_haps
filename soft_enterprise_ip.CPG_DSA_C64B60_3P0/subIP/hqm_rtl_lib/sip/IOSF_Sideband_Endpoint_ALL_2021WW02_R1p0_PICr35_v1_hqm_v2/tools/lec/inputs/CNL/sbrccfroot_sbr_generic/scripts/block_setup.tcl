# design information
set G_REF_DESIGN_NAME sbrccfroot_sbr_generic
set G_TAR_DESIGN_NAME sbrccfroot_sbr_generic

# flow configurations
set G_CONF_MAP 1
#set G_CONF_COMPARE_TYPE "FLAT"
set G_CONF_COMPARE_TYPE "HIER"
#set flatten Model options 
lappend G_CONF_VALID_MODEL "latch_fold"
lappend G_CONF_VALID_MODEL "seq_constant"
lappend G_CONF_VALID_MODEL "GATED_Clock"
lappend G_CONF_VALID_MODEL "seq_constant_feedback"
lappend G_CONF_VALID_MODEL "balanced_modeling"
lappend G_CONF_VALID_MODEL "seq_constant_x_to 0"
lappend G_CONF_VALID_MODEL "LATCH_Transparent"
lappend G_CONF_VALID_MODEL "nodff_to_dlat_zero"
lappend G_CONF_VALID_MODEL "nodff_to_dlat_feedback"

# READ REF VERILOG & TAR or NETLIST
# source "$env(WARD)/fev/scripts/rtl_list_lec.tcl"
# these information should be automaticall generated
#set G_TAR_GATE_LIST "$env(WARD)/syn/GLK/gmm_ip_top/outputs/gmm_ip_top.syn_final.vg"
# febe will automatically pick up 
# set G_TAR_VERILOG_LIST "$env(WARD)/syn/outputs/gmm_ip_top.syn_final.vg"

#if RTL defines  used: set G_REF_DEFINES_LIST ""
set G_REF_READ_OPTIONS "-systemVerilog -noelaborate -Gol"
# remove this due to conflicting ZirconQA rule 7.101.a
#set G_CONF_RTL_UNDRIVEN_SIGNAL_0 1
set G_CONF_RTL_UNDEFINED_BBOX 1
set G_CONF_GATE_UNDEFINED_BBOX 1
set G_CONF_GATE_CLOCK 1
set G_CONF_NOTRANSLATE 
#set G_CONF_GATE_UNDRIVEN_SIGNAL_0 $G_CONF_RTL_UNDRIVEN_SIGNAL_0

# MAPPING Phase
# set G_CONF_NAME_MAP_TYPE "NAME_FIRST"
set G_CONF_PHASE_MAP 0
set G_CONF_MAP_UNREACH 0
# turn on if DC resoure file is used
#set G_CONF_DC_RESOURCE_FILE <path>
set G_CONF_DP 0
set G_CONF_ANALYZE_OPTION "AUTO"
set G_CONF_ANALYZE_SETUP 1
set G_CONF_ANALYZE_ABORT 1
set G_CONF_COMPARE_THREADS 4

vpx set rule handling HRC3.3 -Warning
vpx set rule handling RTL19.3 -Warning
vpx set compare option -allgenlatch

set G_MULTI_DIM_TO_1DIM 1

# create check point at every stage
set G_CONF_STOP_CHECKPOINT $G_FLOW_STAGES(fev)

# to bypass zirconQA check
rdt_source_if_exists /p/sip/syn/scripts/FEV/rdt_fev/sip_setup.tcl
rdt_print_info "Sourcing /p/sip/syn/scripts/FEV/rdt_fev/sip_setup.tcl"

# added on 24/12/14
set G_READ_LIB_BOTH 1
set G_CONF_COMPARE_TYPE "WRITE_HIER"
set G_CONF_DYNAMIC_HIER 1

set G_FV_LP 0
#set G_REF_UPF_LIST "$env(WARD)/syn/inputs/gmm_ip_top.upf"
#set G_TAR_UPF_LIST "$env(WARD)/syn/outputs/gmm_ip_top.syn_final.upf"
set G_REF_LP_TYPE "logical"
set G_TAR_LP_TYPE "logical"
set G_REF_UPF_1801 0
set G_TAR_UPF_1801 0
set G_CONF_COMPARE_TYPE "WRITE_HIER"
set G_CONF_DYNAMIC_HIER 0
set G_CONF_DC_RESOURCE_FILE "$env(WARD)/syn/reports/sbrccfroot_sbr_generic.syn_final.resources" 
set G_CONF_DP 1

set G_STDCELL_DIRS "/p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt"
#set G_STDCELL_DIR "/p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt"

setvar G_LOGSCAN_RULE ""
