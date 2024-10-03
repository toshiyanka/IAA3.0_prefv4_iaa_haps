set G_DESIGN_NAME "pgcbunit"

set G_UPF 0
#set G_UPF_FILE $env(IP_ROOT)/source/upf/drng_top.upf

set G_LIBRARY_TYPE ec0
echo "G_LIBRARY_TYPE = $G_LIBRARY_TYPE"
#Ptan21: Adding Logscan to null because the cell view
#set G_LOGSCAN_RULES ""

set CTECH_TYPE ec0
set CTECH_VARIANT ln

# library setup
# set my_lib_release_ver "14ww37.3_ec0_c.0.p1_cnlgt"
# setvar G_STDCELL_LIBS($G_LIBRARY_TYPE) $my_lib_release_ver 
# lappend_var G_STDCELL_DIRS "/p/hdk/cad/stdcells/$G_LIBRARY_TYPE/$my_lib_release_ver"
# #lappend_var G_STDCELL_DIR "/p/hdk/cad/stdcells/$G_LIBRARY_TYPE/14ww39.1_e05_c.0.p2_cnlgt"
# lappend_var G_STDCELL_DIR "/p/hdk/cad/stdcells/$G_LIBRARY_TYPE/$my_lib_release_ver"
# ## Recommended by Joon
# # setvar mv_insert_level_shifters_on_ideal_nets all
# setvar auto_insert_level_shifters_on_clocks all


# set G_SCAN_REPLACE_FLOPS 1 
# set G_INSERT_SCAN 1
# set G_LBIST_ENABLE 0
# set G_ENABLE_UNIQUIFIED 0
# set G_COMPILE_OPTIONS "-no_seq_output_inversion -no_autoungroup"
# set G_OPTIMIZE_FLOPS 1
# set G_NUM_CPUS 2
set G_VT_TYPE(default)  ln


# to workaround issues in p1273_1.2.0 not generating outputs, to be fixed in p1273_1.3.0 release...
# set G_SIGNOFF_STAGES "pvextract"



#set G_ADDITIONAL_LINK_LIBRARIES " \
#      $env(IP_ROOT)/source/hip/lib/timing/ip10xrngeshearttop_tttt_0.65v-1.05v_100c.max.ldb \
#       "

# Must not insert scan on these instances due to FIPS security requirements
# set G_DFX_NONSCAN_INSTANCES "*noscan* *doublesync* *msff_async* *drng_drbgs* *drngaons* *i_pgcbdfxovr1* "
 

#Type of signal to connect clock gating cells.
# set G_CLOCK_GATE_CONTROL_SIGNAL scan_enable 

#set G_DFT_TESTMODE_PORTS "fscan_shiften"
#set G_DFX_TESTMODE_PORTS "fscan_clkungate_syn"

# scale factor for library to convert undimensioned constraints,
# implicitly defined in ns, to library units.
# set G_NS 1000

# Guardband (reduce) clock period by this ratio
# i.e. real period = target period * FC_CLK_GUARDBAND
# set FC_CLK_GUARDBAND 0.92

# 0.1ns clock transition
# set FC_CLK_TRANS [expr 0.015 * $G_NS]

# 7% period for clock uncertainty for RO clock
# set FC_CLK_UNCER_RATIO   0.0
# set FC_CLK_UNCER_FIXED   [expr 0 * $G_NS]
# set FC_CLK_UNCER_MINIMUM [expr 0.028 * $G_NS]

# SPT req is 25% for external IO and 20% for SD routing = 45%.before GB. 
# input|output delay as ratio of clock period * 60%.  Aftter GB = 50.1%
# set FC_INPUT_DELAY   0.70
# set FC_OUTPUT_DELAY  0.70
set env(block) $G_DESIGN_NAME

exec /usr/bin/rsync --ignore-existing /p/sip/syn/reggie/latest/scripts/syn/dc_vars.tcl scripts/.
setvar G_INSERT_SCAN 0
setvar G_UPF 0
setvar G_ABUTTED_VOLTAGE 0
setvar G_REMOVE_BUFFERS_DEFAULT_PD 1

# to set the  
lappend G_CLOCK_CELL_LIST "[getvar G_TECH_TYPE]cnorc2al1d02x5"

proc libsetup_build_hip_lib_glob {analysistype process_skew temperature voltage} {
    set atype_glob "max"
    if {[regexp -nocase {min} $analysistype]} {
        set atype_glob "min"
    } elseif {[regexp -nocase {noise} $analysistype]} {
        set atype_glob "*"
    }
   
    return "*"
}

