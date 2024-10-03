export CONFIG = flow.cfg

## Dont edit the below lines
export FLOW = jasper
ifeq ($(CHEETAH_RTL_ROOT),) # use shell value, if set; otw use := so we only call cth_query once
   export CHEETAH_RTL_ROOT := $(shell cth_query -tool cheetah-rtl ENVS CHEETAH_RTL_ROOT -resolve)
endif

export FLOW_ROOT     = ${CHEETAH_RTL_ROOT}/formal/${FLOW}
export RTL_UTIL_ROOT = ${CHEETAH_RTL_ROOT}/rtlutils

include ${FLOW_ROOT}/Makefile.${FLOW}
include ${RTL_UTIL_ROOT}/Makefile.genfilelist
##jg_fpv  :  export RUNSTAGE = DEP
##jg_conn :  export RUNSTAGE = DEP
##jg_sec :  export RUNSTAGE = DEP

