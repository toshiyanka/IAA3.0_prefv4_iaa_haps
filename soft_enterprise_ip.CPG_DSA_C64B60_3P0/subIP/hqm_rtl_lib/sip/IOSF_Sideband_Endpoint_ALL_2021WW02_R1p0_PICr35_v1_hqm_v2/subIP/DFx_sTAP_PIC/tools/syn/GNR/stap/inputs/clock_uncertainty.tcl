###################################
# This is an example clocks script.
# Please modify it to suit your block
# by copying it to your local scripts directory
# with the name <top design name>_clocks.stcl


###################################
# Clock definitions
###################################
# Use the following conventions 
# for better portability
#
# 1. Define the period in ns using the G_NS variable
#    ex: a 2ns period would be -period [expr 2.0 * $G_NS]
#    This will allow portability to other libraries which
#    may have different timing units.
# 2. For nonstandard waveforms (i.e. other than 50% DC), also
#    use the $G_NS variable to define the waveform
#    ex: -waveform [list 0 [expr 1.253 * $G_NS]]
# 3. When possible, define the period and waveform using
#    variables instead of hardcodes.  This allows for easier
#    scaling of frequencies.
#    ex: set clk_freq [expr 1.253 * $G_NS]
#        create_clock -period $clk_freq ....
# 4. Clock uncertainty and transition times can be defined as
#    either a percentage of the period or an absolute value
#    (somewhat design dependent)

#set clk_period      [expr 3.264 * $G_NS]
#set clk_waveform    [list 0 [expr $clk_period * 0.5]]
#set clk_transition  [expr 0.1 * $G_NS]
#set clk_uncertainty [expr $clk_period * 0.05]

#create_clock -period  $clk_period [get_ports clk] -waveform $clk_waveform
#set_clock_transition  $clk_transition  [get_clocks clk]
#set_clock_uncertainty $clk_uncertainty [get_clocks clk]


#######################################################
# Generated clocks
# Generally these are fairly portable, but be careful
# not to define source points on library (or GTECH) dependent
# pin names.  Best practice is to create the generated clocks
# on hierarchical module ports.

set G_NS 1000

#STAP Primary Clock
set ftap_tck_period      [expr 10 * $G_NS]
set ftap_tck_uncertainty [expr $ftap_tck_period * 0.03]
set_clock_uncertainty $ftap_tck_uncertainty [get_clocks $TAP_CLK ]

#STAP Secondary Clock
set ftapsslv_tck_period      [expr 10 * $G_NS]
set ftapsslv_tck_uncertainty [expr $ftapsslv_tck_period * 0.03]
set_clock_uncertainty $ftapsslv_tck_uncertainty [get_clocks $TAP_SSLVCLK]
