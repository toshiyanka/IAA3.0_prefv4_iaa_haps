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

export INCDIRS = +incdir+../bfm/sideband_vc/tb/common +incdir+../bfm/sideband_vc/tb/seq_lib +incdir+./rtr_tests +incdir+../tb/env/$(NETWORK)
export INCDIRS_IPTEST = +incdir+../bfm/sideband_vc/tb/common +incdir+../bfm/sideband_vc/tb/seq_lib +incdir+./ep_tests +incdir+../bfm/sideband_vc/tb/ip_vc

build: .iosfsbm_rtr_tests_pkg.ts
build-iptest: .iosf_iptest_pkg.ts

.iosfsbm_rtr_tests_pkg.ts: rtr_tests/iosfsbm_rtr_tests_pkg.sv rtr_tests/*.svh ../tb/intf/*mbp* ../tb/intf/*par* ../bfm/sideband_vc/tb/seq_lib/*.svh ../bfm/sideband_vc/tb/.iosfsbm_rtr_pkg.ts 
	$(COMPILER) $(VLOG_ARGS) $(INCDIRS) rtr_tests/iosfsbm_rtr_tests_pkg.sv
	@touch .iosfsbm_rtr_tests_pkg.ts

.iosf_iptest_pkg.ts: ep_tests/iosftest_pkg.sv ep_tests/*.svh ../bfm/sideband_vc/tb/seq_lib/*.svh 
	$(COMPILER) $(VLOG_ARGS) $(INCDIRS_IPTEST) ep_tests/iosftest_pkg.sv
	@touch .iosf_iptest_pkg.ts

clean:
	rm -f .*.ts
	rm -f .vlogansetup.*
