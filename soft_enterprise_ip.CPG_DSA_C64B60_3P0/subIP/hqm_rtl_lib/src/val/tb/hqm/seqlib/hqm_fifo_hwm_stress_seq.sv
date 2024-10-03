// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2019) (2019) Intel Corporation All Rights Reserved. 
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

`include "stim_config_macros.svh"

class hqm_fifo_hwm_stress_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_fifo_hwm_stress_seq_stim_config";

  `ovm_object_utils_begin(hqm_fifo_hwm_stress_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(hwm_stress_rand_en,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_string(hwm_stress_en_q,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(hwm_stress_hwm_q,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_fifo_hwm_stress_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(hwm_stress_rand_en)
    `stimulus_config_field_queue_string(hwm_stress_en_q)
    `stimulus_config_field_queue_int(hwm_stress_hwm_q)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        hwm_stress_en_q[$];
  int                           hwm_stress_hwm_q[$];

  rand  int                     hwm_stress_rand_en;

  constraint c_hwm_stress_rand_en {
    soft hwm_stress_rand_en             == 0;
  }

  function new(string name = "hqm_fifo_hwm_stress_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_fifo_hwm_stress_seq_stim_config

class hqm_fifo_hwm_stress_seq extends hqm_base_cfg_seq;

    `ovm_sequence_utils(hqm_fifo_hwm_stress_seq, sla_sequencer)

    rand hqm_fifo_hwm_stress_seq_stim_config       cfg;

    `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_fifo_hwm_stress_seq_stim_config);

    typedef struct {
      string    file_name;
      string    reg_name;
      string    field_name;
      int       min_hwm;
      int       max_hwm;
      int       stress_hwm;
      bit       en_stress;
    } hwm_stress_item_t;

    hwm_stress_item_t   hwm_stress_items[$];

    function new(string name = "hqm_fifo_hwm_stress_seq");
      hwm_stress_item_t hwm_stress_item;

      super.new(name);

      // hqm_sif_csr
      hwm_stress_item = '{"hqm_sif_csr", "ri_phdr_fifo_ctl", "high_wm", 1, 15, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"hqm_sif_csr", "ri_pdata_fifo_ctl", "high_wm", 1, 31, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"hqm_sif_csr", "ri_nphdr_fifo_ctl", "high_wm", 1, 7, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"hqm_sif_csr", "ri_npdata_fifo_ctl", "high_wm", 1, 7, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"hqm_sif_csr", "ri_ioq_fifo_ctl", "high_wm", 1, 255, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      // hqm_system_csr
      hwm_stress_item = '{"hqm_system_csr", "hcw_enq_fifo_ctl", "high_wm", 1, 255, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"hqm_system_csr", "sch_out_fifo_ctl", "high_wm", 1, 127, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"hqm_system_csr", "sif_alarm_fifo_ctl", "high_wm", 1, 3, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      // direct_pipe
      hwm_stress_item = '{"direct_pipe", "cfg_fifo_wmstat_dp_lsp_enq_rorply_if", "fifo_hwm", 1, 13, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"direct_pipe", "cfg_fifo_wmstat_lsp_dp_sch_dir_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"direct_pipe", "cfg_fifo_wmstat_lsp_dp_sch_rorply_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"direct_pipe", "cfg_fifo_wmstat_rop_dp_enq_dir_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"direct_pipe", "cfg_fifo_wmstat_rop_dp_enq_ro_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      // nalb_pipe
      hwm_stress_item = '{"nalb_pipe", "cfg_fifo_wmstat_lsp_nalb_sch_atq_if", "fifo_hwm", 1, 29, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"nalb_pipe", "cfg_fifo_wmstat_lsp_nalb_sch_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"nalb_pipe", "cfg_fifo_wmstat_lsp_nalb_sch_rorply_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"nalb_pipe", "cfg_fifo_wmstat_nalb_lsp_enq_rorply_if", "fifo_hwm", 1, 29, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"nalb_pipe", "cfg_fifo_wmstat_rop_nalb_enq_ro_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"nalb_pipe", "cfg_fifo_wmstat_rop_nalb_enq_uno_ord_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      // atm_pipe
      hwm_stress_item = '{"atm_pipe", "cfg_fifo_wmstat_ap_aqed_if", "fifo_hwm", 1, 16, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"atm_pipe", "cfg_fifo_wmstat_ap_lsp_enq_if", "fifo_hwm", 1, 15, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"atm_pipe", "cfg_fifo_wmstat_aqed_ap_enq_if", "fifo_hwm", 1, 24, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      // aqed_pipe
      hwm_stress_item = '{"aqed_pipe", "cfg_fifo_wmstat_ap_aqed_if", "fifo_hwm", 1, 16, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"aqed_pipe", "cfg_fifo_wmstat_aqed_ap_enq_if", "fifo_hwm", 1, 16, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"aqed_pipe", "cfg_fifo_wmstat_aqed_chp_sch_if", "fifo_hwm", 1, 16, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"aqed_pipe", "cfg_fifo_wmstat_freelist_return", "fifo_hwm", 1, 16, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"aqed_pipe", "cfg_fifo_wmstat_lsp_aqed_cmp_fid_if", "fifo_hwm", 1, 16, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"aqed_pipe", "cfg_fifo_wmstat_qed_aqed_enq_fid_if", "fifo_hwm", 1, 8, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"aqed_pipe", "cfg_fifo_wmstat_qed_aqed_enq_if", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      // reorder_pipe
      hwm_stress_item = '{"reorder_pipe", "cfg_fifo_wmstat_chp_rop_hcw", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"reorder_pipe", "cfg_fifo_wmstat_dir_rply_req", "fifo_hwm", 1, 6, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"reorder_pipe", "cfg_fifo_wmstat_ldb_rply_req", "fifo_hwm", 1, 6, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"reorder_pipe", "cfg_fifo_wmstat_lsp_reordercmp", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"reorder_pipe", "cfg_fifo_wmstat_sn_complete", "fifo_hwm", 1, 4, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      hwm_stress_item = '{"reorder_pipe", "cfg_fifo_wmstat_sn_ordered", "fifo_hwm", 1, 24, 1, 1'b0};
      hwm_stress_items.push_back(hwm_stress_item);

      cfg = hqm_fifo_hwm_stress_seq_stim_config::type_id::create("hqm_fifo_hwm_stress_seq_stim_config");
      apply_stim_config_overrides(0);

    endfunction

    virtual task body();
      string            fifo_str;
      string            explode_q[$];
      int               qi[$];
      int               fifo_index;
      string            hwm_val_str;

      apply_stim_config_overrides(1);

      foreach (cfg.hwm_stress_en_q[i]) begin
        explode_q.delete();
        lvm_common_pkg::explode(".",cfg.hwm_stress_en_q[i],explode_q);

        if (explode_q.size() == 2) begin
          qi = hwm_stress_items.find_index with ((item.file_name == explode_q[0]) && (item.reg_name == explode_q[1]));

          if (qi.size() == 1) begin
            hwm_stress_items[qi[0]].en_stress = 1'b1;
            if (i < cfg.hwm_stress_hwm_q.size()) begin
              hwm_stress_items[qi[0]].stress_hwm = cfg.hwm_stress_hwm_q[i];
            end
          end else begin
            `ovm_error(get_full_name(),$psprintf("Fifo reference not found with +hqm_fifo_hwm_stress_seq_stim_confg::=%s argument",
                                                 cfg.hwm_stress_en_q[i]))
          end
        end else begin
          `ovm_error(get_full_name(),$psprintf("Illegal +hqm_fifo_hwm_stress_seq_stim_confg::hwm_stress_en_q=%s argument",
                                               cfg.hwm_stress_en_q[i]))
        end
      end

      if (cfg.hwm_stress_rand_en) begin
        int index;

        index = $urandom_range(hwm_stress_items.size()-1,0);

        hwm_stress_items[index].en_stress = 1;
      end

      foreach (hwm_stress_items[i]) begin
        if (hwm_stress_items[i].en_stress) begin
          `ovm_info(get_full_name(),$psprintf("FIFO HWM Stress  enabled - %s.%s hwm=%d",
                                              hwm_stress_items[i].file_name,hwm_stress_items[i].reg_name,hwm_stress_items[i].stress_hwm),OVM_LOW)

          cfg_cmds.push_back($psprintf("wr %s.%s.%s %d",
                                       hwm_stress_items[i].file_name,
                                       hwm_stress_items[i].reg_name,
                                       hwm_stress_items[i].field_name,
                                       hwm_stress_items[i].stress_hwm));
        end
      end

      super.body();
    endtask

endclass
