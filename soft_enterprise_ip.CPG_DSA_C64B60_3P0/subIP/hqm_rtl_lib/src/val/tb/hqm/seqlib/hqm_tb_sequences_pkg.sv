//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//------------------------------------------------------------------------------
// File   : hqm_tb_sequences_pkg.sv
// Author : Mike Betker
//
// Description :
//
// Package contains all sequence files. New sequences will be added here.
//------------------------------------------------------------------------------



`ifndef HQM_TB_SEQ_PKG
 `define HQM_TB_SEQ_PKG
   package hqm_tb_sequences_pkg;

   `include "vip_layering_macros.svh"

   `import_base(ovm_pkg::*)
   `include_base("ovm_macros.svh")

   `import_base(sla_pkg::*)
   `include_base("sla_macros.svh")
   
    import IosfPkg::*; //`import_mid(IosfPkg::*)


`ifdef HQM_INCLUDE_NON_PORTABLE_SEQ

      `include_typ("hqm_iosf_prim_rsvd_tgl_seq.sv") //include_mid

      `include_typ("hqm_iosf_prim_np_base_seq.sv")  //include_mid

      `include_typ("hqm_iosf_prim_cfg_rd_seq.sv")   //include_mid

      `include_typ("hqm_iosf_prim_cfg_wr_seq.sv")   //include_mid

      `include_typ("hqm_iosf_prim_io_wr_seq.sv")

      `include_typ("hqm_iosf_prim_mem_rd_seq.sv")  //include_mid

      `include_typ("hqm_iosf_prim_mem_read_seq.sv")

      `include_typ("hqm_iosf_prim_mem_wr_seq.sv")  //include_mid

      `include_typ("hqm_iosf_prim_np_mem_wr_seq.sv")  //include_mid

      `include_typ("hqm_iosf_prim_msg_wr_seq.sv")

      `include_typ("hqm_iosf_prim_pf_dump_seq.sv")

      `include_typ("hqm_iosf_sequences_pkg.sv")     //include_mid     

      `include_typ("hqm_iosf_prim_base_seq.sv")     //include_mid      

      `include_typ("hqm_iosf_sb_cfg_rd_seq.sv")

      `include_typ("hqm_iosf_sb_cfg_wr_seq.sv")

      `include_typ("hqm_iosf_sb_mem_rd_seq.sv")

      `include_typ("hqm_iosf_sb_mem_wr_seq.sv")

      `include_typ("hqm_sb_base_seq.sv")

      `include_typ("hqm_sb_ext_hdr_chk_seq.sv")


  //------------------------------------------------------//
       
      `include_typ("hqm_iosf_prim_file_seq.sv")

      `include_typ("hqm_iosf_sb_file_seq.sv")

      `include_typ("hqm_iosf_prim_access_seq.sv")

      `include_typ("hqm_iosf_sb_access_seq.sv")

      `include_typ("test_hqm_ral_attr_seq.sv")

      `include_typ("test_hqm_ral_attr_ids_seq.sv")

      `include_typ("hqm_iosf_prim_nonblocking_seq.sv")

      `include_typ("hqm_hcw_iosf_pri_enq_seq.sv")  //include_mid

      `include_typ("hqm_iosf_prim_hcw_enq_seq.sv") //include_mid

`endif
   endpackage
`endif //HQM_TB_SEQ_PKG
