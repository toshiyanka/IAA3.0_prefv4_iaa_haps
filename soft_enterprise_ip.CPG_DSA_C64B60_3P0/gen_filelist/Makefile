export CONFIG = ${DUT}.cfg

## Dont edit the below lines
export FLOW = genfilelist
ifeq ($(CHEETAH_RTL_ROOT),) # use shell value, if set; otw use := so we only call cth_query once
   export CHEETAH_RTL_ROOT := $(shell cth_query -tool cheetah-rtl ENVS CHEETAH_RTL_ROOT -resolve)
endif

export FLOW_ROOT     = ${CHEETAH_RTL_ROOT}/rtlutils
export RTL_UTIL_ROOT = ${CHEETAH_RTL_ROOT}/rtlutils

include ${FLOW_ROOT}/Makefile.${FLOW}
.DEFAULT_GOAL := all

all: pre_visa visa_insert flowgen_cc flowgen_cpp flowgen_vcssim
pre_visa:  touch_visa gen_filelist
post_visa: gen_filelist


touch_visa :
	@echo "Creates a Dummy Visa Inserted RTL Filelist"
	@echo "Remove SGDCDC Constraints for $(DUT)"
	if [ -d $(WORKAREA)/src/codegen/$(DUT)/visa/$(DUT)/$(DUT).sig.sgdc ]; then \
        rm -r $(WORKAREA)/src/codegen/$(DUT)/visa/$(DUT)/$(DUT).sig.sgdc; \
    fi;
	mkdir -p $(WORKAREA)/src/codegen/$(DUT)/visa/$(DUT)
	cp /dev/null $(WORKAREA)/src/codegen/$(DUT)/visa/$(DUT)/visa.f
	@echo "These files will be populated once Visa Insertion is done"

visa_insert :
	@echo "Insert Visa for IP: $(DUT)"
	$(MAKE) -C $(WORKAREA)/dfx/visa DUT=$(DUT)
#ifeq ($(DUT),dsa3p0s64b60)
#	@echo "Insert Visa for each partition of $(DUT)"
#	$(MAKE) -C $(WORKAREA)/dfx/visa DUT=$(DUT) TOP_MODULE_NAME=dsa3p0s64b60
#endif
	@echo "Running Gen_Filelist Post Visa Insertion for $(DUT)"
	$(MAKE) -C $(WORKAREA)/gen_filelist gen_filelist DUT=$(DUT) TOP_IP_NAME=$(DUT)
	@echo "Running VISA Filtering Stage for $(DUT)"
	mv $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.rtl.f $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.rtl.f.orig
	mv $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.sim.f $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.sim.f.orig
	mv $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.syn.f $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.syn.f.orig
	$(CHEETAH_RTL_ROOT)/utilities/rtl_filelist_prep -visa_filtering -rtl $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.rtl.f.orig -output_rtl $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.rtl.f
	$(CHEETAH_RTL_ROOT)/utilities/rtl_filelist_prep -visa_filtering -rtl $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.sim.f.orig -output_rtl $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.sim.f
	$(CHEETAH_RTL_ROOT)/utilities/rtl_filelist_prep -visa_filtering -rtl $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.syn.f.orig -output_rtl $(WORKAREA)/output/$(DUT)/genfile/ip/$(DUT)/$(DUT).sv.syn.f

flowgen_cc:
ifeq ($(DUT),dsa3p0s64b60) #cc only compiles numeric c library which is only needed for dsa3p0s
	$(MAKE) -C $(WORKAREA)/verif/cc flowgen-cc
endif

flowgen_cpp:
	$(MAKE) -C $(WORKAREA)/verif/cpp flowgen-cpp

flowgen_vcssim:
	$(MAKE) -C $(WORKAREA)/verif/vcssim flowgen-vcssim

clean :
	@echo "Remove Generated Filelists by $(DUT)"
	if [ -d $(WORKAREA)/output/$(DUT)/genfile ]; then \
        rm -r $(WORKAREA)/output/$(DUT)/genfile*; \
    fi;


help :
	@echo ""
	@echo "************************************************** Help ***************************************************"
	@echo ""
	@echo   " 1. make gen_filelist   -- To generate filelist for all flows. "
	@echo   " 2. make block_filelist -- To generate partition level filelist. 'BLOCK' keyword must be specified"
	@echo   " 3. make clean_filelist -- To clean the generated filelist, 'BLOCK' keyword must be specified to clean block level filelist.
	@echo ""
	@echo "***********************************************************************************************************"
	@echo ""

