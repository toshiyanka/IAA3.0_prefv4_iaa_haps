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

build: .router_dut

build-ep: .ep_dut

.router_dut: iosfsbc/common/*.sv iosfsbc/router/*.sv iosfsbc/common/*.vm
	$(COMPILER) $(VLOG_ARGS_DUT) \
	    +incdir+./iosfsbc/common  \
	    +incdir+../../subIP/pgcb/source/rtl/pgcbunit/  \
	    +incdir+../../subIP/dfx_secure_plugin/source/rtl/include/ \
	    +incdir+../../subIP/dfx_secure_plugin/source/rtl/include/assertions/ \
       +incdir+../../subIP/DFx_sTAP_ALL_2014WW26_R1.5.4/source/rtl/include \
       +incdir+../../subIP/DFx_sTAP_ALL_2014WW26_R1.5.4/source/rtl/include/assertions \
	    +incdir+../../subIP/DFx_sTAP_ALL_2014WW26_R1.5.4/subIP/DfxSecurePlugin/source/rtl/include/ \
	    +incdir+../../subIP/DFx_sTAP_ALL_2014WW26_R1.5.4/subIP/DfxSecurePlugin/source/rtl/include/assertions/ \
	    ./iosfsbc/common/*.sv \
	    ./iosfsbc/router/*.sv \
	    ../../subIP/pgcb/source/rtl/pgcbunit/*.sv \
	    ../../subIP/dfx_secure_plugin/source/rtl/dfxsecure_plugin/*.sv \
       ../../subIP/DFx_sTAP_ALL_2014WW26_R1.5.4/subIP/DfxSecurePlugin/source/rtl/dfxsecure_plugin/*.sv \
       ../../subIP/DFx_sTAP_ALL_2014WW26_R1.5.4/source/rtl/stap/*.sv \
	    ../../subIP/ctech_v13ww35b/source/p1273/d04/v/*.v \
       ../../subIP/DFx_sTAP_ALL_2014WW26_R1.5.4/source/rtl/ctech_lib/*.sv
	@touch .router_dut

.ep_dut: iosfsbc/common/*.sv iosfsbc/endpoint/*.sv iosfsbc/common/*.vm
	$(COMPILER) $(VLOG_ARGS_DUT) \
	    +incdir+./iosfsbc/common \
	    ./iosfsbc/common/*.sv    \
	    ./iosfsbc/endpoint/*.sv  \
	    ../../subIP/ctech_v13ww35b/source/p1273/d04/v/*.v
	@touch .ep_dut

clean:
	rm -f .router_dut
	rm -f .ep_dut
	rm -f .vlogansetup.*
