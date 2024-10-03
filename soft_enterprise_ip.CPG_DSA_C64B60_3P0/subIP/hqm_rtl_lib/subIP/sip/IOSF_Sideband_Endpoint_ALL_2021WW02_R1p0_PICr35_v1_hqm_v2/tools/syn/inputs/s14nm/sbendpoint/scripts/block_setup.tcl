setvar G_VT_TYPE(default) rvt_lvt
setvar G_LVT_PERCENT 15
enable_debug_msg

set G_DESIGN_NAME        "sbendpoint"
#set G_LIBRARY_TYPE       $::env(SIP_LIBRARY_TYPE)
set G_SCAN_REPLACE_FLOPS 1
set G_INSERT_SCAN        1
set G_LBIST_ENABLE       0
set G_ENABLE_UNIQUIFIED  0
set G_COMPILE_OPTIONS    "-no_seq_output_inversion -no_autoungroup"
set G_OPTIMIZE_FLOPS     1
set G_NUM_CPUS           2
set G_DFT_TESTMODE_PORTS "fscan_shiften"
set G_DFX_TESTMODE_PORTS "fscan_clkungate_syn"
set G_VT_TYPE(default)   $::env(SIP_LIBRARY_VTYPE)
#set G_PROCESS_NAME       $::env(SIP_PROCESS_NAME)
set G_DOT_PROCESS        $::env(SIP_DOT_PROCESS)
set G_TRACK_TAG          $::env(SIP_TRACK_TAG)

set G_LIB_VOLTAGE        $env(SIP_LIBRARY_VOLTAGE)

set G_SKIP "saif"
set G_IGNORE_DFX_HANDLER_VAR 1
set G_UPF         1
set G_UPF_FILE    $env(IP_ROOT)/tools/upf/sbendpoint/sbendpoint.upf

set G_FLOW_STAGES(syn) [lminus $G_FLOW_STAGES(syn) uniquify]

set G_USE_NATIVE_UPF 0
#if {${G_LIBRARY_TYPE} == "e05"} {
#   set G_STDCELL_DIRS /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt
#   set env(WARD) $::env(IP_ROOT)/tools/syn/syn_1274/$G_DESIGN_NAME
#    set env(block) $G_DESIGN_NAME
#}

# scale factor for library to convert undimensioned constraints, 
# implicitly defined in ns, to library units.
set G_NS 1000

# ns period of the side_clk and agent_clk inputs to the endpoint
set EP_SIDE_CLK_PERIOD  3.33
set EP_AGENT_CLK_PERIOD 3.33

# Guardband (reduce) clock period by this ratio
# i.e. real period = target period * EP_CLK_GUARDBAND
set EP_CLK_GUARDBAND 0.80

# 0.1ns clock transition
set EP_CLK_TRANS [expr 0.1 * $G_NS]

# 5% period for clock uncertainty
set EP_CLK_UNCER_RATIO 0.05

# input|output delay as ratio of clock period
set EP_INPUT_DELAY   0.35
set EP_OUTPUT_DELAY  0.35
set EP_RELAXED_DELAY 0.05
set EP_STRAP_DELAY   0.35

set  G_INSERT_CLOCK_GATING 1
#if {${G_LIBRARY_TYPE} == "d04"} {
#   set G_MAX_ROUTING_LAYER "m8"
#   set G_MIN_ROUTING_LAYER "m0"
#}
set G_VISA_APPLY_CLOCK_STAMPING 1
#set G_CLOCK_GATING_CELL d04cgc01wd0i0
set G_LOGSCAN_RULES ""
#DANA - just so I can verify FV is passing - need to remove and debug before release
 setvar G_SCAN_QUALITY_WAIVER(2) "Not applicable for SIP" 

# FIXME -- workaround for kit 14.2.2
#setvar G_STDCELL_DIRS /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/
#set G_STDCELL_DIRS /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/
#set G_STDCELL_DIR /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/

# Vishnu: EP GLS require modules to be uniquified. These steps are only for
# GLS runs. All other synthesis runs should not use this

#set G_FLOW_STAGES(syn) [lminus $G_FLOW_STAGES(syn) uniquify]
#set G_ENABLE_UNIQUIFIED  1
#set G_PREPEND_UNIQUIFY  1
#regsub -all "syn_final" $G_FLOW_STAGES(syn)  "uniquify syn_final" G_FLOW_STAGES(syn)


# NOMAN - ONLY NEEDED FOR FEBE
#if {${G_LIBRARY_TYPE} == "d04"} {
#set CTECH_TYPE "d04"
#set CTECH_VARIANT "ln"
#}
###RDT Bug 
#source /p/hdk/cad/rdt/rdt_14.4.1/scripts/library_setup.tcl
#source /p/hdk/cad/kits_p1273/p1273_14.4.1/flows/rdt/common/scripts/library_d04.tcl
#if {${G_LIBRARY_TYPE} == "d04"} {
#   set compile_ultra_ungroup_dw false
#}

setvar G_PRESERVE_ADDITIONAL_LINK_LIBRARIES "1"
setvar G_SYN_REPORTS(syn_final) "[lminus $G_SYN_REPORTS(syn_final) unloaded_reg]"
lappend G_SYN_REPORTS(import_design) "rtllist"

