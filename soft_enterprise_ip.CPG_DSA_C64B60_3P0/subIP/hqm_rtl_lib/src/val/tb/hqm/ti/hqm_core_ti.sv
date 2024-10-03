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
//-- hqm_core_ti
//-----------------------------------------------------------------------------------------------------

import hqm_AW_pkg::*;
import hqm_pkg::*;

import ovm_pkg::*;
import axi_pkg::*;
import apb_pkg::*;
import hcw_pkg::*; 
import hqm_core_verif_pkg::*;

`timescale 1ns/1ps


//--------------------------------
//--
//--------------------------------
module hqm_core_ti #(parameter string ENV = "*") (
        axi_if  system_if_ptr,
        axi_if  m_axi_if_in,
        axi_if  m_axi_if_out,
        axi_if  m_axi_if_ppt_out,
        apb_if  m_apb_if,
        alarmintr_if m_alarmintr_if
);

  initial begin
    `sla_add_db_and_cfg(system_if_ptr,virtual axi_if,$psprintf("%m.SYSTEM_IF"),ENV,"system_if_name");

    //-- hqm_core AXI intf: ENQ
    `sla_add_db_and_cfg(m_axi_if_in,virtual axi_if,$psprintf("%m.ENQ_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_in.m_axi.master.monitor"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_in,virtual axi_if,$psprintf("%m.ENQ_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_in.m_axi.master.driver.write"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_in,virtual axi_if,$psprintf("%m.ENQ_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_in.m_axi.master.driver.read"},"if_name");

    //-- hqm_core AXI intf: SCHED
    `sla_add_db_and_cfg(m_axi_if_out,virtual axi_if,$psprintf("%m.SCH_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_out.m_axi.slave.monitor"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_out,virtual axi_if,$psprintf("%m.SCH_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_out.m_axi.slave.driver.write"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_out,virtual axi_if,$psprintf("%m.SCH_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_out.m_axi.slave.driver.read"},"if_name");

    //-- hqm_core AXI intf: PPT
    `sla_add_db_and_cfg(m_axi_if_ppt_out,virtual axi_if,$psprintf("%m.PUSH_PTR_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_out_ppt.m_axi.slave.monitor"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_ppt_out,virtual axi_if,$psprintf("%m.PUSH_PTR_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_out_ppt.m_axi.slave.driver.write"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_ppt_out,virtual axi_if,$psprintf("%m.PUSH_PTR_IF"),{ENV,".i_hcw_env.i_hcw_downstream_axi_out_ppt.m_axi.slave.driver.read"},"if_name");

    //-- hqm_core loopback axi
    `sla_add_db_and_cfg(m_axi_if_in,virtual axi_if,$psprintf("%m.ENQ_IF"),{ENV,".i_hqm_model.i_hqm_credit_hist_pipe_hcw_enq.slave.monitor"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_in,virtual axi_if,$psprintf("%m.ENQ_IF"),{ENV,".i_hqm_model.i_hqm_credit_hist_pipe_hcw_enq.slave.driver.write"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_in,virtual axi_if,$psprintf("%m.ENQ_IF"),{ENV,".i_hqm_model.i_hqm_credit_hist_pipe_hcw_enq.slave.driver.read"},"if_name");
      
    `sla_add_db_and_cfg(m_axi_if_out,virtual axi_if,$psprintf("%m.SCH_IF"),{ENV,".i_hqm_model.i_hqm_credit_hist_pipe_hcw_sch.master.monitor"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_out,virtual axi_if,$psprintf("%m.SCH_IF"),{ENV,".i_hqm_model.i_hqm_credit_hist_pipe_hcw_sch.master.driver.write"},"if_name");
    `sla_add_db_and_cfg(m_axi_if_out,virtual axi_if,$psprintf("%m.SCH_IF"),{ENV,".i_hqm_model.i_hqm_credit_hist_pipe_hcw_sch.master.driver.read"},"if_name");

    //-- APB intf
    `sla_add_db_and_cfg(m_apb_if,virtual apb_if,$psprintf("%m.CFG_IF"),{ENV,".i_hcw_env.i_hcw_downstream_apb_cfg.m_apb.master.driver"},"if_name");
    `sla_add_db_and_cfg(m_apb_if,virtual apb_if,$psprintf("%m.CFG_IF"),{ENV,".i_hcw_env.i_hcw_downstream_apb_cfg.m_apb.master.monitor"},"if_name");

    //-- Alarmintr intf
    `sla_add_db_and_cfg(m_alarmintr_if,virtual alarmintr_if,$psprintf("%m.ALARMINTR_IF"),{ENV,".i_hcw_env.i_alarmintr_env.agent.monitor"},"if_name");
    `sla_add_db_and_cfg(m_alarmintr_if,virtual alarmintr_if,$psprintf("%m.ALARMINTR_IF"),{ENV,".i_hcw_env.i_alarmintr_env.agent.driver"},"if_name");
  end
endmodule
 
