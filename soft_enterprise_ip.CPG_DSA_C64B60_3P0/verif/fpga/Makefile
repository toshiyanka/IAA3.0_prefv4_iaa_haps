#!make

# Current makefile
MAKEFILE    := $(abspath $(lastword $(MAKEFILE_LIST)))

# Name of IP, which is pointed by WORKAREA.
### Please keep it common across RTL & DV inputs.
TOP_IP_NAME := $(DUT)
TOP_LIB_NAME ?= $(DUT)_lib

# Use DUT specific files, if present, in build.
DUT   ?= iaa3p0s64b60

# Read DUT specific model.cfg file, to load MODEL data, present
# in models section of <DUT.>model.cfg file
MODEL ?= dsaiaa_fpga_1
MODEL_CFG := $(WORKAREA)/verif/fpga/$(DUT).model.cfg

# To read/keep flow specific collateral.
### One such BUILD_DIRNAME is "haps_test".
BUILD_DIRNAME ?= haps

ifeq ($(strip $(BUILD_DIRNAME)),)
$(error Please set "BUILD_DIRNAME" in $(MAKEFILE) or command-line make <target> BUILD_DIRNAME=<>)
endif

BUILD_DIR     := $(abspath $(dir $(MAKEFILE))/$(BUILD_DIRNAME))

export

# To read flow specific build Makefile
include $(BUILD_DIR)/Makefile
