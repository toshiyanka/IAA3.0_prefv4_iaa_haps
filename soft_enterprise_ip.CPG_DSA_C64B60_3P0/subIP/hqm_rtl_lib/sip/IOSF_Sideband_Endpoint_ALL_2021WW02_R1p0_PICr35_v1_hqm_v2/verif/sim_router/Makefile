#------------------------------------------------------------------------------
#
#  -- Intel Proprietary
#  -- Copyright (C) 2015 Intel Corporation
#  -- All Rights Reserved
#
#  INTEL CONFIDENTIAL
#
#  Copyright 2009-2021 Intel Corporation All Rights Reserved.
#
#  The source code contained or described herein and all documents related
#  to the source code (Material) are owned by Intel Corporation or its
#  suppliers or licensors. Title to the Material remains with Intel
#  Corporation or its suppliers and licensors. The Material contains trade
#  secrets and proprietary and confidential information of Intel or its
#  suppliers and licensors. The Material is protected by worldwide copyright
#  and trade secret laws and treaty provisions. No part of the Material may
#  be used, copied, reproduced, modified, published, uploaded, posted,
#  transmitted, distributed, or disclosed in any way without Intel's prior
#  express written permission.
#
#  No license under any patent, copyright, trade secret or other intellectual
#  property right is granted to or conferred upon you by disclosure or
#  delivery of the Materials, either expressly, by implication, inducement,
#  estoppel or otherwise. Any license under such intellectual property rights
#  must be express and approved by Intel in writing.
#
#------------------------------------------------------------------------------
#
#  Collateral Description:
#  IOSF - Sideband Channel IP
#
#  Source organization:
#  SEG / SIP / IOSF IP Engineering
#
#  Support Information:
#  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
#  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
#
#  Revision:
#  2021WW02_PICr35
#
#
#  Usage:
#
#        Main Targets:
#
#        make (or make questa)     # run RTL based testbench (see below for default network and test) 
#        make questa-batch         # same as above but in batch mode
#        make questa-tlm           # same as make / make questa but TLM only (no RTL)
#        make questa-tlm-batch     # same as questa-tlm but in batch mode
#        make visual NETWORK=<network>    # display nework topology graph from last sim
#
#        Cleaning:
#
#        make clean                # Cleans all DUT and TB compile results
#        make cleanall             # same as clean but also cleans OVM and supporting libraries, log/coverage files
#
#        Make Options:
#
#        TEST=<test name>          Run a specific test.  Default: rtr_rnd_test
#        NETWORK=<network>         Use specified network for the test. Default = 8port_async  
#                                  Networks are defined in the tests/ directory using IPXACT xml files.
#        TYPE=<type>               Save graphical network output in a particular format. Default=svg
#        TXLIMIT=<number>          Stop sending xactions after sending TXLIMIT xactions. Default = 500
#        ERRCNT=<number>           Stop test after specified number of ovm_errors. Default = 1
#        TIMEOUT_DELAY=<number>    Arbitary time out delay for aging xactions. Default = 30100000
#	 TIMEOUT_TEST=<number>     OVM Watchdog timer delay in ps units, test will timeout after this timer units
#        SEED=<number>             Use specified random seed.  Default = random
#        VERBOSITY=<setting>       Default = OVM_NOE
#        OVM_DEBUG           = 500, // OVM_FULL + OVM debug messages
#        OVM_FULL            = 400, // OVM_HIGH + VERBOSITY_ALL
#        OVM_HIGH            = 300, // OVM_MEDIUM + VERBOSITY_DEBUG_2
#        OVM_MEDIUM          = 200, // OVM_LOW + VERBOSITY_DEBUG_1
#        OVM_LOW             = 100, // OVM_NONE + VERBOSITY_PATH,VERBOSE_TX_RX, VERBOSE_PROGRESS
#        OVM_NONE            = 0, // Print FATAL, INFO, WARNING
#	
#	 Coverage	 MSIM_CM=1
#        PLATFORM=<string>         Option to pass to gcc when compiling supporting libraries.
#                                  Defaults to -m64 (x86-64 compile).  For 32-bit compile, 
#                                  use PLATFORM=-m32

# Constants
# =========
include ../scripts/Makefile
