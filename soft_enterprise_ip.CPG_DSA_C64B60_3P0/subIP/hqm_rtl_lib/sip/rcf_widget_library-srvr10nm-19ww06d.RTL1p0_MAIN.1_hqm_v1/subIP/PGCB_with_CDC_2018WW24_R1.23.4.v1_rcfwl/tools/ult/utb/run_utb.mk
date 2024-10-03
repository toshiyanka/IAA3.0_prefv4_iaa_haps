MAKEFLAGS += -rR --no-print-directory

ifeq ($(SUBBLOCK_WITHIN_IP),1)
ULT_DIR :=  $(IP_ROOT)/tools/$(ACE_PROJECT)/ult
else
ULT_DIR :=  $(IP_ROOT)/tools/ult
endif

UTB_MOD_PATH := $(ULT_DIR)/utb

ALL_REG_MODULES ?= $(shell /bin/ls -1 $(UTB_MOD_PATH)/*/.regress.*$(SIP_VARIATION)* | sed "s/.*utb\///g" | sed "s/\/\.regress.*//g" )
ALL_DEV_MODULES ?= $(shell /bin/ls -1 $(UTB_MOD_PATH)/*/.dev.*$(SIP_VARIATION)* | sed "s/.*utb\///g" | sed "s/\/\.dev.*//g" )

ifeq ($(IP_SUPPORTS_TTREE),1)
UTB_RESULTS := $(ULT_DIR)/utb
endif

UTB_RESULTS ?= $(shell mkdir -p $(ULT_DIR)/$(SIP_VARIATION)/utb && echo $(ULT_DIR)/$(SIP_VARIATION)/utb)

ULT_PATH := $(UTB_RESULTS)/..

#MY_VCS_LIB ?= $(IP_ROOT)/target/$(ACE_PROJECT)/$(SIP_VARIATION)/vcs_lib

ALL_TARGETS := $(ALL_REG_MODULES:%=%_run_sim)

IP_SUPPORTS_TTREE ?= 0

.PHONY: all
all: all_list

all_list: $(ALL_TARGETS)

define B_UTB
.PHONY: $(1)_build_utb
ifeq ($(MY_VCS_LIB),)
$(1)_utb_cmd := utb -m $(1)
else
$(1)_utb_cmd := utb -m $(1) -vcs_lib $(MY_VCS_LIB)
endif
$(1)_build_utb : $$(UTB_RESULTS)/$(1)/$(1)_build_utb.witness
$$(UTB_RESULTS)/$(1)/$(1)_build_utb.witness :
	@if [ -d $(UTB_MOD_PATH)/$(1) ] ; then \
		echo "UTB MODULE directory is $(UTB_MOD_PATH)/$(1)" ; \
		if [ $(IP_SUPPORTS_TTREE) -eq 0 ] ; then \
			cp -r $$(UTB_MOD_PATH)/$(1) $$(UTB_RESULTS)/ ; \
		fi \
	fi
	@if [ -d $(UTB_RESULTS)/$(1) ] ; then \
		echo "MODULE is $(1)" ; \
	fi
	@if [ ! -d "$(MY_VCS_LIB)" ]  && [ ! -z "$(MY_VCS_LIB)" ] ; then \
		echo "Please provide a valid vcs_lib path" ; \
		exit 1 ; \
	fi
	@if [ -d "$(MY_VCS_LIB)" ] ; then \
	    echo "$(1) module build using vcs_lib= $(MY_VCS_LIB)" ; \
	fi
	@tcsh -fc 'cd $$(ULT_PATH); $$($(1)_utb_cmd);' ;
	@if [ ! -f "$(ULT_PATH)/utb/$(1)/dut_inf/bin/dInfo.pl" ] ; then \
   		echo "UTB module build failed with compile issues" ; \
		exit 1 ; \
	fi
	touch $$(UTB_RESULTS)/$(1)/$(1)_build_utb.witness
endef

define RUN_SIM
.PHONY: $(1)_run_sim
$(1)_TASKNAME := $(shell cat $(UTB_MOD_PATH)/$(1)/.regress.*)
$(1)_run_sim : $$(UTB_RESULTS)/$(1)/$(1)_run_sim.witness
$$(UTB_RESULTS)/$(1)/$(1)_run_sim.witness : $$(UTB_RESULTS)/$(1)/$(1)_build_utb.witness
	@if [ ! -s "$(UTB_MOD_PATH)/$(1)/.regress.*" ] && [ -z "$$($(1)_TASKNAME)" ] ; then \
		cd $(ULT_PATH) ; \
		echo "No task/testname specified in list for module $(1)" ; \
		echo "Running all existing tasks" ; \
		make -C utb/$(1)/tasks clean ; \
		make -C utb/$(1)/tasks/ QUIET=1 || exit 1 ; \
		echo "Running all existing tests" ; \
		make -C utb/$(1)/tests clean ; \
		make -C utb/$(1)/tests/ QUIET=1 || exit 1 ; \
	else \
		echo "List of tests/tasks to be run: $$($(1)_TASKNAME)" ; \
		cd $(ULT_PATH) ; \
		for file in $$($(1)_TASKNAME); do \
			if [ -d "$(UTB_RESULTS)/$(1)/tasks/$$$${file}" ] ; then \
				echo "Running jg_task $$$$file for module $(1)" ; \
				make -C utb/$(1)/tasks/$$$${file} clean ; \
				make -C utb/$(1)/tasks/$$$${file} QUIET=1 || exit 1 ; \
			else \
				if [ -d "$(UTB_RESULTS)/$(1)/tests/$$$${file}" ] ; then \
					echo "Running sim_test $$$$file" ; \
					make -C utb/$(1)/tests/$$$${file} clean ; \
					make -C utb/$(1)/tests/$$$${file} QUIET=1 || exit 1 ; \
				else \
					echo "No valid test or task exists in module $(1)" ; \
					exit 1 ; \
				fi \
			fi \
		done ; \
	fi
	touch $$(UTB_RESULTS)/$(1)/$(1)_run_sim.witness
endef

$(foreach i,$(ALL_REG_MODULES),$(eval $(call B_UTB,$(i))))
$(foreach i,$(ALL_REG_MODULES),$(eval $(call RUN_SIM,$(i))))

clean_build:
	for c in $(ALL_REG_MODULES); do rm -rf $(UTB_RESULTS)/$${c}/dut_inf/bin/dInfo.pl $(UTB_RESULTS)/$${c}/$${c}_build_utb.witness $(UTB_MOD_PATH)/$${c}/dut_inf/bin/dInfo.pl; done

clean_sim:
	for c in $(ALL_REG_MODULES); do rm -f $(UTB_RESULTS)/$${c}/$${c}_run_sim.witness; done

clean:
	for c in $(ALL_REG_MODULES); do rm -rf $(UTB_RESULTS)/$${c}/dut_inf/bin/dInfo.pl $(UTB_RESULTS)/$${c}/$${c}_build_utb.witness $(UTB_MOD_PATH)/$${c}/dut_inf/bin/dInfo.pl; done
	for c in $(ALL_REG_MODULES); do rm -f $(UTB_RESULTS)/$${c}/$${c}_run_sim.witness; done

.PHONY: help 
help: 
	@echo 
	@echo 
	@echo '												UTB MakeFile'
	@echo '												------------'
	@echo
	@echo ' USAGE:     make [IP_SUPPORTS_TTREE=1] [SUBBLOCK_WITHIN_IP=1] [MY_VCS_LIB=IP_ROOT/target/ACE_PROJECT/SIP_VARIATION/vcs_lib] [ALL_REG_MODULES=<module names>]'
	@echo
	@echo ' REQUIREMENT:'
	@echo ' =========='
	@echo '        Run run_utb.mk to build all existing regressible modules and run tasks/tests associated with it'
	@echo '        - make run_utb.mk - '
	@echo '          Searches for regressible modules in tools/ult/utb, with a valid /.regress.<SIP_VARIATION> file'
	@echo '          Builds the module(s) available to regress and uses the first found vcs_lib to pick rtl files'
	@echo '          If .regress.<SIP_VARIATION> file is empty, runs all existing tests/tasks in the utb folder'
	@echo '          If .regress.<SIP_VARIATION> file holds a valid test/task, runs specified test/task'
	@echo
	@echo ' SWITCHES:'
	@echo ' =========='
	@echo '        IP_SUPPORTS_TTREE=1 : This avoids creating a unique PROJ-specific results directory. Switch recommended for IPs supporting build-tree/ttree models'
	@echo '        SUBBLOCK_WITHIN_IP=1: This sets UTB-module directory to tools/<ACE_PROJECT>/ult/utb. Switch recommended for IPs supporting subBlocks'
	@echo '                               Provides a cleaner subdirectory for IPs with mutiple SubBlocks'
	@echo '                               eg: CSME subBlock csme_clink UTB modules reside in tools/csme_clink/ult/utb directory'
	@echo '        MY_VCS_LIB=<PATH>   : This directs UTB to pick the module(s) and dependent rtl files from appropriate vcs_lib'
	@echo '                               This is useful while compiling modules supported in multiple projects'
	@echo
	@echo ' IMPORTANT:'
	@echo ' =========='
	@echo '        1. You must run make from an xterm with sourced env variables (eg: IP_ROOT, SIP_VARIATION)'
	@echo '        2. The model must be compiled with a valid vcs_lib directory. This directs UTB to search through the'
	@echo '            appropriate vcs_lib for the module and the dependent files.'
	@echo '        3. Invoke clean target to re-build the module(s).'
	@echo '        4. Invoke clean_sim target to clean the results directories. This will allow existing tests/tasks run without module rebuild'
	@echo '        5. Regressible modules must hold a .regress.<SIP_VARIATION> file in <utb>/<mod> subdirectory'	  	  
	@echo '             Naming convention of .regress file: .regress.TGPLP      -> module supported in TGPLP'	  	  
	@echo '                                                 .regress.TGPLP.ICPH -> module supported in TGPLP and ICPH'	  	  
	@echo '        6. Regressible tests/tasks to reside in <utb>/<module>/.regress.<SIP_VARIATION> file. If not specified, UTB runs all existing tests/tasks of module'
	@echo '        7. Set swtich IP_SUPPORTS_TTREE=1 for IPs supporting Project-specific cust_build models.'
	@echo '        8. Set switch SUBBLOCK_WITHIN_IP=1 for build/run of UTB modules in SubBlocks within an IP'
	@echo '				'	  	  
	@echo ' Examples:'
	@echo ' ========'
	@echo '        Available make targets:' 
	@echo '        make                                        : Default run. Builds module with tools/ult/utb/<module>/.regress.<SIP_VARIATION> file and run tasks/tests specified in the file'
	@echo '        make IP_SUPPORTS_TTREE=1                    : Builds modules and runs on IP_ROOT/tools/ult/utb directory. '
	@echo '        make IP_SUPPORTS_TTREE=1 MY_VCS_LIB=<PATH>  : Builds modules and runs on IP_ROOT/tools/ult/utb directory. Enables UTB to search for RTL files in MY_VCS_LIB subdirectory'
	@echo '        make SUBBLOCK_WITHIN_IP=1                   : Builds modules and runs on IP_ROOT/tools/ACE_PROJECT/ult/utb directory'
	@echo '        make ALL_REG_MODULES=MODULENAME             : Builds the module name specified and runs existing tests/tasks'
	@echo '        help                                        : This information'
	@echo
	@echo '        Cleaning targets:'
	@echo '        ================='
	@echo '        Switches : [IP_SUPPORTS_TTREE=1 - if IP supports unique model per PROJECT] [SUBBLOCK_WITHIN_IP=1 - If suBlock module within IP]'
	@echo '				'	  	  
	@echo '        make clean                        : removes the build and test/task run results directory'
	@echo '        make clean_sim                    : removes the test/task run results directory alone'

