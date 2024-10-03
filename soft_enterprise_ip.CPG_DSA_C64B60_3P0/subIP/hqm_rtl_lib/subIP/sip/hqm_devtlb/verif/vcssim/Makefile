ifeq ($(CRB),) # use shell value, if set; otw use := so we only call cth_query once
   export CRB := $(shell cth_query -tool crb params crb_path -resolve)
endif

ifeq ($(DUT),)   #If we don't do this CRB will assume repo directory name
   export DUT=devtlb
endif
export TOP_MODULE=top

#USER_FLOWS = vcssimemu vcssimfpga vcssimmppxprop
include $(CRB)/Makefile.crb

.DEFAULT_GOAL := all
.PHONY: all lib_cpp gen_filelist

all: gen_filelist lib_cpp vcssim

lib_cpp:
	$(MAKE) -C $(WORKAREA)/verif/cpp cpp

gen_filelist:
	$(MAKE) -C $(WORKAREA)/gen_filelist

