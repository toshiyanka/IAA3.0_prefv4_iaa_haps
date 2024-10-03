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

`ifndef HQM_CMD_SEQ__SV
`define HQM_CMD_SEQ__SV

//-----------------------------------------------------------------------------------------------------
// File        : hqm_cmd_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence runs cft based tests via tasks mentioned in seq below,
// 
//-----------------------------------------------------------------------------------------------------

import hqm_tb_cfg_pkg::*;

class hqm_cmd_seq extends hqm_integ_seq_pkg::hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_cmd_seq, sla_sequencer)

    string mode = "";
    bit hqm_is_ep = $test$plusargs("hqm_is_reg_ep");

    function new(string name = "hqm_cmd_seq");
       super.new(name);
    endfunction

    virtual task body();
      if(!$value$plusargs("HQM_CMD_SEQ_MODE=%s",mode)) begin mode = "default"; end

      case(mode.tolower()) 
        "pm_state_change"        :   pm_state_change_seq();

        "pf_flrp"                :   pf_flrp_seq();

        "csr_strap_load_chk"     :   csr_strap_load_chk();

        default                  :   pm_state_change_seq();
      endcase

      super.body(); // -- Executes the commands pushed in cfg_cmds Q -- //

    endtask

    function pm_state_change_seq();
       cfg_cmds.push_back("idle 400");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Read first part of PF header");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_id");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_status");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable memory operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       cfg_cmds.push_back("#");
       cfg_cmds.push_back("idle 20");
       cfg_cmds.push_back("#");
       cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable                   0xf ");
       
       cfg_cmds.push_back("rd hqm_system_csr.ingress_alarm_enable                   0xf ");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Test 2: PM regs");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0xffffffff");
       cfg_cmds.push_back("idle 200");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x3 0xffffffff");
       cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable                   0x7 ");
       cfg_cmds.push_back("rde hqm_system_csr.ingress_alarm_enable");
       
       
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0x55555555");
       cfg_cmds.push_back("idle 200");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x1 0xffffffff");
       cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable                   0x3 ");
       cfg_cmds.push_back("rde hqm_system_csr.ingress_alarm_enable");
       
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0xaaaaaaaa");
       cfg_cmds.push_back("idle 200");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x2 0xffffffff");
       cfg_cmds.push_back("rde hqm_system_csr.ingress_alarm_enable");
       
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0x0");
       cfg_cmds.push_back("idle 300");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x0 0xffffffff");
       
       cfg_cmds.push_back("idle 3000");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Read first part of PF header");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_id");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_status");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable memory operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       cfg_cmds.push_back("###################################");
        
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable memory and parity operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("##");
       cfg_cmds.push_back("###poll to Wait for reset to be done ");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       cfg_cmds.push_back("###################################");
      
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Read reset value: D3->D0 = FLR ");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# alarm_ctl is persistent so expect written value");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("rd hqm_system_csr.ingress_alarm_enable                   0x0 ");
       cfg_cmds.push_back("###################################");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enter D1 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x1 ");
       cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable                   0xa ");
       
       cfg_cmds.push_back("rd hqm_system_csr.ingress_alarm_enable                   0xa ");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enter D2 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0x2 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x2 ");
       cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable                   0x5 ");
       
       cfg_cmds.push_back("rd hqm_system_csr.ingress_alarm_enable                   0x5 ");
       
       cfg_cmds.push_back("###################################");
       
       
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enter D1 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x1 ");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("##----------- FLR ---------------## ");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control 0x0020 0x8000 ");
       cfg_cmds.push_back("poll hqm_pf_cfg_i.pcie_cap_device_status 0x0 0x00200000 10000");
       
       cfg_cmds.push_back("##Disable MSI in order to avoid any unattended INT later##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.msix_cap_control 0x0000");
       
       cfg_cmds.push_back("##Disable Bus Master, INTX and Mem Txn enable bit from device_command##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.device_command 0x400");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.pcie_cap_device_control.startflr 0x1");
       cfg_cmds.push_back("idle 7000");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Post FLR expect D0 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x0 ");
        
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");

       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable memory and parity operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("##");
       cfg_cmds.push_back("###poll to Wait for reset to be done ");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       cfg_cmds.push_back("###################################");
      
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enter D2 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0x2 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x2 ");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("##----------- FLR ---------------## ");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control 0x0020 0x8000 ");
       cfg_cmds.push_back("poll hqm_pf_cfg_i.pcie_cap_device_status 0x0 0x00200000 10000");
       
       cfg_cmds.push_back("##Disable MSI in order to avoid any unattended INT later##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.msix_cap_control 0x0000");
       
       cfg_cmds.push_back("##Disable Bus Master, INTX and Mem Txn enable bit from device_command##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.device_command 0x400");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.pcie_cap_device_control.startflr 0x1");
       cfg_cmds.push_back("idle 7000");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Post FLR expect D0 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x0 ");
        
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");

       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable memory and parity operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("##");
       cfg_cmds.push_back("###poll to Wait for reset to be done ");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       cfg_cmds.push_back("###################################");
      
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enter D3 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pm_cap_control_status 0x3 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x3 ");
       // -- cfg_cmds.push_back("idle 3000");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("##----------- FLR ---------------## ");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control 0x0020 0x8000 ");
       cfg_cmds.push_back("poll hqm_pf_cfg_i.pcie_cap_device_status 0x0 0x00200000 10000");
       
       cfg_cmds.push_back("##Disable MSI in order to avoid any unattended INT later##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.msix_cap_control 0x0000");
       
       cfg_cmds.push_back("##Disable Bus Master, INTX and Mem Txn enable bit from device_command##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.device_command 0x400");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.pcie_cap_device_control.startflr 0x1");
       cfg_cmds.push_back("idle 7000");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Post FLR expect D0 state");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pm_cap_control_status.ps 0x0 ");
        
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");

       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable memory and parity operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("##");
       cfg_cmds.push_back("###poll to Wait for reset to be done ");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       cfg_cmds.push_back("###################################");
      
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       cfg_cmds.push_back("idle 50");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       cfg_cmds.push_back("###################################");

    endfunction : pm_state_change_seq 

    function pf_flrp_seq();
       cfg_cmds.push_back("idle 500");
       cfg_cmds.push_back("###############################");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable memory and parity operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("rd config_master.cfg_pm_pmcsr_disable.disable 0x0");
       cfg_cmds.push_back("##");
       cfg_cmds.push_back("###poll to Wait for reset to be done ");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       cfg_cmds.push_back("###poll to Wait for unit_idle to be done ");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_idle_status 0x0007ffff 0x0007ffff 500");
       
       if(hqm_is_ep) begin
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CAP         0x400C11");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CAP.PORTNUM 0x55");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CAP.PORTNUM 0x55");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CAP         0x55400C11");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CAP.PORTNUM 0xaa");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CAP.PORTNUM 0x55");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CAP         0x55400C11");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CAP.PORTNUM 0x00");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CAP.PORTNUM 0x55");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CAP         0x55400C11");
                     
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_STATUS      0x00");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_STATUS      0x1011");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_STATUS      0x5555");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_STATUS      0x1011");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_STATUS      0xaaaa");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_STATUS      0x1011");
                     
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL       0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x0");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x1");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x1");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x2");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x2");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x0");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x0");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x1");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x1");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x0");
                     
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x0");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x1");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x1");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x0");
                     
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x0");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x1");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x1");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x0");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x0");
                     
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL       0x0");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x2");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x1");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x1");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x1");
                     
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.ARI_CAP_ID                0xe");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.ARI_CAP_VERSION_NEXT_PTR  0x01");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.ARI_CAP                   0x00");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.ARI_CAP_CONTROL           0x00");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.ARI_CAP_CONTROL           0xaa");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.ARI_CAP_CONTROL           0x00");
                     cfg_cmds.push_back("wr hqm_pf_cfg_i.ARI_CAP_CONTROL           0x55");
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.ARI_CAP_CONTROL           0x00");
       end
      
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pcie_cap_device_control.mps 0x0");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x0");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pcie_cap_device_control.mps 0x2");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x2");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pcie_cap_device_control.mps 0x7");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x7");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pcie_cap_device_control.mps 0x0");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x0");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pcie_cap_device_control.mps 0x5");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x5");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.pcie_cap_device_control.mps 0x2");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x2");
       
       cfg_cmds.push_back("## -- PF CFG regs persistent registers as per PCIe spec -- ##");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x2");
       
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.IEUNC 0x0 ");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.UR    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.ECRCC 0x1 ");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.MTLP  0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.EC    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.CA    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.CT    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.PTLPR 0x1 ");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.DLPE  0x1");
       
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.IEUNC 0x0 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.UR    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.ECRCC 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.MTLP  0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.EC    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.CA    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.CT    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.PTLPR 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.DLPE  0x1");
       
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.IEUNC 0x0 ");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.UR    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.ECRCC 0x1 ");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.MTLP  0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.RO    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.EC    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.CA    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.CT    0x1");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.PTLPR 0x1 ");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.DLPE  0x1");
       
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.IEUNC 0x0 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.UR    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.ECRCC 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.MTLP  0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.RO    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.EC    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.CA    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.CT    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.PTLPR 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.DLPE  0x1");
       
       cfg_cmds.push_back("idle 400");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("##----------- FLR ---------------## ");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control 0x0020 0x8000 ");
       cfg_cmds.push_back("poll hqm_pf_cfg_i.pcie_cap_device_status 0x0 0x00200000 10000");
       
       cfg_cmds.push_back("##Disable MSI in order to avoid any unattended INT later##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.msix_cap_control 0x0000");
       
       cfg_cmds.push_back("##Disable Bus Master, INTX and Mem Txn enable bit from device_command##");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.device_command 0x400");
       cfg_cmds.push_back("wr  hqm_pf_cfg_i.pcie_cap_device_control.startflr 0x1");
       cfg_cmds.push_back("idle 7000");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control 0x0000 0x8000");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Read first part of PF header");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_id");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_status");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command");
       if(hqm_is_ep) begin 
                     cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x2");
       end
       cfg_cmds.push_back("###################################");
       
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Wait for reset to be done (including hardware memory init)");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       
       cfg_cmds.push_back("###poll to Wait for reset to be done ");
       cfg_cmds.push_back("poll config_master.cfg_diagnostic_reset_status 0x80000bff 0x80000bff 500");
       cfg_cmds.push_back("###################################");
       
       cfg_cmds.push_back("idle 400");
       
       cfg_cmds.push_back("## -- PF CFG regs persistent registers as per PCIe spec -- ##");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.pcie_cap_device_control.mps 0x2");
       if(hqm_is_ep) begin
           cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.ASPMC 0x2");
           cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.RCB   0x1");
           cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.EXTSYNC   0x1");
           cfg_cmds.push_back("rd hqm_pf_cfg_i.PCIE_CAP_LINK_CONTROL.CCLKCFG   0x1");
       end
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.IEUNC 0x0 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.UR    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.ECRCC 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.MTLP  0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.EC    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.CA    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.CT    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.PTLPR 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_MASK.DLPE  0x1");
       
       
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.IEUNC 0x0 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.UR    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.ECRCC 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.MTLP  0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.RO    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.EC    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.CA    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.CT    0x1");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.PTLPR 0x1 ");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.AER_CAP_UNCORR_ERR_SEV.DLPE  0x1");
       
       cfg_cmds.push_back("### ------------------------------------------ ###");
       
       cfg_cmds.push_back("idle 100");

    endfunction : pf_flrp_seq 

    function csr_strap_load_chk();
       string csr_rac, csr_wac, csr_cp, csr_load;

       if(!$value$plusargs("HQM_STRAP_CSR_RAC=%s",csr_rac))    begin csr_rac  = "default"; end
       if(!$value$plusargs("HQM_STRAP_CSR_WAC=%s",csr_wac))    begin csr_wac  = "default"; end
       if(!$value$plusargs("HQM_STRAP_CSR_CP=%s",csr_cp))      begin csr_cp   = "default"; end
       if(!$value$plusargs("HQM_STRAP_CSR_LOAD=%s",csr_load))  begin csr_load = "0x0"; end
       if(csr_load == "0x0")  begin csr_rac  = "default"; csr_wac  = "default"; csr_cp  = "default"; end

       `ovm_info(get_full_name(), $psprintf("Starting csr_strap_load_chk with: csr_rac(%s), csr_wac(%s), csr_cp(%s), csr_load(%s)",csr_rac, csr_wac, csr_cp, csr_load), OVM_LOW);
      
       cfg_cmds.push_back("idle 500");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Read first part of PF header");
       cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup FUNC_PF BAR to a base address of 0x00000001_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.func_bar_u 0x00000001");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Setup CSR_PF BAR to a base address of 0x00000002_xxxxxxxx");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_l 0x00000000");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.csr_bar_u 0x00000002");
       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("# Enable PF memory operations");
       cfg_cmds.push_back("wr hqm_pf_cfg_i.device_command 0x6");

       //if(csr_wac == "0x0000000000000000" || csr_rac == "0x0000000000000000") begin
       //     cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command 0x0");
       //end else begin
            cfg_cmds.push_back("rd hqm_pf_cfg_i.device_command 0x6");
       //end

       cfg_cmds.push_back("###################################");
       cfg_cmds.push_back("idle 100");

       if(csr_load=="0x1") begin

           case(csr_cp)
              "0x5555555555555555" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_LO  0x55555555");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_HI  0x55555555");
              end
              "0xaaaaaaaaaaaaaaaa" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_LO  0xaaaaaaaa");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_HI  0xaaaaaaaa");
              end
              "0xffffffffffffffff" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_LO  0xffffffff");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_HI  0xffffffff");
              end
              "0x0000000000000000" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_LO  0x00000000");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_HI  0x00000000");
              end         
              default              :  begin
                       //if(csr_wac == "0x0000000000000000") begin
                       //     cfg_cmds.push_back("rde hqm_sif_csr.HQM_CSR_CP_LO  ");
                       //     cfg_cmds.push_back("rde hqm_sif_csr.HQM_CSR_CP_HI  ");
                       //end else 
                       //begin 
                            cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_LO  0x01000218");
                            cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_HI  0x00000400");
                       //end 

              end

           endcase

           case(csr_wac)
              "0x5555555555555555" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_LO  0x55555555");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_HI  0x55555555");
              end
              "0xaaaaaaaaaaaaaaaa" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_LO  0xaaaaaaaa");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_HI  0xaaaaaaaa");
              end
              "0xffffffffffffffff" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_LO  0xffffffff");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_HI  0xffffffff");
              end
              "0x0000000000000000" :  begin 
                       cfg_cmds.push_back("rde hqm_sif_csr.HQM_CSR_WAC_LO  ");
                       cfg_cmds.push_back("rde hqm_sif_csr.HQM_CSR_WAC_HI  ");
              end         
              default              :  begin
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_LO  0x0300021f");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_HI  0x20000c00");
              end

           endcase

           case(csr_rac)
              "0x5555555555555555" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_LO  0x55555555");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_HI  0x55555555");
              end
              "0xaaaaaaaaaaaaaaaa" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_LO  0xaaaaaaaa");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_HI  0xaaaaaaaa");
              end
              "0xffffffffffffffff" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_LO  0xffffffff");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_HI  0xffffffff");
              end
              "0x0000000000000000" :  begin 
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_LO  0x00000000");
                       cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_HI  0x00000000");
              end         
              default              :  begin
                       //if(csr_wac == "0x0000000000000000") begin
                       //     cfg_cmds.push_back("rde hqm_sif_csr.HQM_CSR_RAC_LO  ");
                       //     cfg_cmds.push_back("rde hqm_sif_csr.HQM_CSR_RAC_HI  ");
                       //end else 
                       //begin 
                            cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_LO  0xffffffff");
                            cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_HI  0xffffffff");
                       //end 

              end

           endcase


       end else begin
              cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_LO  0x01000218");
              cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_CP_HI  0x00000400");
              cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_LO 0xffffffff");
              cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_RAC_HI 0xffffffff");
              cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_LO 0x0300021f");
              cfg_cmds.push_back("rd hqm_sif_csr.HQM_CSR_WAC_HI 0x20000c00");
       end

    endfunction : csr_strap_load_chk 
endclass

`endif
