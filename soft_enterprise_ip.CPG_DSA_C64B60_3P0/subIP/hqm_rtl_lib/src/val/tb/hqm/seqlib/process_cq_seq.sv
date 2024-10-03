// -----------------------------------------------------------------------------
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
// -----------------------------------------------------------------------------
// File   : process_cq_seq.sv
//
// Description :
//
// -----------------------------------------------------------------------------
`ifndef PROCESS_CQ_SEQ__SV
`define PROCESS_CQ_SEQ__SV

import hqm_tb_cfg_pkg::*;

class process_cq_seq extends ovm_sequence;
  `ovm_sequence_utils(process_cq_seq, sla_sequencer)

    hqm_tb_cfg          i_hqm_cfg;
    pp_cq_model_seq     i_dir_pp_cq_model[128];
    pp_cq_model_seq     i_ldb_pp_cq_model[64];

  function new(string name = "process_cq_seq");
     super.new(name);
  endfunction: new;

  task set_pp_cq_model();
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_data_t      ral_data;

    string name = "";
    int qsize, pp_en, cq_en;
    logic [63:0]        cq_addr_val;

    if (!$cast(ral, sla_ral_env::get_ptr())) 
      ovm_report_fatal(get_name(), "Unable to get RAL handle");

    foreach(i_hqm_cfg.dir_pp_cq_cfg[i])begin
        qsize = 1;

        name = $psprintf("dir_pp_%0d",i);
        pp_en = i_hqm_cfg.dir_pp_cq_cfg[i].pp_enable;
        cq_en = i_hqm_cfg.dir_pp_cq_cfg[i].cq_enable;
        if( cq_en == 1)begin
            bit is_vf   = (i_hqm_cfg.dir_pp_cq_cfg[i].vpp == -1) ? 0 : 1;
            int vf_num  = i_hqm_cfg.dir_pp_cq_cfg[i].vf;
            int vpp     = i_hqm_cfg.dir_pp_cq_cfg[i].vpp;
            int q_depth = i_hqm_cfg.dir_pp_cq_cfg[i].cq_depth;
            q_depth    = ((q_depth > 8) || (q_depth == 0)) ? 1 : q_depth;
            q_depth    = (8 * $pow(2, (q_depth - 1)));
            cq_addr_val = i_hqm_cfg.dir_pp_cq_cfg[i].cq_gpa;

            `ovm_info("process_cq_seq", $psprintf("Craeting sequence <%s>", name), OVM_LOW)
            i_dir_pp_cq_model[i] = pp_cq_model_seq::type_id::create(name);

            `ovm_info("process_cq_seq", $psprintf("Starting sequence <%s>", name), OVM_LOW)
            i_dir_pp_cq_model[i].start(get_sequencer());

            `ovm_info("process_cq_seq", $psprintf("Randomizing sequence <%s>", name), OVM_LOW)
            assert(i_dir_pp_cq_model[i].randomize() with {
            i_dir_pp_cq_model[i].pp_cq_num        == i;
            i_dir_pp_cq_model[i].pp_cq_type       == hqm_pp_cq_base_seq::IS_DIR;
            i_dir_pp_cq_model[i].is_vf            == is_vf;
            i_dir_pp_cq_model[i].vf_num           == vf_num;
            i_dir_pp_cq_model[i].vpp              == vpp;
            i_dir_pp_cq_model[i].cq_addr          == cq_addr_val;
            i_dir_pp_cq_model[i].cq_depth         == q_depth;
            i_dir_pp_cq_model[i].queue_list.size  == qsize;
            i_dir_pp_cq_model[i].queue_list_delay_min   == 10;
            i_dir_pp_cq_model[i].queue_list_delay_max   == 100;
            i_dir_pp_cq_model[i].cq_poll_interval       == 10;
             });


            i_dir_pp_cq_model[i].queue_list[0].num_hcw                   = 0;
            i_dir_pp_cq_model[i].queue_list[0].qid                       = i;
            i_dir_pp_cq_model[i].queue_list[0].qtype                     = QDIR;
            i_dir_pp_cq_model[i].queue_list[0].comp_flow                 = 0;
            i_dir_pp_cq_model[i].queue_list[0].cq_token_return_flow      = 1;
            i_dir_pp_cq_model[i].queue_list[0].qpri_weight[0]            = 1;
            i_dir_pp_cq_model[i].queue_list[0].hcw_delay_min             = $urandom_range(20,1);
            i_dir_pp_cq_model[i].queue_list[0].hcw_delay_max             = $urandom_range(40, 20);
            i_dir_pp_cq_model[i].queue_list[0].hcw_delay_qe_only         = 1'b1;
            i_dir_pp_cq_model[i].queue_list[0].lock_id                   = 16'h4001;
            i_dir_pp_cq_model[i].queue_list[0].dsi                       = 16'h0100;
            i_dir_pp_cq_model[i].queue_list[0].illegal_hcw_burst_len     = 0;
            i_dir_pp_cq_model[i].queue_list[0].illegal_hcw_prob          = 0;


            #0;
        end
    end

    foreach(i_hqm_cfg.ldb_pp_cq_cfg[i])begin
        bit is_vf   = (i_hqm_cfg.ldb_pp_cq_cfg[i].vpp == -1) ? 0 : 1;
        int vf_num  = i_hqm_cfg.ldb_pp_cq_cfg[i].vf;
        int vpp     = i_hqm_cfg.ldb_pp_cq_cfg[i].vpp;
        int q_depth = i_hqm_cfg.ldb_pp_cq_cfg[i].cq_depth;
        int j = 0;
        q_depth    = ((q_depth > 8) || (q_depth == 0)) ? 1 : q_depth;
        q_depth    = (8 * $pow(2,(q_depth - 1)));
        qsize = 0;
        name = $psprintf("ldb_pp_%0d",i);
        pp_en = i_hqm_cfg.ldb_pp_cq_cfg[i].pp_enable;
        cq_en = i_hqm_cfg.ldb_pp_cq_cfg[i].cq_enable;
        if(( pp_en == 1) || ( cq_en == 1))begin
            if(i_hqm_cfg.ldb_pp_cq_cfg[i].cq_enable == 1) begin
                for (int idx = 0 ; idx < 8 ; idx++)
                    if (i_hqm_cfg.ldb_pp_cq_cfg[i].qidix[idx].qidv)
                        qsize ++;
            end

            cq_addr_val = i_hqm_cfg.ldb_pp_cq_cfg[i].cq_gpa;

            i_ldb_pp_cq_model[i] = pp_cq_model_seq::type_id::create(name);
            i_ldb_pp_cq_model[i].start(get_sequencer());

            assert(i_ldb_pp_cq_model[i].randomize() with {
            i_ldb_pp_cq_model[i].pp_cq_num        == i;
            i_ldb_pp_cq_model[i].pp_cq_type       == hqm_pp_cq_base_seq::IS_LDB;
            i_ldb_pp_cq_model[i].is_vf            == is_vf;
            i_ldb_pp_cq_model[i].vf_num           == vf_num;
            i_ldb_pp_cq_model[i].vpp              == vpp;
            i_ldb_pp_cq_model[i].cq_addr          == cq_addr_val;
            i_ldb_pp_cq_model[i].cq_depth         == q_depth;
            i_ldb_pp_cq_model[i].queue_list.size  == qsize;
            i_ldb_pp_cq_model[i].queue_list_delay_min   == 10;
            i_ldb_pp_cq_model[i].queue_list_delay_max   == 100;
            i_ldb_pp_cq_model[i].cq_poll_interval       == 10;
             });

            for (int idx = 0 ; idx < 8 ; idx++)
            if (i_hqm_cfg.ldb_pp_cq_cfg[i].qidix[idx].qidv)begin
                i_ldb_pp_cq_model[i].queue_list[j].num_hcw                   = 0;
                i_ldb_pp_cq_model[i].queue_list[j].qid                       = i_hqm_cfg.ldb_pp_cq_cfg[i].qidix[idx].qid;
                i_ldb_pp_cq_model[i].queue_list[j].qtype                     = QUNO;
                i_ldb_pp_cq_model[i].queue_list[j].comp_flow                 = 1;
                i_ldb_pp_cq_model[i].queue_list[j].cq_token_return_flow      = 1;
                i_ldb_pp_cq_model[i].queue_list[j].qpri_weight[0]            = 1;
                i_ldb_pp_cq_model[i].queue_list[j].hcw_delay_min             = $urandom_range(20,1);
                i_ldb_pp_cq_model[i].queue_list[j].hcw_delay_max             = $urandom_range(40, 20);
                i_ldb_pp_cq_model[i].queue_list[j].hcw_delay_qe_only         = 1'b1;
                i_ldb_pp_cq_model[i].queue_list[j].lock_id                   = 16'h4001;
                i_ldb_pp_cq_model[i].queue_list[j].dsi                       = 16'h0100;
                i_ldb_pp_cq_model[i].queue_list[j].illegal_hcw_burst_len     = 0;
                i_ldb_pp_cq_model[i].queue_list[j].illegal_hcw_prob          = 0;
                j ++;
            end

            #0;
         end 
    end
  endtask: set_pp_cq_model;

  task body();
    if(i_hqm_cfg == null)
        $cast(i_hqm_cfg, hqm_tb_cfg::get());

    if (i_hqm_cfg == null)
        ovm_report_fatal(get_full_name(), $psprintf("Failed to get hqm_tb_cfg object"));

    set_pp_cq_model();

    `ovm_info("process_cq_seq", $psprintf("Spawning all sequences"), OVM_LOW)
    foreach(i_dir_pp_cq_model[i]) if(i_dir_pp_cq_model[i] != null)begin fork
        finish_item(i_dir_pp_cq_model[i]);
        join_none
        #0;
     end

    foreach(i_ldb_pp_cq_model[i]) if(i_ldb_pp_cq_model[i] != null)begin fork
        finish_item(i_ldb_pp_cq_model[i]);
        join_none
        #0;
    end

    wait fork;

  endtask: body;

endclass: process_cq_seq;
`endif
