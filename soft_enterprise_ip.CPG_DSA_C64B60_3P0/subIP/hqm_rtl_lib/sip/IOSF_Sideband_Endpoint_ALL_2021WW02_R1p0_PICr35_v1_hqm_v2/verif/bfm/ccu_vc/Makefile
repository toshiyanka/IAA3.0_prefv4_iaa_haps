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


build: .ccu.ts

.ccu.ts: $(SAOLA_HOME)/verilog/sla_pkg.sv verif/lib/sip_vintf_manager/src/sip_vintf_pkg.sv verif/lib/CCU_OOB/ccu_ob_pkg.sv verif/lib/CCU_OOB/ccu_ob_intf.sv verif/lib/CCU_OOB/ccu_ob_ti.sv verif/lib/CCU_CRG/ccu_crg_pkg.sv verif/lib/CCU_CRG/ccu_crg_intf.sv verif/lib/CCU_CRG/ccu_crg_no_param_intf.sv verif/lib/CCU_CRG/ccu_crg_ti.sv verif/ccu-vc/ccu_vc_ti.sv verif/ccu-vc/ccu_intf.sv verif/ccu-vc/ccu_np_intf.sv verif/ccu-vc/ccu_vc_pkg.sv verif/ccu_env/ccu_vc_env_pkg.sv
	$(COMPILER) $(VLOG_ARGS) \
	+incdir+$(OVM_HOME)/src \
	+incdir+${SAOLA_HOME} \
	+incdir+${SAOLA_HOME}/verilog \
	+incdir+verif/lib/sip_vintf_manager/src \
	+incdir+verif/lib/CCU_OOB \
	+incdir+verif/lib/CCU_CRG \
	+incdir+verif/ccu-vc+verif/ccu_env+verif/lib \
	$(SAOLA_HOME)/verilog/sla_pkg.sv \
	verif/lib/sip_vintf_manager/src/sip_vintf_pkg.sv \
	verif/lib/CCU_OOB/ccu_ob_pkg.sv \
	verif/lib/CCU_OOB/ccu_ob_intf.sv \
	verif/lib/CCU_OOB/ccu_ob_ti.sv \
	verif/lib/CCU_CRG/ccu_crg_pkg.sv \
	verif/lib/CCU_CRG/ccu_crg_intf.sv \
	verif/lib/CCU_CRG/ccu_crg_no_param_intf.sv \
	verif/lib/CCU_CRG/ccu_crg_ti.sv \
	verif/ccu-vc/ccu_vc_ti.sv \
	verif/ccu-vc/ccu_intf.sv \
	verif/ccu-vc/ccu_np_intf.sv \
	verif/ccu-vc/ccu_vc_pkg.sv \
	verif/ccu_env/ccu_vc_env_pkg.sv 
	@touch .ccu.ts

clean: 
	rm -f .ccu.ts
