// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2018) (2018) Intel Corporation All Rights Reserved. 
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
// File   : hqm_sriov_enq_stress_seq.sv
//
// -----------------------------------------------------------------------------

`ifndef HQM_SRIOV_ENQ_STRESS_SEQ_SV
`define HQM_SRIOV_ENQ_STRESS_SEQ_SV

class hqm_sriov_enq_stress_seq extends hqm_base_seq;

    `ovm_sequence_utils(hqm_sriov_enq_stress_seq, sla_sequencer)

    hqm_pp_cq_base_seq dir_vf_0_pp_cq_4_seq;
    hqm_pp_cq_base_seq dir_vf_4_pp_cq_5_seq;
    hqm_pp_cq_base_seq dir_vf_8_pp_cq_6_seq;
    hqm_pp_cq_base_seq dir_vf_14_pp_cq_7_seq;

    hqm_pp_cq_base_seq ldb_vf_0_pp_cq_28_seq;
    hqm_pp_cq_base_seq ldb_vf_4_pp_cq_29_seq;
    hqm_pp_cq_base_seq ldb_vf_8_pp_cq_30_seq;
    hqm_pp_cq_base_seq ldb_vf_14_pp_cq_31_seq;
    hqm_pp_cq_base_seq ldb_vf_4_pp_cq_27_seq;

    function new(string name = "hqm_sriov_enq_stress_seq");
        super.new(name);
    endfunction

    virtual task body();

        //-- get i_hqm_cfg
        get_hqm_cfg();

        // -- PP/CQ traffic
        fork
            // -- LDB traffic
            begin #1ns;  start_pp_cq(.is_ldb(1), .pp_cq_index_in(28), .qtype(QUNO), .queue_list_size(1), .hcw_delay_in(32), .qid(31), .vf_num_val(0),  .pp_cq_seq(ldb_vf_0_pp_cq_28_seq)); end
            begin #11ns; start_pp_cq(.is_ldb(1), .pp_cq_index_in(29), .qtype(QORD), .queue_list_size(1), .hcw_delay_in(32), .qid(30), .vf_num_val(4),  .pp_cq_seq(ldb_vf_4_pp_cq_29_seq)); end
            begin #21ns; start_pp_cq(.is_ldb(1), .pp_cq_index_in(30), .qtype(QATM), .queue_list_size(1), .hcw_delay_in(32), .qid(29), .vf_num_val(8),  .pp_cq_seq(ldb_vf_8_pp_cq_30_seq)); end
            begin #31ns; start_pp_cq(.is_ldb(1), .pp_cq_index_in(31), .qtype(QUNO), .queue_list_size(1), .hcw_delay_in(32), .qid(28), .vf_num_val(14), .pp_cq_seq(ldb_vf_14_pp_cq_31_seq)); end
            begin #81ns; start_pp_cq(.is_ldb(1), .pp_cq_index_in(27), .qtype(QUNO), .queue_list_size(1), .hcw_delay_in(32), .qid(27), .vf_num_val(4),  .pp_cq_seq(ldb_vf_4_pp_cq_27_seq)); end

            // -- DIR traffic
            begin #41ns; start_pp_cq(.is_ldb(0), .pp_cq_index_in(4), .qtype(QDIR), .queue_list_size(1), .hcw_delay_in(32), .qid(0), .vf_num_val(0),  .pp_cq_seq(dir_vf_0_pp_cq_4_seq)); end
            begin #51ns; start_pp_cq(.is_ldb(0), .pp_cq_index_in(5), .qtype(QDIR), .queue_list_size(1), .hcw_delay_in(32), .qid(1), .vf_num_val(4),  .pp_cq_seq(dir_vf_4_pp_cq_5_seq)); end
            begin #61ns; start_pp_cq(.is_ldb(0), .pp_cq_index_in(6), .qtype(QDIR), .queue_list_size(1), .hcw_delay_in(32), .qid(2), .vf_num_val(8),  .pp_cq_seq(dir_vf_8_pp_cq_6_seq)); end
            begin #71ns; start_pp_cq(.is_ldb(0), .pp_cq_index_in(7), .qtype(QDIR), .queue_list_size(1), .hcw_delay_in(32), .qid(3), .vf_num_val(14), .pp_cq_seq(dir_vf_14_pp_cq_7_seq)); end
        join

    endtask

    virtual task start_pp_cq(bit is_ldb, int pp_cq_index_in, hcw_qtype qtype, int queue_list_size, int hcw_delay_in, bit [5:0] qid, bit [3:0] vf_num_val, output hqm_pp_cq_base_seq pp_cq_seq);
        logic [63:0]        cq_addr_val;
        int                 num_hcw_gen;
        int                 hcw_time_gen;
        string              pp_cq_prefix;
        string              qtype_str;
        bit [15:0]          lock_id;
        bit [15:0]          dsi;
        int                 batch_min;
        int                 batch_max;
        bit                 msix_mode;
        int                 cq_poll_int;
        int                 hcw_delay_max_in;
        bit [6:0]           pf_pp_cq_num;

        pf_pp_cq_num = i_hqm_cfg.get_pf_pp(1'b1, vf_num_val, is_ldb, pp_cq_index_in, 1'b1);
        cq_addr_val = get_cq_addr_val(e_port_type'(is_ldb), pf_pp_cq_num);

        if (is_ldb) begin
          pp_cq_prefix = "LDB";
        end else begin
          pp_cq_prefix = "DIR";
        end

        batch_min = 1;
        batch_max = 4;

        if ($value$plusargs({$psprintf("%s_VF%0d_PP%0d_HCW_DELAY",pp_cq_prefix, vf_num_val, pp_cq_index_in),"=%d"}, hcw_delay_in) == 0) begin
          $value$plusargs({$psprintf("%s_HCW_DELAY",pp_cq_prefix),"=%d"}, hcw_delay_in);
        end

        hcw_delay_max_in = hcw_delay_in;
        if ($value$plusargs({$psprintf("%s_VF%0d_PP%0d_HCW_DELAY_MAX",pp_cq_prefix, vf_num_val, pp_cq_index_in),"=%d"}, hcw_delay_max_in) == 0) begin
          $value$plusargs({$psprintf("%s_HCW_DELAY_MAX",pp_cq_prefix),"=%d"}, hcw_delay_max_in);
        end

        if ($value$plusargs({$psprintf("%s_VF%0d_PP%0d_BATCH_MIN",pp_cq_prefix, vf_num_val, pp_cq_index_in),"=%d"}, batch_min) == 0) begin
          $value$plusargs({$psprintf("%s_BATCH_MIN",pp_cq_prefix),"=%d"}, batch_min);
        end
        if ($value$plusargs({$psprintf("%s_VF%0d_PP%0d_BATCH_MAX",pp_cq_prefix, vf_num_val, pp_cq_index_in),"=%d"}, batch_max) == 0) begin
          $value$plusargs({$psprintf("%s_BATCH_MAX",pp_cq_prefix),"=%d"}, batch_max);
        end

        `ovm_create(pp_cq_seq)
        pp_cq_seq.set_name($psprintf("%s_VF%0d_PP%0d",pp_cq_prefix, vf_num_val, pp_cq_index_in));
        start_item(pp_cq_seq);
        if (!pp_cq_seq.randomize() with {
                         pp_cq_num                  == pp_cq_index_in;      // Producer Port/Consumer Queue number
                         pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                         queue_list.size()          == queue_list_size;

                         hcw_enqueue_batch_min      == batch_min;  // Minimum number of HCWs to send as a batch (1-4)
                         hcw_enqueue_batch_max      == batch_max;  // Maximum number of HCWs to send as a batch (1-4)

                         queue_list_delay_min       == hcw_delay_in;
                         queue_list_delay_max       == hcw_delay_max_in;

                         cq_addr                    == cq_addr_val;

                         cq_poll_interval           == 1;
                         is_vf                      == 1;
                         vf_num                     == vf_num_val;
                       } ) begin
          `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
        end

        lock_id = $urandom();
        if( $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_index_in),"=%d"}, lock_id) == 0) begin
          $value$plusargs({$psprintf("%s_LOCKID",pp_cq_prefix),"=%d"}, lock_id);
        end

        dsi = $urandom();
        if( $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_index_in),"=%d"}, dsi) == 0) begin
          $value$plusargs({$psprintf("%s_DSI",pp_cq_prefix),"=%d"}, dsi);
        end

        case (qtype_str)
          "qdir": qtype = QDIR;
          "quno": qtype = QUNO;
          "qatm": qtype = QATM;
          "qord": qtype = QORD;
        endcase

        for (int i = 0 ; i < queue_list_size ; i++) begin
          num_hcw_gen = 0;
          if ($value$plusargs({$psprintf("%s_VF%0d_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix, vf_num_val, pp_cq_index_in, i),"=%d"}, num_hcw_gen) == 0) begin
            $value$plusargs({$psprintf("%s_NUM_HCW",pp_cq_prefix),"=%d"}, num_hcw_gen);
          end

          hcw_time_gen      = 0;
          if ($value$plusargs({$psprintf("%s_PP%0d_Q%0d_HCW_TIME",pp_cq_prefix,pp_cq_index_in,i),"=%d"}, hcw_time_gen) == 0) begin
            $value$plusargs({$psprintf("%s_HCW_TIME",pp_cq_prefix),"=%d"}, hcw_time_gen);
          end

          if ((hcw_time_gen > 0) && (num_hcw_gen == 0)) begin
            num_hcw_gen = 1;
          end

          pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;
          pp_cq_seq.queue_list[i].hcw_time                  = hcw_time_gen;
          pp_cq_seq.queue_list[i].qid                       = qid + i;
          pp_cq_seq.queue_list[i].qtype                     = qtype;
          pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
          pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_in * queue_list_size;
          pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max_in * queue_list_size;
          pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
          pp_cq_seq.queue_list[i].lock_id                   = lock_id;
          pp_cq_seq.queue_list[i].dsi                       = dsi;
          pp_cq_seq.queue_list[i].comp_flow                 = 1;
          pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
          pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;

        end

        finish_item(pp_cq_seq);
    endtask

endclass

`endif //HQM_SRIOV_ENQ_STRESS_SEQ_SV
