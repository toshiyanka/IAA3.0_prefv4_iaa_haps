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

`ifndef HQM_SLA_PCIE_CFG_SEQ__SV
`define HQM_SLA_PCIE_CFG_SEQ__SV

//------------------------------------------------------------------------------
// File        : hqm_sla_pcie_cfg_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence issues CfgWr0/CfgRd0 accesses to HQM.
//               - Issues CfgWr0 to DEV_COMMAND register of each fucntion with 0x4.
//               - Issues CfgRd0 to DEV_COMMAND register of each fucntion to chk 0x4.
//------------------------------------------------------------------------------


class hqm_sla_pcie_cfg_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_cfg_seq,sla_sequencer)
  bit unimplemented_func_access = $test$plusargs("HQM_UNIMP_FUNC_ACCESS");
  bit unimplemented_reg_access  = $test$plusargs("HQM_UNIMP_CFG_SPACE_ACCESS");
 
  function new(string name = "hqm_sla_pcie_cfg_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit rslt;
	pf_cfg_regs.DEVICE_COMMAND.write(status,32'h_00,primary_id,this,.sai(legal_sai));
    read_compare(pf_cfg_regs.DEVICE_COMMAND,32'h_00,.mask(32'h_0000_ffff),.result(rslt));
	pf_cfg_regs.DEVICE_COMMAND.write(status,32'h_06,primary_id,this,.sai(legal_sai));
    read_compare(pf_cfg_regs.DEVICE_COMMAND,32'h_06,.mask(32'h_0000_ffff),.result(rslt));

    if(unimplemented_func_access) access_unimp_func();

    if(unimplemented_reg_access)  access_unimp_reg();

  endtask

  task access_unimp_func();
    for(int func_no = 0; func_no<='h_ff; func_no++) begin
      bit exp_ur = 1'b_1;
      Iosf::address_t addr = 'h_0;
      addr[23:16]          = func_no;
      if(func_no==`HQM_PF_FUNC_NUM) exp_ur = 1'b_0;
      send_tlp(get_tlp(addr, Iosf::CfgWr0, .i_fill_data(1)), .ur(exp_ur)); // -- Send random data write to RO register of func -- //
      send_tlp(get_tlp(addr, Iosf::CfgRd0),.ur(exp_ur));                 // -- Send read to RO register of func -- //
    end
  endtask

  task access_unimp_reg();
    for(Iosf::address_t addr = `HQM_PF_UNIMP_START_ADDR; addr[15:0] < 'h_fff; addr = addr + 'h_4) begin
      addr[31:24] = pf_cfg_regs.DEVICE_COMMAND.get_bus_num();
      addr[23:19] = pf_cfg_regs.DEVICE_COMMAND.get_dev_num();
      addr[18:16] = pf_cfg_regs.DEVICE_COMMAND.get_func_num();
      send_cfgwr(addr);
      cfgrd_chk_addr(addr, 'h_0);
    end

  endtask
  
endclass

`endif
