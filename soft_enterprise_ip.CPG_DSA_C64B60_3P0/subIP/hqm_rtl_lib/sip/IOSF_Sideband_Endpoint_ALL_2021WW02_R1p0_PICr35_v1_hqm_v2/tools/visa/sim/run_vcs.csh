#!/bin/csh -f

alias my_tsetup  'source /p/com/env/psetup/prod/bin/setupTool'

/bin/rm -rf csrc simv*
vcs 		-debug_all \
			+define+BUG1 +define+DEBUG \
         +define+SVA_OFF +define+INTEL_SVA_OFF +define+IOSF_SB_ASSERT_OFF \
         +define+IOSF_SB_EVENT_OFF \
			-sverilog \
			-ntb_opts dtm+pcs \
			-V +error+200 \
			-override_timescale=1ns/10ps \
			-f $1 

exit 0
