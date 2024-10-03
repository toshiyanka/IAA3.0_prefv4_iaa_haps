#-----------------------------------------------------------------
# Intel Proprietary -- Copyright 2010 Intel -- All rights reserved
# Author: melmalaki -- Created: 2010-03-17
#-----------------------------------------------------------------

#
# Tested on VCS      D-2009.12-3_Full64
# Tested on QUESTA   SE-64 6.6
#

#
# Test name - valid values are 
#    normal
#    faulty
#
TEST=normal

#
# Phony targets
#
vcs:    analyze.vcs elaborate.vcs  sim.vcs
questa: lib.questa  compile.questa sim.questa

#
# VCS
#
analyze.vcs:
	vlogan -debug_all -work src -sverilog -f src/compile.f     		-l src_vcs_analyze.log
	vlogan -debug_all -work env -sverilog -f example/env_compile.f -l env_vcs_analyze.log
	vlogan -debug_all -work tb  -sverilog -f example/tb_compile.f 	-l tb_vcs_analyze.log

elaborate.vcs:
	vcs -debug_all tb.$(TEST) -l vcs_elaborate.log

sim.vcs:
	simv -l vcs_sim.log

#
# Clean 
#
clean:
	@\rm -rf 64 AN.DB csrc simv* *.log vc_hdrs.h urgReport ucli.key

