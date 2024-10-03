set G_DESIGN_NAME        "sbebase"
set G_LIBRARY_TYPE       $::env(SIP_LIBRARY_TYPE)
set G_SCAN_REPLACE_FLOPS 1
set G_INSERT_SCAN        1
set G_LBIST_ENABLE       0
set G_ENABLE_UNIQUIFIED  0
#set G_UPF_FILE           $G_INPUTS_DIR}/${G_DESIGN_NAME}.upf
set G_COMPILE_OPTIONS    "-no_seq_output_inversion -no_autoungroup"
set G_OPTIMIZE_FLOPS     1
set G_NUM_CPUS           2
set G_DFT_TESTMODE_PORTS "fscan_shiften"
set G_DFX_TESTMODE_PORTS "fscan_clkungate_syn"
set G_VT_TYPE(default)   $::env(SIP_LIBRARY_VTYPE)
set G_PROCESS_NAME       $::env(SIP_PROCESS_NAME)
set G_DOT_PROCESS        $::env(SIP_DOT_PROCESS)
set G_TRACK_TAG          $::env(SIP_TRACK_TAG)

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
set EP_STRAPS_DELAY  0.05
