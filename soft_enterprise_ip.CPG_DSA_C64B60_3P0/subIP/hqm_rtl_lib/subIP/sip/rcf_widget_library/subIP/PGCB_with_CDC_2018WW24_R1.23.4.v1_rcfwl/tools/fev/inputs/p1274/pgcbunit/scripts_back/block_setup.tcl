# design information
set CTECH_TYPE ec0
set CTECH_VARIANT ln

set G_REF_UPF_LIST ""
set G_TAR_UPF_LIST ""
set G_COMPARE_POWER_INTENT 0
set G_COMPARE_POWER_GRID 0
set G_COMPARE_PST 0
set G_COMPARE_POWER_CONSISTENCY 0

# flow configurations
set G_CONF_MAP 1
set G_CONF_COMPARE_TYPE "WRITE_HIER"
set G_CONF_DYNAMIC_HIER 1
#vpx set flatten model -latch_fold
#vpx set flatten model -latch_fold_master
#vpx set flatten model -gated_clock
#vpx set flatten model -seq_redundant
#vpx set flatten model -seq_constant
#vpx set flatten model -latch_transparent
#vpx set flatten model -seq_merge
#vpx set flatten model -nodff_to_dlat_zero
#vpx set flatten model -nodff_to_dlat_feedback
#vpx set flatten model -seq_constant_feedback
#vpx set flatten model -balanced_modeling
#vpx set flatten model -seq_constant_x_to
lappend G_CONF_VALID_MODEL "LATCH_Fold"
lappend G_CONF_VALID_MODEL "SEQ_Constant"
lappend G_CONF_VALID_MODEL "GATED_Clock"
lappend G_CONF_VALID_MODEL "seq_constant_feedback"
lappend G_CONF_VALID_MODEL "balanced_modeling"
lappend G_CONF_VALID_MODEL "SEQ_CONSTANT_X_TO 0"
lappend G_CONF_VALID_MODEL "LATCH_Transparent"
lappend G_CONF_VALID_MODEL "nodff_to_dlat_zero"
lappend G_CONF_VALID_MODEL "nodff_to_dlat_feedback"
lappend G_CONF_VALID_MODEL "nomap"
#lappend G_CONF_VALID_MODEL "seq_redundant"
#lappend G_CONF_VALID_MODEL "seq_merge"


## set  G_STDCELL_DIRS "/p/hdk/cad/stdcells/e05/14ww37.3_e05_c.0.p1_cnlgt"


#lnew1: Default will read the ctech's .lib. will cause fv failure
#set SIPFEV_READ_V 1
#lnew1: Guard for UPF retention/isol cell mapping
set SIP_SD 1

#Suhas: Default is to 0 (netlist read only)
set G_READ_LIB_BOTH 1
#Enable data path analysis
#set G_CONF_DP 1

#if RTL defines  used: set G_REF_DEFINES_LIST ""
set G_REF_READ_OPTIONS "-systemVerilog -noelaborate -Gol"

# lnew1: Should RTL undriven be set to 0?
# remove this due to conflicting ZirconQA rule 7.101.a
#set G_CONF_RTL_UNDRIVEN_SIGNAL_0 1
#set G_CONF_GATE_UNDRIVEN_SIGNAL_0 0

set G_CONF_RTL_UNDEFINED_BBOX 1
set G_CONF_GATE_UNDEFINED_BBOX 1
set G_CONF_GATE_CLOCK 1
set G_CONF_NOTRANSLATE

# MAPPING Phase
# lnew1 change the fv algo - MY
set G_CONF_NAME_MAP_TYPE "NAME_FIRST"
# lnew1 to workaround non-equivalent latch inversion mapping
set G_CONF_PHASE_MAP 1
#set G_CONF_PHASE_MAP 0
set G_CONF_MAP_UNREACH 1
set G_CONF_NO_BBOX_NAME_MATCH 1

# lnew1
set G_CONF_MANUAL_MAP_POINTS 1
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

set G_FV_LP 0
set G_REF_LP_TYPE "logical"
set G_TAR_LP_TYPE "logical"
set G_REF_UPF_1801 1
set G_TAR_UPF_1801 1

##Non-HDK setup##
