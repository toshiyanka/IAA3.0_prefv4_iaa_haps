//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
`ifndef HQM_TLP_RSVD_TGL_SEQ__SV
`define HQM_TLP_RSVD_TGL_SEQ__SV

import IosfPkg::*;
import iosfsbm_fbrc::*;
import iosfsbm_agent::*;

//------------------------------------------------------------------------------
// File        : hqm_tlp_rsvd_tgl_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence issues CfgWr0/CfgRd0/MWr/MRd TLPs to HQM with rsvd fields set to '1'.
//------------------------------------------------------------------------------

class hqm_tlp_rsvd_tgl_seq extends hqm_sla_pcie_base_seq;

  `ovm_sequence_utils(hqm_tlp_rsvd_tgl_seq, sla_sequencer)

  sla_tb_env            loc_tb_env;
  hqm_tb_env            parent_env;

  hqm_tb_sequences_pkg::hqm_iosf_prim_rsvd_tgl_seq  rsvd_tgl_seq;

  extern                function        new(string name = "hqm_tlp_rsvd_tgl_seq");
  extern virtual        task            body();
  extern virtual        task            send_cfg_wr_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);
  extern virtual        task            send_cfg_rd_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);
  extern virtual        task            send_mem_wr_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);
  extern virtual        task            send_mem_rd_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);

endclass : hqm_tlp_rsvd_tgl_seq

function hqm_tlp_rsvd_tgl_seq::new(string name = "hqm_tlp_rsvd_tgl_seq");
  super.new(name);
  `sla_assert($cast(loc_tb_env,ral.get_parent()),("Unable to get handle to sla_tb_env.")) 
  `sla_assert($cast(parent_env,loc_tb_env),      ("Unable to get handle to hqm_tb_env.")) 

endfunction

//------------------
//-- body
//------------------
task hqm_tlp_rsvd_tgl_seq::body();
  IosfTxn   iosf_txn;
  bit [7:0] rand_data_ = $urandom_range(1,255);
  bit [7:0] vf_rand_data_ = 'h_4;
  bit [7:0] tag        = 8'h_f0;
  bit [7:0] sai        = 8'h_03;
  bit [63:0] iosf_addr;

  // -- PF CFG space access with lower two bits of register number non-zero (RSVD per PCIe) -- //
  iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), pf_cfg_regs.CACHE_LINE_SIZE); iosf_addr[1:0] = 2'h_3;

  send_cfg_wr_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  send_tlp(iosf_txn);

  send_cfg_rd_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  send_tlp(iosf_txn, .compare(1), .comp_val(rand_data_), .mask(32'h_ffff) );

  read_compare(pf_cfg_regs.CACHE_LINE_SIZE,rand_data_,8'h_ff,result);

  // -- PF MEM space access with lower two bits of register number non-zero (PH per PCIe) -- //
  iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), hqm_system_csr_regs.AW_SMON_TIMER[0]); iosf_addr[1:0] = 2'h_3;

  send_mem_wr_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  send_tlp(iosf_txn);

  send_mem_rd_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  mrd_chk_addr(iosf_addr, rand_data_);

  read_compare(hqm_system_csr_regs.AW_SMON_TIMER[0],rand_data_,8'h_ff,result);

    // -- Set FUNC_BAR to below 4GB space, in order to generate 3DW Mem Tlp pkts (32-bit addressing) -- // 

	pf_cfg_regs.CSR_BAR_U.write(status,32'h_0000_0009,primary_id,this, .sai(legal_sai)); // -- CSR_PF_BAR[63:32] -- //
	pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id,this, .sai(legal_sai)); // -- CSR_PF_BAR[31:00] -- //

	pf_cfg_regs.FUNC_BAR_U.write(status,32'h_0000_0000,primary_id,this, .sai(legal_sai)); // -- FUNC_PF[63:32] -- //
	pf_cfg_regs.FUNC_BAR_L.write(status,32'h_f000_0000,primary_id,this, .sai(legal_sai)); // -- FUNC_PF[31:00] -- //


  // -- PF MEM space access with lower two bits of register number non-zero (PH per PCIe) -- //
        iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), hqm_system_csr_regs.AW_SMON_TIMER[0]); iosf_addr[1:0] = 2'h_3;

  send_mem_wr_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  send_tlp(iosf_txn);

  send_mem_rd_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  mrd_chk_addr(iosf_addr, rand_data_);

  read_compare(hqm_system_csr_regs.AW_SMON_TIMER[0],rand_data_,8'h_ff,result);

    // -- Set SRIOV_BAR to below 4GB space, in order to generate 3DW Mem Tlp pkts (32-bit addressing) -- // 
	pf_cfg_regs.FUNC_BAR_U.write(status,32'h_0000_0030,primary_id,this, .sai(legal_sai)); // -- FUNC_PF[63:32] -- //
	pf_cfg_regs.FUNC_BAR_L.write(status,32'h_0000_0000,primary_id,this, .sai(legal_sai)); // -- FUNC_PF[31:00] -- //

	pf_cfg_regs.CSR_BAR_U.write(status,32'h_0000_0070,primary_id,this, .sai(legal_sai)); // -- CSR_PF_BAR[63:32] -- //
	pf_cfg_regs.CSR_BAR_L.write(status,32'h_0000_0000,primary_id,this, .sai(legal_sai)); // -- CSR_PF_BAR[31:00] -- //

  // -- PF MEM space access with lower two bits of register number non-zero (PH per PCIe) -- //
        iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), hqm_system_csr_regs.AW_SMON_TIMER[0]); iosf_addr[1:0] = 2'h_3;

  send_mem_wr_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  send_tlp(iosf_txn);

  send_mem_rd_txn(iosf_addr, rand_data_, tag, sai, iosf_txn);
  mrd_chk_addr(iosf_addr, rand_data_);

  read_compare(hqm_system_csr_regs.AW_SMON_TIMER[0],rand_data_,8'h_ff,result);

endtask : body  

task hqm_tlp_rsvd_tgl_seq::send_cfg_wr_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);
  // -- IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  data_i = new[1]; data_i[0] = iosf_data;

  iosf_txn_ = new("iosf_txn_");
  iosf_txn_.cmd               = Iosf::CfgWr0;
  iosf_txn_.reqChId           = 0;
  iosf_txn_.trafficClass      = 0;
  iosf_txn_.reqID             = 0;
  iosf_txn_.reqType           = Iosf::getReqTypeFromCmd (iosf_txn_.cmd);
  iosf_txn_.procHint          = 0;
  iosf_txn_.length            = 1;
  iosf_txn_.address           = iosf_addr;
  iosf_txn_.byteEnWithData    = 0;
  iosf_txn_.data              = data_i;
  iosf_txn_.first_byte_en     = 4'hf;
  iosf_txn_.last_byte_en      = 4'h0;
  iosf_txn_.reqLocked         = 0;  
  iosf_txn_.compareType       = Iosf::CMP_EQ;
  iosf_txn_.compareCompletion = 0;
  iosf_txn_.waitForCompletion = 0;
  iosf_txn_.pollingMode       = 0;
  iosf_txn_.tag               = iosf_tag;
  iosf_txn_.expectRsp         = 0;
  iosf_txn_.driveBadCmdParity =  0;
  iosf_txn_.driveBadDataParity =  0;
  iosf_txn_.driveBadDataParityCycle =  0;
  iosf_txn_.driveBadDataParityPct   =  0;
  iosf_txn_.reqGap            =  0;
  iosf_txn_.chain             =  1'b0;
  iosf_txn_.sai               =  iosf_sai;
  iosf_txn_.errorPresent		=  1'b_0;
  iosf_txn_.rsvdDW1B7         =  1'b_1;
  iosf_txn_.rsvdDW1B3         =  1'b_1;
  iosf_txn_.rsvdDW1B1         =  1'b_1;
  iosf_txn_.rsvdDW0B7         =  1'b_1;
  // -- iosf_txn_.setCfg(parent_env.iosf_pvc.iosfFabCfg.iosfAgtCfg[1]);

endtask : send_cfg_wr_txn

task hqm_tlp_rsvd_tgl_seq::send_cfg_rd_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);
  // -- IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  data_i = new[1]; data_i[0] = iosf_data;

  iosf_txn_ = new("iosf_txn_");
  iosf_txn_.cmd               = Iosf::CfgRd0;
  iosf_txn_.reqChId           = 0;
  iosf_txn_.trafficClass      = 0;
  iosf_txn_.reqID             = 0;
  iosf_txn_.reqType           = Iosf::getReqTypeFromCmd (iosf_txn_.cmd);
  iosf_txn_.procHint          = 0;
  iosf_txn_.length            = 1;
  iosf_txn_.address           = iosf_addr;
  iosf_txn_.byteEnWithData    = 0;
  iosf_txn_.data              = data_i;
  iosf_txn_.first_byte_en     = 4'hf;
  iosf_txn_.last_byte_en      = 4'h0;
  iosf_txn_.reqLocked         = 0;  
  iosf_txn_.compareType       = Iosf::CMP_EQ;
  iosf_txn_.compareCompletion = 0;
  iosf_txn_.waitForCompletion = 0;
  iosf_txn_.pollingMode       = 0;
  iosf_txn_.tag               = iosf_tag;
  iosf_txn_.expectRsp         = 0;
  iosf_txn_.driveBadCmdParity =  0;
  iosf_txn_.driveBadDataParity =  0;
  iosf_txn_.driveBadDataParityCycle =  0;
  iosf_txn_.driveBadDataParityPct   =  0;
  iosf_txn_.reqGap            =  0;
  iosf_txn_.chain             =  1'b0;
  iosf_txn_.sai               =  iosf_sai;
  iosf_txn_.errorPresent		=  1'b_0;
  iosf_txn_.rsvdDW1B7         =  1'b_1;
  iosf_txn_.rsvdDW1B3         =  1'b_1;
  iosf_txn_.rsvdDW1B1         =  1'b_1;
  iosf_txn_.rsvdDW0B7         =  1'b_1;
  // -- iosf_txn_.setCfg(parent_env.iosf_pvc.iosfFabCfg.iosfAgtCfg[1]);

  // --- iosf_txn_ = iosfTxn;

endtask : send_cfg_rd_txn

task hqm_tlp_rsvd_tgl_seq::send_mem_rd_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);
  // -- IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];


  iosf_txn_ = new("iosf_txn_");
  iosf_txn_.cmd               = (iosf_addr[63:32] == 32'h0) ? Iosf::MRd32 : Iosf::MRd64;
  iosf_txn_.reqChId           = 0;
  iosf_txn_.trafficClass      = 0;
  iosf_txn_.reqID             = 0;
  iosf_txn_.reqType           = Iosf::getReqTypeFromCmd (iosf_txn_.cmd);
  iosf_txn_.procHint          = 0;
  iosf_txn_.length            = 1;
  iosf_txn_.address           = iosf_addr;
  iosf_txn_.byteEnWithData    = 0;
  iosf_txn_.data              = data_i;
  iosf_txn_.first_byte_en     = 4'hf;
  iosf_txn_.last_byte_en      = 4'h0;
  iosf_txn_.reqLocked         = 0;  
  iosf_txn_.compareType       = Iosf::CMP_EQ;
  iosf_txn_.compareCompletion = 0;
  iosf_txn_.waitForCompletion = 0;
  iosf_txn_.pollingMode       = 0;
  iosf_txn_.tag               = iosf_tag;
  iosf_txn_.expectRsp         = 0;
  iosf_txn_.driveBadCmdParity =  0;
  iosf_txn_.driveBadDataParity =  0;
  iosf_txn_.driveBadDataParityCycle =  0;
  iosf_txn_.driveBadDataParityPct   =  0;
  iosf_txn_.reqGap            =  0;
  iosf_txn_.chain             =  1'b0;
  iosf_txn_.sai               =  iosf_sai;
  iosf_txn_.errorPresent		=  1'b_0;
  iosf_txn_.rsvdDW1B7         =  1'b_1;
  iosf_txn_.rsvdDW1B3         =  1'b_1;
  iosf_txn_.rsvdDW1B1         =  1'b_1;
  iosf_txn_.rsvdDW0B7         =  1'b_1;
  // -- iosf_txn_.setCfg(parent_env.iosf_pvc.iosfFabCfg.iosfAgtCfg[1]);

  // --- iosf_txn_ = iosfTxn;

endtask : send_mem_rd_txn

task hqm_tlp_rsvd_tgl_seq::send_mem_wr_txn(bit [63:0] iosf_addr, Iosf::data_t iosf_data, bit [7:0] iosf_tag, bit [7:0] iosf_sai, output IosfTxn iosf_txn_);
  // -- IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];
  data_i = new[1]; data_i[0] = iosf_data;

  iosf_txn_ = new("iosf_txn_");
  iosf_txn_.cmd               = (iosf_addr[63:32] == 32'h0) ? Iosf::MWr32 : Iosf::MWr64;
  iosf_txn_.reqChId           = 0;
  iosf_txn_.trafficClass      = 0;
  iosf_txn_.reqID             = 0;
  iosf_txn_.reqType           = Iosf::getReqTypeFromCmd (iosf_txn_.cmd);
  iosf_txn_.procHint          = 0;
  iosf_txn_.length            = data_i.size();
  iosf_txn_.address           = iosf_addr;
  iosf_txn_.byteEnWithData    = 0;
  iosf_txn_.data              = data_i;
  iosf_txn_.first_byte_en     = 4'hf;
  iosf_txn_.last_byte_en      = (data_i.size() > 1) ? 4'hf : 4'h0;
  iosf_txn_.reqLocked         = 0;  
  iosf_txn_.compareType       = Iosf::CMP_EQ;
  iosf_txn_.compareCompletion = 0;
  iosf_txn_.waitForCompletion = 0;
  iosf_txn_.pollingMode       = 0;
  iosf_txn_.tag               = iosf_tag;
  iosf_txn_.expectRsp         = 0;
  iosf_txn_.driveBadCmdParity =  0;
  iosf_txn_.driveBadDataParity =  0;
  iosf_txn_.driveBadDataParityCycle =  0;
  iosf_txn_.driveBadDataParityPct   =  0;
  iosf_txn_.reqGap            =  0;
  iosf_txn_.chain             =  1'b0;
  iosf_txn_.sai               =  iosf_sai;
  iosf_txn_.errorPresent		=  1'b_0;
  iosf_txn_.rsvdDW1B7         =  1'b_1;
  iosf_txn_.rsvdDW1B3         =  1'b_1;
  iosf_txn_.rsvdDW1B1         =  1'b_1;
  iosf_txn_.rsvdDW0B7         =  1'b_1;
  // -- iosf_txn_.setCfg(parent_env.iosf_pvc.iosfFabCfg.iosfAgtCfg[1]);

  // --- iosf_txn_ = iosfTxn;

endtask : send_mem_wr_txn

`endif
