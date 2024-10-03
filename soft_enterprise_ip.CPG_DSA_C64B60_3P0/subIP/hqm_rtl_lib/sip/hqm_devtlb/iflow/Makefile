## Dont edit the below lines
ifeq ($(CHEETAH_RTL_ROOT),) # use shell value, if set; otw use := so we only call cth_query once
   export CHEETAH_RTL_ROOT := $(shell cth_query -tool cheetah-rtl ENVS CHEETAH_RTL_ROOT -resolve)
endif


iflow_all: 
	${CHEETAH_RTL_ROOT}/iflow/scripts/iflow_run.pl -ini ${WORKAREA}/iflow/iflow.ini 

iflow_all_nb: 
	${CHEETAH_RTL_ROOT}/iflow/scripts/iflow_run.pl -ini ${WORKAREA}/iflow/iflow.ini -local false

iflow_gk: 
	${CHEETAH_RTL_ROOT}/iflow/scripts/iflow_run.pl -ini ${WORKAREA}/iflow/Gk_iflow.ini

#iflow_all: iflow_gen
#	#$(shell make -f ${WORKAREA}/output/iflow/Makefile.iflow -j 4 all)
#	$(MAKE) -f ${WORKAREA}/output/iflow/Makefile.iflow -j 4 all  
.PHONY: iflow_all_nb iflow_all iflow_gk

