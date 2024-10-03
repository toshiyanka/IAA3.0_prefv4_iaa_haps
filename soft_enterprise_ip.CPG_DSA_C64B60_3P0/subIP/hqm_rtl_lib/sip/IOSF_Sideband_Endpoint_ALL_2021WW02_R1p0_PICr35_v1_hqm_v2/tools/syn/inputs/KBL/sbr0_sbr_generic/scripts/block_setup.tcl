## The source of this file unsupported/export/data/xml
## It is then replicated by dynamo and runConfig(scripts/qa)
set G_DESIGN_NAME        "sbr0_sbr_generic"
set G_LIBRARY_TYPE       $::env(SIP_LIBRARY_TYPE)
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
set G_DFX_NONSCAN_INSTANCES "*i_pgcbdfxovr*"
  
if {${G_LIBRARY_TYPE} == "b05.8"} {
   set G_UPF         1
   set G_UPF_FILE    $::env(IP_ROOT)/tools/upf/router/sbr_config_ipxact_workspace_sbr0_top.upf
} elseif {${G_LIBRARY_TYPE} == "d04"} {
   set G_UPF         1
#   set G_UPF_FILE    $::env(WARD)/collateral/rtl//sbr_config_ipxact_workspace_sbr0_top.upf
} else {
   puts "Unsupported LIBRARY TYPE for UPF Update the correct files."
   set G_UPF         0
}
set G_PROCESS_NAME       $::env(SIP_PROCESS_NAME)
set G_DOT_PROCESS        $::env(SIP_DOT_PROCESS)
set G_TRACK_TAG          $::env(SIP_TRACK_TAG)
set G_LIB_VOLTAGE        $::env(SIP_LIBRARY_VOLTAGE)

if {${G_LIBRARY_TYPE} == "e05"} {
    set G_STDCELL_DIRS /p/hdk/cad/stdcells/e05/14ww45.3_e05_d.0_cnlgt
#    set env(WARD) $::env(IP_ROOT)/tools/syn/syn_1274/$G_DESIGN_NAME
    set env(block) $G_DESIGN_NAME
}

# scale factor for library to convert undimensioned constraints, 
# implicitly defined in ns, to library units.
set G_NS 1000

# Guardband (reduce) clock period by this ratio
# i.e. real period = target period * SBR_CLK_GUARDBAND
set SBR_CLK_GUARDBAND 0.80

# Frequency of the PGCB TCK clock
set PGCB_TCK_FREQ 50

# 0.1ns clock transition
set SBR_CLK_TRANS [expr 0.1 * $G_NS]

# 5% period for clock uncertainty
set SBR_CLK_UNCER_RATIO 0.05

# input|output delay as ratio of clock period
set SBR_INPUT_DELAY   0.35
set SBR_OUTPUT_DELAY  0.35
set SBR_RELAXED_DELAY 0.05
set SBR_STRAP_DELAY   0.05

set  G_INSERT_CLOCK_GATING 1
set G_MAX_ROUTING_LAYER "m8"
set G_MIN_ROUTING_LAYER "m0"

set G_VISA_APPLY_CLOCK_STAMPING 1
set G_CLOCK_GATING_CELL d04cgc01wd0i0

set G_LOGSCAN_RULES ""

# FIXME -- workaround for kit 14.2.2
setvar G_STDCELL_DIRS /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/
set G_STDCELL_DIRS /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/
set G_STDCELL_DIR /p/hdk/cad/kits_p1273/p1273_14.2.1/stdcells/d04/default/latest/

# NOMAN - ONLY NEEDED FOR FEBE
set CTECH_TYPE "d04"
set CTECH_VARIANT "ln"
###RDT Bug 
source /p/hdk/cad/rdt/rdt_14.4.1/scripts/library_setup.tcl
source /p/hdk/cad/kits_p1273/p1273_14.4.1/flows/rdt/common/scripts/library_d04.tcl

