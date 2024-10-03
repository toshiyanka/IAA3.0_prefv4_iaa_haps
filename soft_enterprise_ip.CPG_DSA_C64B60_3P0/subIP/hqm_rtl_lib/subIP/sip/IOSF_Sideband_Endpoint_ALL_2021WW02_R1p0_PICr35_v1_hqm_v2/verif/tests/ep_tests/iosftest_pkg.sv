//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//------------------------------------------------------------------------------


/**
 *  This package encloses all the tests that target the IOSF sideband fabric
 */
package iosftest_pkg;
  // Import/include resources common to all package members
  import ovm_pkg::*;
  import uvm_pkg::*;
  import xvm_pkg::*;
  import iosfsbm_cm::*;
  import iosfsbm_ipvc::*;
  import iosfsbm_fbrc::*;
  import iosfsbm_msg::*;
  import ccu_vc_pkg::*;

  `include "ovm_macros.svh"
  `include "uvm_macros.svh"
  `include "xvm_macros.svh"
  `include "iosfsb_ep_macros.svh"
  `include "iosfsb_ep_params.svh"
  `include "iosfsbm_message_macros.svh"

  // Sequences
  `include "base_seq.svh"
  `include "rnd_seq.svh"
  `include "directed_seq.svh"
  `include "simple_seq.svh"
  `include "regio_seq.svh"
  //`include "bulk_regio_seq.svh"
  `include "msgd_seq.svh"
  `include "qos_seq.svh"
  `include "polling_seq.svh"
  `include "unicast_rnd_seq.svh"
  `include "unicast_bulk_seq.svh"
  `include "unicast_bulk_rd_seq.svh"
  `include "unicast_qos_seq.svh"
  `include "unicast_rnd_seq_endpoint.svh"
  `include "unicast_rnd_invalid_opcode_seq.svh"
  `include "unicast_rnd_invalid_opcode_seq_endpoint.svh"
  `include "unicast_invalid_seq.svh"
  `include "unicast_invalid_seq_endpoint.svh"
  `include "iosf_sb_seq.svh"

  `include "rata_params.svh"
  `ifdef GLS
 // `include "ep_gls_params_new.svh"
  `include "regr_params.svh"
  `elsif REGR
  `include "regr_params.svh"
  `elsif RANDREGR
  `include "rand_regr_params.svh"
  `else
  `include "ep_params.svh"
  `endif
  //base test
  `include "base_test.svh"

  // Tests 
  //Tests - IP-Fabric BFM Related
  `include "test01.svh"
  `include "test02.svh"
  `include "test03.svh"
  `include "test04.svh"
  `include "test05.svh" 
  `include "test06.svh" 
  `include "test07.svh"  
  `include "test08.svh"
  `include "test09.svh"
  `include "test10.svh"
  `include "test11.svh"
  `include "test12.svh"
  `include "test13.svh"
  `include "test14.svh" 
  `include "test15.svh"
  `include "test16.svh"
  `include "test17.svh" 
  `include "test18.svh" 
  `include "test19.svh" 
  `include "test20.svh" 
  `include "test21.svh" 
  `include "test22.svh" 
  `include "test23.svh"	
  `include "test24.svh"
  `include "test25.svh"
  `include "test26.svh"
  `include "test27.svh"
  `include "test28.svh"
  `include "test29.svh"
  `include "test30.svh"
  `include "test31.svh"
  `include "test32.svh"
  `include "test33.svh"
  `include "test34.svh"
  `include "test35.svh"
  `include "test36.svh"
  `include "test37.svh"
  `include "basic_bulk_test.svh"
  `include "bulk_stress_test.svh"
  `include "bulk_trdy_sanity_test.svh"
  `include "bulk_corrupt_test.svh"
  `include "qos_sleep_test.svh"
  //`include "sbe_cfence_test.svh"

endpackage :iosftest_pkg
