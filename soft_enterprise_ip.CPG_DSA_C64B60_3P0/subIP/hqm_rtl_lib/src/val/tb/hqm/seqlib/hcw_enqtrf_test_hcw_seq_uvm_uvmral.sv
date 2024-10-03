import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

//---------------------------------------------------------------------
//---------------------------------------------------------------------
class hcw_enqtrf_test_hcw_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_enqtrf_test_hcw_seq_stim_config";

  `uvm_object_utils_begin(hcw_enqtrf_test_hcw_seq_stim_config)
    `uvm_field_string(tb_env_hier,                      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(inst_suffix,                      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(num_ldb_pp,            UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(num_dir_pp,            UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(enable_msix,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(enable_ims_poll,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_batch_min,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_batch_max,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_num_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_num_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_pad_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_pad_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_shuffle_min,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_shuffle_max,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cl_pad,                          UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_batch_min,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_batch_max,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_num_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_num_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_pad_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_pad_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_shuffle_min,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_shuffle_max,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cl_pad,                          UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ctl_cq_base_addr,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cq_base_addr,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cq_base_addr,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cq_space,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cq_space,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_cq_addr_q,                 UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_cq_addr_q,                 UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_cq_hpa_addr_q,             UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_cq_hpa_addr_q,             UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_cq_intr_remap_addr_q,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_cq_intr_remap_addr_q,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_enqtrf_test_hcw_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(num_ldb_pp)
    `stimulus_config_field_rand_int(num_dir_pp)
    `stimulus_config_field_rand_int(enable_msix)
    `stimulus_config_field_rand_int(enable_ims_poll)

    `stimulus_config_field_rand_int(dir_batch_min)
    `stimulus_config_field_rand_int(dir_batch_max)
    `stimulus_config_field_rand_int(dir_cacheline_max_num_min)
    `stimulus_config_field_rand_int(dir_cacheline_max_num_max)
    `stimulus_config_field_rand_int(dir_cacheline_max_pad_min)
    `stimulus_config_field_rand_int(dir_cacheline_max_pad_max)
    `stimulus_config_field_rand_int(dir_cacheline_max_shuffle_min)
    `stimulus_config_field_rand_int(dir_cacheline_max_shuffle_max)
    `stimulus_config_field_rand_int(dir_cl_pad)
    `stimulus_config_field_rand_int(ldb_batch_min)
    `stimulus_config_field_rand_int(ldb_batch_max)
    `stimulus_config_field_rand_int(ldb_cacheline_max_num_min)
    `stimulus_config_field_rand_int(ldb_cacheline_max_num_max)
    `stimulus_config_field_rand_int(ldb_cacheline_max_pad_min)
    `stimulus_config_field_rand_int(ldb_cacheline_max_pad_max)
    `stimulus_config_field_rand_int(ldb_cacheline_max_shuffle_min)
    `stimulus_config_field_rand_int(ldb_cacheline_max_shuffle_max)
    `stimulus_config_field_rand_int(ldb_cl_pad)

    `stimulus_config_field_int(ctl_cq_base_addr)
    `stimulus_config_field_int(dir_cq_base_addr)
    `stimulus_config_field_int(ldb_cq_base_addr)
    `stimulus_config_field_int(dir_cq_space)
    `stimulus_config_field_int(ldb_cq_space)
    `stimulus_config_field_queue_int(dir_cq_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_addr_q)
    `stimulus_config_field_queue_int(dir_cq_hpa_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_hpa_addr_q)
    `stimulus_config_field_queue_int(dir_cq_intr_remap_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_intr_remap_addr_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  int                     num_ldb_pp;
  rand  int                     num_dir_pp;
  rand  bit                     enable_msix;
  rand  bit                     enable_ims_poll;

  rand  int                     dir_batch_min;
  rand  int                     dir_batch_max;

  rand  int                     dir_cacheline_max_num_min;     
  rand  int                     dir_cacheline_max_num_max;     
  rand  int                     dir_cacheline_max_pad_min;     
  rand  int                     dir_cacheline_max_pad_max;     
  rand  int                     dir_cacheline_max_shuffle_min;     
  rand  int                     dir_cacheline_max_shuffle_max;     
  rand  int                     dir_cl_pad;

  rand  int                     ldb_batch_min;
  rand  int                     ldb_batch_max;
  rand  int                     ldb_cacheline_max_num_min;     
  rand  int                     ldb_cacheline_max_num_max;     
  rand  int                     ldb_cacheline_max_pad_min;     
  rand  int                     ldb_cacheline_max_pad_max;     
  rand  int                     ldb_cacheline_max_shuffle_min;     
  rand  int                     ldb_cacheline_max_shuffle_max;     
  rand  int                     ldb_cl_pad;

  int                           ctl_cq_base_addr=0;
  bit [63:0]                    dir_cq_base_addr = 64'h00000001_23450000;
  bit [63:0]                    ldb_cq_base_addr = 64'h00000006_789a0000;
  bit [15:0]                    dir_cq_space = 16'h4000;
  bit [15:0]                    ldb_cq_space = 16'h4000;

  bit [63:0]                    dir_cq_addr_q[$];
  bit [63:0]                    ldb_cq_addr_q[$];

  bit [63:0]                    dir_cq_hpa_addr_q[$];
  bit [63:0]                    ldb_cq_hpa_addr_q[$];

  bit [63:0]                    dir_cq_intr_remap_addr_q[$];
  bit [63:0]                    ldb_cq_intr_remap_addr_q[$];

  constraint c_num_pp {
    num_ldb_pp                  >= 0;
    num_ldb_pp                  <= hqm_pkg::NUM_LDB_PP;
    num_ldb_pp                  <= hqm_pkg::NUM_LDB_QID;
    num_dir_pp                  >= 0;
    num_dir_pp                  <= hqm_pkg::NUM_DIR_PP;
    num_dir_pp                  <= hqm_pkg::NUM_DIR_QID;
    (num_ldb_pp + num_dir_pp)   >  0;
    (num_ldb_pp + num_dir_pp)   <= (hqm_pkg::NUM_DIR_PP + hqm_pkg::NUM_LDB_PP);
  }

  constraint c_msix_soft {
    soft enable_msix       == 0;
  }

  constraint c_ims_poll_soft {
    soft enable_ims_poll   == 0;
  }

  constraint c_dir_batch {
    dir_batch_min >= 1;
    dir_batch_min <= 4;

    dir_batch_max >= 1;
    dir_batch_max <= 4;

    dir_batch_min <= dir_batch_max;
  }

  constraint c_dir_max_cacheline_ctrl {
    dir_cacheline_max_num_min == 1;
    dir_cacheline_max_num_max == 1;
    dir_cacheline_max_pad_min == 0;
    dir_cacheline_max_pad_max == 0;
    dir_cacheline_max_shuffle_min == 0;
    dir_cacheline_max_shuffle_max == 0;
  }

  constraint c_ldb_batch {
    ldb_batch_min >= 1;
    ldb_batch_min <= 4;

    ldb_batch_max >= 1;
    ldb_batch_max <= 4;

    ldb_batch_min <= ldb_batch_max;
  }

  constraint c_ldb_max_cacheline_ctrl {
    ldb_cacheline_max_num_min == 1;
    ldb_cacheline_max_num_max == 1;
    ldb_cacheline_max_pad_min == 0;
    ldb_cacheline_max_pad_max == 0;
    ldb_cacheline_max_shuffle_min == 0;
    ldb_cacheline_max_shuffle_max == 0;
  }

  constraint c_cl_pad_soft {
    soft ldb_cl_pad == 0;
    soft dir_cl_pad == 0;
  }

  function new(string name = "hcw_enqtrf_test_hcw_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_enqtrf_test_hcw_seq_stim_config

//---------------------------------------------------------------------
//---------------------------------------------------------------------
`ifdef IP_TYP_TE
class hcw_enqtrf_test_hcw_seq extends hqm_base_seq;
`else
class hcw_enqtrf_test_hcw_seq extends slu_sequence_base;
`endif

  `uvm_object_utils(hcw_enqtrf_test_hcw_seq) 

  `uvm_declare_p_sequencer(slu_sequencer)


  rand hcw_enqtrf_test_hcw_seq_stim_config  cfg;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_enqtrf_test_hcw_seq_stim_config);
`endif


  hqm_cfg               i_hqm_cfg;
  hqm_tb_hcw_scoreboard i_hcw_scoreboard;
  hqm_pp_cq_status      i_hqm_pp_cq_status;

  hqm_pp_cq_base_seq    ldb_pp_cq_0_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_1_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_2_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_3_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_4_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_5_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_6_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_7_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_8_seq;
  hqm_pp_cq_base_seq    ldb_pp_cq_9_seq;
    
  hqm_pp_cq_base_seq    dir_pp_cq_0_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_1_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_2_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_3_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_4_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_5_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_6_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_7_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_8_seq;
  hqm_pp_cq_base_seq    dir_pp_cq_9_seq;
    

  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_0_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_1_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_2_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_3_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_4_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_5_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_6_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_7_seq;  
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_8_seq;
  hqm_pp_cq_hqmproc_seq    ldb_pp_cq_hqmproc_9_seq;  
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_0_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_1_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_2_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_3_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_4_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_5_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_6_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_7_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_8_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_9_seq;
  
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_62_seq;
  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_63_seq;

//  hqm_pp_cq_hqmproc_seq    dir_pp_cq_hqmproc_95_seq;

  hqm_pp_cq_base_seq       dir_trf_pp_cq_seq[hqm_pkg::NUM_DIR_CQ];
  hqm_pp_cq_base_seq       ldb_trf_pp_cq_seq[hqm_pkg::NUM_LDB_CQ];
  
  hqm_pp_cq_hqmproc_seq    dir_trf_pp_cq_hqmproc_seq[hqm_pkg::NUM_DIR_CQ];
  hqm_pp_cq_hqmproc_seq    ldb_trf_pp_cq_hqmproc_seq[hqm_pkg::NUM_LDB_CQ]; 

 `ifdef IP_TYP_TE
  hqm_background_cfg_file_mode_seq      bg_cfg_seq;
 `endif
 
  int                   has_bgcfg_enable;
  int                   bgcfg_waitnum;
  int                   bgcfg_loopnum;
       
  int                   has_cqirq_unmask_enable;
  int                   has_cqirq_mask_enable;
  int                   has_cqirq_mask_idleck;
  int                   has_cqirq_mask_waitnum;
  int                   has_cqirq_mask_loopwaitnum;
  int                   cqirq_mask_unmask_loop;

  int                   has_cqirq_maskunmask_paral;
  int                   has_cqirq_unmask_paral_ena;
  int                   has_cqirq_mask_paral_ena;

  int                   has_hwerrinj_enable;
  int                   hwerrinj_waitnum;
  int                   hwerrinj_loopnum;
  int                   has_hwerrinj_scherr_check;

  int                   has_force_stop_enable;
  int                   has_force_stop_loop;
  int                   has_force_stop_waitnum;

  int                   has_surv_enable;
  int                   has_surv_delayclkoff_enable;
  int                   has_surv_csw_enable;
  int                   has_surv_plcrd_enable;
  int                   has_surv_lsp_ctrl_enable;
  int                   has_surv_sys_ctrl_enable;
  int                   has_surv_fifo_hwm_enable;
  int                   has_surv_lsp_wb_ctrl_enable;

  int                   has_surv_ctrl_sel;
  int                   has_surv_csw_ctrl_sel;
  int                   has_surv_pipeline_credit_sel;
  int                   has_surv_lsp_control_general0_sel;
  int                   has_surv_hqm_system_ctrl_sel;
  int                   has_surv_fifo_hwm_ctrl_sel;
  int                   has_surv_disable_wb;

  int                   has_sys_qidits_enable; 
  int                   has_sys_pasid_enable; 
  int                   has_sys_rob_ctrl; 
  int                   has_vas_credit_reprog; 

  int                   has_sys_aocfg_ctrl; 

  int                   has_lsp_cq_pcq_enable;
  int                   has_lsp_qidthreshold_enable;
  int                   has_lsp_coscfg_enable;
  int                   has_lsp_cosrecfg_enable;
  int                   has_lsp_cosrecfg_waitnum;
  int                   has_lsp_cosrecfg_hcwnum;

  int                   ldb_pp_cq_0_loopnum;

  int                   ldb_pp_cq_0_waitnum;
  int                   ldb_pp_cq_1_waitnum;
  int                   ldb_pp_cq_2_waitnum;
  int                   ldb_pp_cq_3_waitnum;
  int                   ldb_pp_cq_4_waitnum;
  int                   ldb_pp_cq_5_waitnum;
  int                   ldb_pp_cq_6_waitnum;
  int                   ldb_pp_cq_7_waitnum;  
  int                   ldb_pp_cq_8_waitnum;
  int                   ldb_pp_cq_9_waitnum;  
  int                   dir_pp_cq_0_waitnum;
  int                   dir_pp_cq_1_waitnum;          
  int                   dir_pp_cq_2_waitnum;
  int                   dir_pp_cq_3_waitnum;       
  int                   dir_pp_cq_4_waitnum;
  int                   dir_pp_cq_5_waitnum;          
  int                   dir_pp_cq_6_waitnum;
  int                   dir_pp_cq_7_waitnum;   
  int                   dir_pp_cq_8_waitnum;
  int                   dir_pp_cq_9_waitnum;   
  
  int                   ldb_pp_cq_0_rtnwaitnum;
  int                   ldb_pp_cq_1_rtnwaitnum;
  int                   ldb_pp_cq_2_rtnwaitnum;
  int                   ldb_pp_cq_3_rtnwaitnum;
  int                   ldb_pp_cq_4_rtnwaitnum;
  int                   ldb_pp_cq_5_rtnwaitnum;
  int                   ldb_pp_cq_6_rtnwaitnum;
  int                   ldb_pp_cq_7_rtnwaitnum;  
  int                   ldb_pp_cq_8_rtnwaitnum;
  int                   ldb_pp_cq_9_rtnwaitnum;  
  int                   dir_pp_cq_0_rtnwaitnum;
  int                   dir_pp_cq_1_rtnwaitnum;
  int                   dir_pp_cq_2_rtnwaitnum;
  int                   dir_pp_cq_3_rtnwaitnum;  
  int                   dir_pp_cq_4_rtnwaitnum;
  int                   dir_pp_cq_5_rtnwaitnum;
  int                   dir_pp_cq_6_rtnwaitnum;
  int                   dir_pp_cq_7_rtnwaitnum;  
  int                   dir_pp_cq_8_rtnwaitnum;
  int                   dir_pp_cq_9_rtnwaitnum;  
           
  int                   ldb_pp_cq_rtnwaitnum;

  int                   ldb_pp_cq_0_qidin;
  int                   ldb_pp_cq_1_qidin;
  int                   ldb_pp_cq_2_qidin;
  int                   ldb_pp_cq_3_qidin;
  int                   ldb_pp_cq_4_qidin;
  int                   ldb_pp_cq_5_qidin;
  int                   ldb_pp_cq_6_qidin;
  int                   ldb_pp_cq_7_qidin;  
  int                   ldb_pp_cq_8_qidin;
  int                   ldb_pp_cq_9_qidin;  
  int                   dir_pp_cq_0_qidin;
  int                   dir_pp_cq_1_qidin;
  int                   dir_pp_cq_2_qidin;
  int                   dir_pp_cq_3_qidin;  
  int                   dir_pp_cq_4_qidin;
  int                   dir_pp_cq_5_qidin;
  int                   dir_pp_cq_6_qidin;
  int                   dir_pp_cq_7_qidin;  
  int                   dir_pp_cq_8_qidin;
  int                   dir_pp_cq_9_qidin; 

  int                   waitnum_min, waitnum_max, waitnum;
  
  //-- support scenario2
  int                   has_ldb_pp_cq_2_trf_scen2;    
  int                   has_ldb_pp_cq_3_trf_scen2;    
  int                   has_ldb_pp_cq_4_trf_scen2;    
  int                   has_ldb_pp_cq_5_trf_scen2;    
  int                   has_ldb_pp_cq_6_trf_scen2;    
  int                   has_ldb_pp_cq_7_trf_scen2;    

  int                   has_ldb_pp_cq_trf_2stage;    
  int                   has_ldb_pp_cq_trf_2cont;    

  int                   has_dir_pp_cq_trf_2stage;    
  int                   has_dir_pp_cq_trf_2cont;    

  int                   has_ldb_cqdisable_min;
  int                   has_ldb_cqdisable_max;
  int                   has_dir_cqdisable_min;
  int                   has_dir_cqdisable_max;

  int                   has_ldb_pp_cq_trf_scen2;    
  int                   has_ldb_cqrtn_min;
  int                   has_ldb_cqrtn_max;

  int                   has_ldb_pp_cq_0_trf_ord;    

  //-- support direct tests when hqmproc_alltrf_sel=1
  int                   has_direct_test_0;   
  int                   has_enq_hcw_num_0;
  int                   has_enq_hcw_num_1;
  int                   has_sch_hcw_num_0;
  int                   has_sch_hcw_num_1;
  int                   has_tok_hcw_num_0;
  int                   has_tok_hcw_num_1;
  int                   has_cmp_hcw_num_0;
  int                   has_cmp_hcw_num_1;

  int hqmproc_batch_disable; 
  int hqmproc_batch_min, hqmproc_batch_max;
  int hqmproc_pad_prob_min, hqmproc_pad_prob_max;
  int hqmproc_expad_prob_min, hqmproc_expad_prob_max;

  int hqmproc_sel, hqmproc_return_flow; //--stim_config
  int hqmproc_wuctl_schcnt_check;
  int hqmproc_wuctl_schcnt_diff;
  int hqmproc_alltrf_sel;               //--stim_config
  int hqmproc_dirppnum_min, hqmproc_dirppnum_max;  //--stim_config
  int hqmproc_ldbppnum_min, hqmproc_ldbppnum_max;  //--stim_config
  int hqmproc_ppnum_min, hqmproc_ppnum_max;        //--stim_config

  int hqmproc_cqirqmask_dirppnum_min, hqmproc_cqirqmask_dirppnum_max;
  int hqmproc_cqirqmask_ldbppnum_min, hqmproc_cqirqmask_ldbppnum_max;
  int hqmproc_cqirqmask_ppnum_min, hqmproc_cqirqmask_ppnum_max;

  bit [31:0] hqm_lsp_range_cos_0_val, hqm_lsp_range_cos_1_val, hqm_lsp_range_cos_2_val, hqm_lsp_range_cos_3_val;
  bit [31:0] hqm_lsp_range_cosrecfg_0_val, hqm_lsp_range_cosrecfg_1_val, hqm_lsp_range_cosrecfg_2_val, hqm_lsp_range_cosrecfg_3_val;
  bit [31:0] hqm_lsp_credit_sat_cos_0_val, hqm_lsp_credit_sat_cos_1_val, hqm_lsp_credit_sat_cos_2_val, hqm_lsp_credit_sat_cos_3_val; 

  int hqmproc_unitidle_poll_num;
  int hqmproc_unitidle_trfmid_check_enable, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report;

  int has_cmpid_cqnum_min;
  int has_cmpid_cqnum_max;

  int hqmproc_tot_inflight_num;

  int hqmproc_intr_enable;

  int hqmproc_vasrst_enable;
  int hqmproc_vasrst_finish;
  int hqmproc_vasrst_trfcont;

  int has_cq_intr_cfg_on;  //-- 1: call cfg_chp_armallcq_task() and  cfg_chp_cqtimer_cwdt_task()
  int has_cq_intr_run_on;  //-- 1: cq.intr/tok-return/rearm interactive free_run  


  time  cwdt_interval_time_start, cwdt_interval_time_end; 
  int	cwintr_interval_ck_on;
  int   cwintr_wdto_ldb_ck, cwintr_wdto_dir_ck, cwintr_wdto_ldb_cnt, cwintr_wdto_dir_cnt;
  
  bit [31:0] ldb_cqirq_mask_0, ldb_cqirq_mask_1;
  bit [31:0] dir_cqirq_mask_0, dir_cqirq_mask_1, dir_cqirq_mask_2;

  bit prochot_disable;



  function new(string name = "hcw_enqtrf_test_hcw_seq");
    super.new(name);
    
    cfg = hcw_enqtrf_test_hcw_seq_stim_config::type_id::create("hcw_enqtrf_test_hcw_seq_stim_config");
`ifdef IP_OVM_STIM
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
    
    //------------------------
    //-- options
    //------------------------
    prochot_disable=0;
    $value$plusargs("hqm_prochot_disable=%d",prochot_disable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: prochot_disable=%0d ", prochot_disable ), UVM_LOW);


    //--
    cwintr_wdto_ldb_ck=1;
    cwintr_wdto_dir_ck=1;
    cwintr_wdto_dir_cnt=0;
    cwintr_wdto_ldb_cnt=0;
    cwintr_interval_ck_on=0;

    cqirq_mask_unmask_loop=1;
    $value$plusargs("hqmproc_cqirq_mask_unmask_loop=%d",cqirq_mask_unmask_loop);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: cqirq_mask_unmask_loop=%0d ", cqirq_mask_unmask_loop ), UVM_LOW);

    has_cqirq_unmask_enable=0;
    $value$plusargs("hqmproc_cqirq_unmask_enable=%d",has_cqirq_unmask_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_unmask_enable=%0d ", has_cqirq_unmask_enable ), UVM_LOW);

    has_cqirq_mask_idleck=0;
    $value$plusargs("hqmproc_cqirq_mask_idleck=%d",has_cqirq_mask_idleck);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_mask_idleck=%0d ", has_cqirq_mask_idleck ), UVM_LOW);

    has_cqirq_mask_enable=0;
    $value$plusargs("hqmproc_cqirq_mask_enable=%d",has_cqirq_mask_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_mask_enable=%0d ", has_cqirq_mask_enable ), UVM_LOW);

    has_cqirq_mask_waitnum=500;
    $value$plusargs("hqmproc_cqirq_mask_waitnum=%d",has_cqirq_mask_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_mask_waitnum=%0d ", has_cqirq_mask_waitnum ), UVM_LOW);
    has_cqirq_mask_loopwaitnum=100;
    $value$plusargs("hqmproc_cqirq_mask_loopwaitnum=%d",has_cqirq_mask_loopwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_mask_loopwaitnum=%0d ", has_cqirq_mask_loopwaitnum ), UVM_LOW);
    
    has_cqirq_maskunmask_paral=0;
    $value$plusargs("hqmproc_cqirq_paral_enable=%d",has_cqirq_maskunmask_paral);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_maskunmask_paral=%0d ", has_cqirq_maskunmask_paral ), UVM_LOW);

    has_cqirq_mask_paral_ena=0;
    $value$plusargs("hqmproc_cqirq_mask_paral_ena=%d",has_cqirq_mask_paral_ena);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_mask_paral_ena=%0d ", has_cqirq_mask_paral_ena ), UVM_LOW);

    has_cqirq_unmask_paral_ena=0;
    $value$plusargs("hqmproc_cqirq_unmask_paral_ena=%d",has_cqirq_unmask_paral_ena);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cqirq_unmask_paral_ena=%0d ", has_cqirq_unmask_paral_ena ), UVM_LOW);


    has_bgcfg_enable=0;
    $value$plusargs("hqmproc_bgcfg_enable=%d",has_bgcfg_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_bgcfg_enable=%0d ", has_bgcfg_enable ), UVM_LOW);
    
    bgcfg_waitnum=500;
    $value$plusargs("hqmproc_bgcfg_waitnum=%d",bgcfg_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: bgcfg_waitnum=%0d ", bgcfg_waitnum ), UVM_LOW);
    
    bgcfg_loopnum=300;
    $value$plusargs("hqmproc_bgcfg_loopnum=%d",bgcfg_loopnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: bgcfg_loopnum=%0d ", bgcfg_loopnum ), UVM_LOW);
    
    has_force_stop_enable=0;
    $value$plusargs("hqmproc_force_stop_enable=%d",has_force_stop_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_force_stop_enable=%0d ", has_force_stop_enable ), UVM_LOW);

    has_force_stop_loop=1;
    $value$plusargs("hqmproc_force_stop_loop=%d",has_force_stop_loop);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_force_stop_loop=%0d ", has_force_stop_loop ), UVM_LOW);

    has_force_stop_waitnum=100;
    $value$plusargs("hqmproc_force_stop_waitnum=%d",has_force_stop_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_force_stop_waitnum=%0d ", has_force_stop_waitnum ), UVM_LOW);

    hqmproc_unitidle_poll_num=100;
    $value$plusargs("hqmproc_unitidle_poll_num=%d",hqmproc_unitidle_poll_num);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_unitidle_poll_num=%0d ", hqmproc_unitidle_poll_num ), UVM_LOW);

    hqmproc_unitidle_trfmid_check_enable=0; 
    $value$plusargs("hqmproc_unitidle_trfmid_check_enable=%d",hqmproc_unitidle_trfmid_check_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_unitidle_trfmid_check_enable=%0d ", hqmproc_unitidle_trfmid_check_enable ), UVM_LOW);

    hqmproc_unitidle_trfmid_expect_idle=1; 
    $value$plusargs("hqmproc_unitidle_trfmid_expect_idle=%d",hqmproc_unitidle_trfmid_expect_idle);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_unitidle_trfmid_expect_idle=%0d ", hqmproc_unitidle_trfmid_expect_idle ), UVM_LOW);

    hqmproc_unitidle_trfmid_report=0;
    $value$plusargs("hqmproc_unitidle_trfmid_report=%d",hqmproc_unitidle_trfmid_report);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_unitidle_trfmid_report=%0d ", hqmproc_unitidle_trfmid_report ), UVM_LOW);


    //-- has_cq_intr_cfg_on 
    has_cq_intr_cfg_on=0;
    $value$plusargs("has_cq_intr_cfg_on=%h",has_cq_intr_cfg_on);

    //-- has_cq_intr_run_on when 1: set hqmproc_cq_rearm_ctrl_in[7]=1
    has_cq_intr_run_on=0;
    $value$plusargs("has_cq_intr_run_on=%h",has_cq_intr_run_on);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cq_intr_run_on=%0d has_cq_intr_cfg_on=0x%0x ", has_cq_intr_run_on, has_cq_intr_cfg_on ), UVM_LOW);

    has_hwerrinj_enable=0;
    $value$plusargs("hqmproc_hwerrinj_enable=%d",has_hwerrinj_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_hwerrinj_enable=%0d ", has_hwerrinj_enable ), UVM_LOW);
    
    hwerrinj_waitnum=300;
    $value$plusargs("hqmproc_hwerrinj_waitnum=%d",hwerrinj_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hwerrinj_waitnum=%0d ", hwerrinj_waitnum ), UVM_LOW);
    
    hwerrinj_loopnum=100;
    $value$plusargs("hqmproc_hwerrinj_loopnum=%d",hwerrinj_loopnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hwerrinj_loopnum=%0d ", hwerrinj_loopnum ), UVM_LOW);
 
    has_hwerrinj_scherr_check=0;
    $value$plusargs("hqmproc_hwerrinj_scherr_check=%d",has_hwerrinj_scherr_check);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_hwerrinj_scherr_check=%0d ", has_hwerrinj_scherr_check ), UVM_LOW);


    has_cmpid_cqnum_min=0;
    $value$plusargs("hqmproc_cmpid_cqnum_min=%d",has_cmpid_cqnum_min);
    has_cmpid_cqnum_max=0;
    $value$plusargs("hqmproc_cmpid_cqnum_max=%d",has_cmpid_cqnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cmpid_cqnum_min=%0d has_cmpid_cqnum_max=%0d ", has_cmpid_cqnum_min, has_cmpid_cqnum_max ), UVM_LOW);


    has_surv_enable=0;
    $value$plusargs("hqmproc_surv_enable=%d",has_surv_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_enable=%0d ", has_surv_enable ), UVM_LOW);

    has_surv_delayclkoff_enable=0;
    $value$plusargs("hqmproc_surv_delayclkoff_enable=%d",has_surv_delayclkoff_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_delayclkoff_enable=%0d ", has_surv_delayclkoff_enable ), UVM_LOW);

    has_surv_csw_enable=0;
    $value$plusargs("hqmproc_surv_csw_enable=%d",has_surv_csw_enable);
    has_surv_ctrl_sel = 0;
    $value$plusargs("hqmproc_surv_ctrl_sel=%d", has_surv_ctrl_sel);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_csw_enable=%0d has_surv_csw_enable=%0d", has_surv_csw_enable,has_surv_csw_enable ), UVM_LOW);

    has_surv_plcrd_enable=0;
    $value$plusargs("hqmproc_surv_plcrd_enable=%d",has_surv_plcrd_enable);
    has_surv_pipeline_credit_sel = 0;
    $value$plusargs("hqmproc_surv_pipeline_credit_sel=%d", has_surv_pipeline_credit_sel);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_plcrd_enable=%0d has_surv_pipeline_credit_sel=%0d ", has_surv_plcrd_enable, has_surv_pipeline_credit_sel ), UVM_LOW);

    has_surv_lsp_ctrl_enable=0;
    $value$plusargs("hqmproc_surv_lsp_ctrl_enable=%d",has_surv_lsp_ctrl_enable);
    has_surv_lsp_control_general0_sel = 0;
    $value$plusargs("hqmproc_surv_lsp_control_general0_sel=%d", has_surv_lsp_control_general0_sel);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_lsp_ctrl_enable=%0d has_surv_lsp_control_general0_sel=%0d", has_surv_lsp_ctrl_enable, has_surv_lsp_control_general0_sel ), UVM_LOW);

    has_surv_sys_ctrl_enable=0;
    $value$plusargs("hqmproc_surv_sys_ctrl_enable=%d",has_surv_sys_ctrl_enable);
    has_surv_hqm_system_ctrl_sel = 0;
    $value$plusargs("hqmproc_surv_hqm_system_ctrl_sel=%d", has_surv_hqm_system_ctrl_sel);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_sys_ctrl_enable=%0d has_surv_hqm_system_ctrl_sel=%0d", has_surv_sys_ctrl_enable, has_surv_hqm_system_ctrl_sel ), UVM_LOW);

    has_surv_fifo_hwm_enable=0;
    $value$plusargs("hqmproc_surv_fifo_hwm_enable=%d", has_surv_fifo_hwm_enable);
    has_surv_fifo_hwm_ctrl_sel = 0;
    $value$plusargs("hqmproc_surv_fifo_hwm_ctrl_sel=%d", has_surv_fifo_hwm_ctrl_sel);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_fifo_hwm_enable=%0d has_surv_fifo_hwm_ctrl_sel=%0d", has_surv_fifo_hwm_enable, has_surv_fifo_hwm_ctrl_sel ), UVM_LOW);

    has_surv_lsp_wb_ctrl_enable=0;
    $value$plusargs("hqmproc_surv_lsp_wb_ctrl_enable=%d",has_surv_lsp_wb_ctrl_enable);
    has_surv_disable_wb = 0;
    $value$plusargs("hqmproc_surv_disable_wb=%d", has_surv_disable_wb);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_surv_lsp_wb_ctrl_enable=%0d has_surv_disable_wb=%0d", has_surv_lsp_wb_ctrl_enable, has_surv_disable_wb ), UVM_LOW);

    has_sys_qidits_enable=0;
    $value$plusargs("hqmproc_sys_qidits_enable=%d",has_sys_qidits_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_sys_qidits_enable=%0d ", has_sys_qidits_enable ), UVM_LOW);

    has_sys_pasid_enable=0;
    $value$plusargs("hqmproc_sys_pasid_enable=%d",has_sys_pasid_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_sys_pasid_enable=%0d ", has_sys_pasid_enable ), UVM_LOW);

    has_sys_rob_ctrl=0;
    $value$plusargs("hqmproc_sys_rob_ctrl=%d",has_sys_rob_ctrl);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_sys_rob_ctrl=%0d (0: ROB_V=0 by default, no programming) (1: ROB_V=1 program for all PPs) (2: random program ROB_V) ", has_sys_rob_ctrl ), UVM_LOW);

    has_sys_aocfg_ctrl=0;
    $value$plusargs("hqmproc_sys_aocfg_ctrl=%d",has_sys_aocfg_ctrl);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_sys_aocfg_ctrl=%0d (if QID[n] has fid_cfg_v=1 and sn_cfg_v=1 => program ao_cfg_v based on has_sys_aocfg_ctrl (0,1,2:rnd)) ", has_sys_aocfg_ctrl ), UVM_LOW);


    has_vas_credit_reprog=0;
    $value$plusargs("hqmproc_vas_credit_reprog=%d",has_vas_credit_reprog);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_vas_credit_reprog=%0d (will reprogram vas[].credit_cnt based on total_credits/num_of_vas) ", has_vas_credit_reprog ), UVM_LOW);

    has_lsp_cq_pcq_enable=0;
    $value$plusargs("hqmproc_cq_pcq_ctrl=%d",has_lsp_cq_pcq_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_lsp_cq_pcq_enable=%0d ", has_lsp_cq_pcq_enable ), UVM_LOW);


    has_lsp_qidthreshold_enable=0;
    $value$plusargs("hqmproc_lsp_qidthreshold_enable=%d",has_lsp_qidthreshold_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_lsp_qidthreshold_enable=%0d ", has_lsp_qidthreshold_enable ), UVM_LOW);

    has_lsp_coscfg_enable=0;
    $value$plusargs("hqmproc_lsp_coscfg_enable=%d",has_lsp_coscfg_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_lsp_coscfg_enable=%0d ", has_lsp_coscfg_enable ), UVM_LOW);

    has_lsp_cosrecfg_enable=0;
    $value$plusargs("hqmproc_lsp_coscfg_enable=%d",has_lsp_cosrecfg_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_lsp_cosrecfg_enable=%0d ", has_lsp_cosrecfg_enable ), UVM_LOW);

    has_lsp_cosrecfg_waitnum=300;
    $value$plusargs("hqmproc_lsp_cosrecfg_waitnum=%d",has_lsp_cosrecfg_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_lsp_cosrecfg_waitnum=%0d ", has_lsp_cosrecfg_waitnum ), UVM_LOW);

    has_lsp_cosrecfg_hcwnum=1024;
    $value$plusargs("hqmproc_lsp_cosrecfg_hcwnum=%d",has_lsp_cosrecfg_hcwnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_lsp_cosrecfg_hcwnum=%0d ", has_lsp_cosrecfg_hcwnum ), UVM_LOW);

    hqmproc_sel=0;
    $value$plusargs("hqmproc_sel=%d",hqmproc_sel);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_sel=%0d ", hqmproc_sel ), UVM_LOW);
    
    hqmproc_return_flow=0;
    $value$plusargs("hqmproc_return_flow=%d",hqmproc_return_flow);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_return_flow=%0d ", hqmproc_return_flow ), UVM_LOW);
    
    hqmproc_intr_enable=1;
    $value$plusargs("hqmproc_intr_enable=%d",hqmproc_intr_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_intr_enable=%0d ", hqmproc_intr_enable ), UVM_LOW);

    hqmproc_vasrst_enable=1;
    $value$plusargs("hqmproc_vasrst_enable=%d",hqmproc_vasrst_enable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_vasrst_enable=%0d ", hqmproc_vasrst_enable ), UVM_LOW);

    hqmproc_vasrst_finish=0;

    hqmproc_vasrst_trfcont=0;
    $value$plusargs("hqmproc_vasrst_trfcont=%d",hqmproc_vasrst_trfcont);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_vasrst_trfcont=%0d ", hqmproc_vasrst_trfcont ), UVM_LOW);



    hqmproc_wuctl_schcnt_check=0;
    $value$plusargs("hqmproc_wuctl_schcnt_check=%d",hqmproc_wuctl_schcnt_check);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_wuctl_schcnt_check=%0d ", hqmproc_wuctl_schcnt_check ), UVM_LOW);

    hqmproc_wuctl_schcnt_diff=200;
    $value$plusargs("hqmproc_wuctl_schcnt_diff=%d",hqmproc_wuctl_schcnt_diff);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_wuctl_schcnt_diff=%0d ", hqmproc_wuctl_schcnt_diff ), UVM_LOW);

    hqmproc_alltrf_sel=0;
    $value$plusargs("hqmproc_alltrf_sel=%d",hqmproc_alltrf_sel);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_alltrf_sel=%0d ", hqmproc_alltrf_sel ), UVM_LOW);
     
    //--batch mode control
    hqmproc_batch_disable=0;
    $value$plusargs("hqmproc_batch_disable=%d",hqmproc_batch_disable);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_batch_disable=%0d ", hqmproc_batch_disable ), UVM_LOW);

    hqmproc_batch_min=1;
    $value$plusargs("hqmproc_batch_min=%d",hqmproc_batch_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_batch_min=%0d ", hqmproc_batch_min ), UVM_LOW);
    
    hqmproc_batch_max=1; 
    $value$plusargs("hqmproc_batch_max=%d",hqmproc_batch_max);
    //--the follwing modes can't run with batch mode:
    if(has_cqirq_mask_enable)  hqmproc_batch_max=1; 
    if(hqmproc_batch_disable)  hqmproc_batch_max=1; 
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_batch_max=%0d ", hqmproc_batch_max ), UVM_LOW);
  

    hqmproc_pad_prob_min=0;
    $value$plusargs("hqmproc_pad_prob_min=%d",hqmproc_pad_prob_min);
    hqmproc_pad_prob_max=0; 
    $value$plusargs("hqmproc_pad_prob_max=%d",hqmproc_pad_prob_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_pad_prob_min=%0d  hqmproc_pad_prob_max=%0d", hqmproc_pad_prob_min, hqmproc_pad_prob_max ), UVM_LOW);

    hqmproc_expad_prob_min=0;
    $value$plusargs("hqmproc_expad_prob_min=%d",hqmproc_expad_prob_min);
    hqmproc_expad_prob_max=0; 
    $value$plusargs("hqmproc_expad_prob_max=%d",hqmproc_expad_prob_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_expad_prob_min=%0d  hqmproc_expad_prob_max=%0d", hqmproc_expad_prob_min, hqmproc_expad_prob_max ), UVM_LOW);

    hqmproc_dirppnum_min=0;
    $value$plusargs("hqmproc_dirppnum_min=%d",hqmproc_dirppnum_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_dirppnum_min=%0d ", hqmproc_dirppnum_min ), UVM_LOW);
    hqmproc_dirppnum_max=8; //64//64
    $value$plusargs("hqmproc_dirppnum_max=%d",hqmproc_dirppnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_dirppnum_max=%0d ", hqmproc_dirppnum_max ), UVM_LOW);
  
    hqmproc_ldbppnum_min=0;
    $value$plusargs("hqmproc_ldbppnum_min=%d",hqmproc_ldbppnum_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_ldbppnum_min=%0d ", hqmproc_ldbppnum_min ), UVM_LOW);
    hqmproc_ldbppnum_max=8; //64
    $value$plusargs("hqmproc_ldbppnum_max=%d",hqmproc_ldbppnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_ldbppnum_max=%0d ", hqmproc_ldbppnum_max ), UVM_LOW);
          
    hqmproc_ppnum_min=0;
    $value$plusargs("hqmproc_ppnum_min=%d",hqmproc_ppnum_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_ppnum_min=%0d ", hqmproc_ppnum_min ), UVM_LOW);
    hqmproc_ppnum_max=128; //0-63: ldbPP; 64:159 dirPP
    $value$plusargs("hqmproc_ppnum_max=%d",hqmproc_ppnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_ppnum_max=%0d ", hqmproc_ppnum_max ), UVM_LOW);
                  
    //hqmproc_cqirqmask_ldbppnum_min, hqmproc_cqirqmask_ldbppnum_max;
    hqmproc_cqirqmask_ldbppnum_min=0;
    $value$plusargs("hqmproc_cqirqmask_ldbppnum_min=%d",hqmproc_cqirqmask_ldbppnum_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_cqirqmask_ldbppnum_min=%0d ", hqmproc_cqirqmask_ldbppnum_min ), UVM_LOW);
    hqmproc_cqirqmask_ldbppnum_max=0; //0-63: ldbPP //64
    $value$plusargs("hqmproc_cqirqmask_ldbppnum_max=%d",hqmproc_cqirqmask_ldbppnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_cqirqmask_ldbppnum_max=%0d ", hqmproc_cqirqmask_ldbppnum_max ), UVM_LOW);
          
    //hqmproc_cqirqmask_dirppnum_min, hqmproc_cqirqmask_dirppnum_max;
    hqmproc_cqirqmask_dirppnum_min=0;
    $value$plusargs("hqmproc_cqirqmask_dirppnum_min=%d",hqmproc_cqirqmask_dirppnum_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_cqirqmask_dirppnum_min=%0d ", hqmproc_cqirqmask_dirppnum_min ), UVM_LOW);
    hqmproc_cqirqmask_dirppnum_max=0; //0-63: ldbPP; 64:127 dirPP; 64
    $value$plusargs("hqmproc_cqirqmask_dirppnum_max=%d",hqmproc_cqirqmask_dirppnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_cqirqmask_dirppnum_max=%0d ", hqmproc_cqirqmask_dirppnum_max ), UVM_LOW);

    //hqmproc_cqirqmask_ppnum_min, hqmproc_cqirqmask_ppnum_max;
    hqmproc_cqirqmask_ppnum_min=0;
    $value$plusargs("hqmproc_cqirqmask_ppnum_min=%d",hqmproc_cqirqmask_ppnum_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_cqirqmask_ppnum_min=%0d ", hqmproc_cqirqmask_ppnum_min ), UVM_LOW);
    hqmproc_cqirqmask_ppnum_max=0; //0-63: ldbPP; 64:159 dirPP
    $value$plusargs("hqmproc_cqirqmask_ppnum_max=%d",hqmproc_cqirqmask_ppnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_cqirqmask_ppnum_max=%0d ", hqmproc_cqirqmask_ppnum_max ), UVM_LOW);
  

    waitnum_min=0;
    $value$plusargs("pp_wait2st_num_min=%d",waitnum_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: waitnum_min=%0d ", waitnum_min ), UVM_LOW);

    waitnum_max=300;
    $value$plusargs("pp_wait2st_num_max=%d",waitnum_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: waitnum_max=%0d ", waitnum_max ), UVM_LOW);

    ldb_pp_cq_0_loopnum=1;    
    $value$plusargs("ldbpp0_loopnum=%d",ldb_pp_cq_0_loopnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_0_loopnum=%0d ", ldb_pp_cq_0_loopnum ), UVM_LOW);
    

    ldb_pp_cq_0_waitnum=1;    
    $value$plusargs("ldbpp0_wait2st_num=%d",ldb_pp_cq_0_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_0_waitnum=%0d ", ldb_pp_cq_0_waitnum ), UVM_LOW);
    
    ldb_pp_cq_1_waitnum=3;
    $value$plusargs("ldbpp1_wait2st_num=%d",ldb_pp_cq_1_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_1_waitnum=%0d ", ldb_pp_cq_1_waitnum ), UVM_LOW);
    
    ldb_pp_cq_2_waitnum=5;
    $value$plusargs("ldbpp2_wait2st_num=%d",ldb_pp_cq_2_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_2_waitnum=%0d ", ldb_pp_cq_2_waitnum ), UVM_LOW);
    
    ldb_pp_cq_3_waitnum=7;
    $value$plusargs("ldbpp3_wait2st_num=%d",ldb_pp_cq_3_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_3_waitnum=%0d ", ldb_pp_cq_3_waitnum ), UVM_LOW);
    
    ldb_pp_cq_4_waitnum=9;
    $value$plusargs("ldbpp4_wait2st_num=%d",ldb_pp_cq_4_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_4_waitnum=%0d ", ldb_pp_cq_4_waitnum ), UVM_LOW);
    
    ldb_pp_cq_5_waitnum=11;
    $value$plusargs("ldbpp5_wait2st_num=%d",ldb_pp_cq_5_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_5_waitnum=%0d ", ldb_pp_cq_5_waitnum ), UVM_LOW);

    ldb_pp_cq_6_waitnum=13;
    $value$plusargs("ldbpp6_wait2st_num=%d",ldb_pp_cq_6_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_6_waitnum=%0d ", ldb_pp_cq_6_waitnum ), UVM_LOW);

    ldb_pp_cq_7_waitnum=15;
    $value$plusargs("ldbpp7_wait2st_num=%d",ldb_pp_cq_7_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_7_waitnum=%0d ", ldb_pp_cq_7_waitnum ), UVM_LOW);

    ldb_pp_cq_8_waitnum=17;
    $value$plusargs("ldbpp8_wait2st_num=%d",ldb_pp_cq_8_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_8_waitnum=%0d ", ldb_pp_cq_8_waitnum ), UVM_LOW);

    ldb_pp_cq_9_waitnum=19;
    $value$plusargs("ldbpp9_wait2st_num=%d",ldb_pp_cq_9_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_9_waitnum=%0d ", ldb_pp_cq_9_waitnum ), UVM_LOW);

    
    dir_pp_cq_0_waitnum=0;
    $value$plusargs("dirpp0_wait2st_num=%d",dir_pp_cq_0_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_0_waitnum=%0d ", dir_pp_cq_0_waitnum ), UVM_LOW);
    
    dir_pp_cq_1_waitnum=2;   
    $value$plusargs("dirpp1_wait2st_num=%d",dir_pp_cq_1_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_1_waitnum=%0d ", dir_pp_cq_1_waitnum ), UVM_LOW);
     
    dir_pp_cq_2_waitnum=4;
    $value$plusargs("dirpp2_wait2st_num=%d",dir_pp_cq_2_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_2_waitnum=%0d ", dir_pp_cq_2_waitnum ), UVM_LOW);
    
    dir_pp_cq_3_waitnum=6;
    $value$plusargs("dirpp3_wait2st_num=%d",dir_pp_cq_3_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_3_waitnum=%0d ", dir_pp_cq_3_waitnum ), UVM_LOW);
    
    dir_pp_cq_4_waitnum=8;
    $value$plusargs("dirpp4_wait2st_num=%d",dir_pp_cq_4_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_4_waitnum=%0d ", dir_pp_cq_4_waitnum ), UVM_LOW);
    
    dir_pp_cq_5_waitnum=10;   
    $value$plusargs("dirpp5_wait2st_num=%d",dir_pp_cq_5_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_5_waitnum=%0d ", dir_pp_cq_5_waitnum ), UVM_LOW);
     
    dir_pp_cq_6_waitnum=12;
    $value$plusargs("dirpp6_wait2st_num=%d",dir_pp_cq_6_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_6_waitnum=%0d ", dir_pp_cq_6_waitnum ), UVM_LOW);
    
    dir_pp_cq_7_waitnum=14;
    $value$plusargs("dirpp7_wait2st_num=%d",dir_pp_cq_7_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_7_waitnum=%0d ", dir_pp_cq_7_waitnum ), UVM_LOW);
      
    dir_pp_cq_8_waitnum=16;
    $value$plusargs("dirpp8_wait2st_num=%d",dir_pp_cq_8_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_8_waitnum=%0d ", dir_pp_cq_8_waitnum ), UVM_LOW);

    dir_pp_cq_9_waitnum=18;
    $value$plusargs("dirpp9_wait2st_num=%d",dir_pp_cq_9_waitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_9_waitnum=%0d ", dir_pp_cq_9_waitnum ), UVM_LOW);


    //-- _pp_cq_x_rtnwaitnum
    ldb_pp_cq_rtnwaitnum=3000;    
    $value$plusargs("ldbpp_wait2rtn_num=%d",ldb_pp_cq_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_rtnwaitnum=%0d ", ldb_pp_cq_rtnwaitnum ), UVM_LOW);


    ldb_pp_cq_0_rtnwaitnum=5000;    
    $value$plusargs("ldbpp0_wait2rtn_num=%d",ldb_pp_cq_0_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_0_rtnwaitnum=%0d ", ldb_pp_cq_0_rtnwaitnum ), UVM_LOW);

    ldb_pp_cq_1_rtnwaitnum=5000;    
    $value$plusargs("ldbpp1_wait2rtn_num=%d",ldb_pp_cq_1_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_1_rtnwaitnum=%0d ", ldb_pp_cq_1_rtnwaitnum ), UVM_LOW);
    
    ldb_pp_cq_2_rtnwaitnum=5000;    
    $value$plusargs("ldbpp2_wait2rtn_num=%d",ldb_pp_cq_2_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_2_rtnwaitnum=%0d ", ldb_pp_cq_2_rtnwaitnum ), UVM_LOW);
    
    ldb_pp_cq_3_rtnwaitnum=5000;    
    $value$plusargs("ldbpp3_wait2rtn_num=%d",ldb_pp_cq_3_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_3_rtnwaitnum=%0d ", ldb_pp_cq_3_rtnwaitnum ), UVM_LOW);

    ldb_pp_cq_4_rtnwaitnum=5000;    
    $value$plusargs("ldbpp4_wait2rtn_num=%d",ldb_pp_cq_4_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_4_rtnwaitnum=%0d ", ldb_pp_cq_4_rtnwaitnum ), UVM_LOW);

    ldb_pp_cq_5_rtnwaitnum=5000;    
    $value$plusargs("ldbpp5_wait2rtn_num=%d",ldb_pp_cq_5_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_5_rtnwaitnum=%0d ", ldb_pp_cq_5_rtnwaitnum ), UVM_LOW);
    
    ldb_pp_cq_6_rtnwaitnum=5000;    
    $value$plusargs("ldbpp6_wait2rtn_num=%d",ldb_pp_cq_6_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_6_rtnwaitnum=%0d ", ldb_pp_cq_6_rtnwaitnum ), UVM_LOW);
    
    ldb_pp_cq_7_rtnwaitnum=5000;    
    $value$plusargs("ldbpp7_wait2rtn_num=%d",ldb_pp_cq_7_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_7_rtnwaitnum=%0d ", ldb_pp_cq_7_rtnwaitnum ), UVM_LOW);

    ldb_pp_cq_8_rtnwaitnum=5000;    
    $value$plusargs("ldbpp8_wait2rtn_num=%d",ldb_pp_cq_8_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_8_rtnwaitnum=%0d ", ldb_pp_cq_8_rtnwaitnum ), UVM_LOW);
    
    ldb_pp_cq_9_rtnwaitnum=5000;    
    $value$plusargs("ldbpp9_wait2rtn_num=%d",ldb_pp_cq_9_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_9_rtnwaitnum=%0d ", ldb_pp_cq_9_rtnwaitnum ), UVM_LOW);



    dir_pp_cq_0_rtnwaitnum=5000;    
    $value$plusargs("dirpp0_wait2rtn_num=%d",dir_pp_cq_0_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_0_rtnwaitnum=%0d ", dir_pp_cq_0_rtnwaitnum ), UVM_LOW);

    dir_pp_cq_1_rtnwaitnum=5000;    
    $value$plusargs("dirpp1_wait2rtn_num=%d",dir_pp_cq_1_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_1_rtnwaitnum=%0d ", dir_pp_cq_1_rtnwaitnum ), UVM_LOW);
    
    dir_pp_cq_2_rtnwaitnum=5000;    
    $value$plusargs("dirpp2_wait2rtn_num=%d",dir_pp_cq_2_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_2_rtnwaitnum=%0d ", dir_pp_cq_2_rtnwaitnum ), UVM_LOW);
    
    dir_pp_cq_3_rtnwaitnum=5000;    
    $value$plusargs("dirpp3_wait2rtn_num=%d",dir_pp_cq_3_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_3_rtnwaitnum=%0d ", dir_pp_cq_3_rtnwaitnum ), UVM_LOW);
    
    dir_pp_cq_4_rtnwaitnum=5000;    
    $value$plusargs("dirpp4_wait2rtn_num=%d",dir_pp_cq_4_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_4_rtnwaitnum=%0d ", dir_pp_cq_4_rtnwaitnum ), UVM_LOW);

    dir_pp_cq_5_rtnwaitnum=5000;    
    $value$plusargs("dirpp5_wait2rtn_num=%d",dir_pp_cq_5_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_5_rtnwaitnum=%0d ", dir_pp_cq_5_rtnwaitnum ), UVM_LOW);
    
    dir_pp_cq_6_rtnwaitnum=5000;    
    $value$plusargs("dirpp6_wait2rtn_num=%d",dir_pp_cq_6_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_6_rtnwaitnum=%0d ", dir_pp_cq_6_rtnwaitnum ), UVM_LOW);
    
    dir_pp_cq_7_rtnwaitnum=5000;    
    $value$plusargs("dirpp7_wait2rtn_num=%d",dir_pp_cq_7_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_7_rtnwaitnum=%0d ", dir_pp_cq_7_rtnwaitnum ), UVM_LOW);
    
    dir_pp_cq_8_rtnwaitnum=5000;    
    $value$plusargs("dirpp8_wait2rtn_num=%d",dir_pp_cq_8_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_8_rtnwaitnum=%0d ", dir_pp_cq_8_rtnwaitnum ), UVM_LOW);
    
    dir_pp_cq_9_rtnwaitnum=5000;    
    $value$plusargs("dirpp9_wait2rtn_num=%d",dir_pp_cq_9_rtnwaitnum);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_9_rtnwaitnum=%0d ", dir_pp_cq_9_rtnwaitnum ), UVM_LOW);

    //-- _pp_cq_x_qidin
    ldb_pp_cq_0_qidin=0;    
    $value$plusargs("ldbpp0_qidin=%d",ldb_pp_cq_0_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_0_qidin=%0d ", ldb_pp_cq_0_qidin ), UVM_LOW);

    ldb_pp_cq_1_qidin=1;    
    $value$plusargs("ldbpp1_qidin=%d",ldb_pp_cq_1_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_1_qidin=%0d ", ldb_pp_cq_1_qidin ), UVM_LOW);
    
    ldb_pp_cq_2_qidin=2;    
    $value$plusargs("ldbpp2_qidin=%d",ldb_pp_cq_2_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_2_qidin=%0d ", ldb_pp_cq_2_qidin ), UVM_LOW);
    
    ldb_pp_cq_3_qidin=3;    
    $value$plusargs("ldbpp3_qidin=%d",ldb_pp_cq_3_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_3_qidin=%0d ", ldb_pp_cq_3_qidin ), UVM_LOW);

    ldb_pp_cq_4_qidin=4;    
    $value$plusargs("ldbpp4_qidin=%d",ldb_pp_cq_4_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_4_qidin=%0d ", ldb_pp_cq_4_qidin ), UVM_LOW);

    ldb_pp_cq_5_qidin=5;    
    $value$plusargs("ldbpp5_qidin=%d",ldb_pp_cq_5_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_5_qidin=%0d ", ldb_pp_cq_5_qidin ), UVM_LOW);
    
    ldb_pp_cq_6_qidin=6;    
    $value$plusargs("ldbpp6_qidin=%d",ldb_pp_cq_6_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_6_qidin=%0d ", ldb_pp_cq_6_qidin ), UVM_LOW);
    
    ldb_pp_cq_7_qidin=7;    
    $value$plusargs("ldbpp7_qidin=%d",ldb_pp_cq_7_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_7_qidin=%0d ", ldb_pp_cq_7_qidin ), UVM_LOW);

    ldb_pp_cq_8_qidin=8;    
    $value$plusargs("ldbpp8_qidin=%d",ldb_pp_cq_8_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_8_qidin=%0d ", ldb_pp_cq_8_qidin ), UVM_LOW);
    
    ldb_pp_cq_9_qidin=9;    
    $value$plusargs("ldbpp9_qidin=%d",ldb_pp_cq_9_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: ldb_pp_cq_9_qidin=%0d ", ldb_pp_cq_9_qidin ), UVM_LOW);



    dir_pp_cq_0_qidin=0;    
    $value$plusargs("dirpp0_qidin=%d",dir_pp_cq_0_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_0_qidin=%0d ", dir_pp_cq_0_qidin ), UVM_LOW);

    dir_pp_cq_1_qidin=1;    
    $value$plusargs("dirpp1_qidin=%d",dir_pp_cq_1_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_1_qidin=%0d ", dir_pp_cq_1_qidin ), UVM_LOW);
    
    dir_pp_cq_2_qidin=2;    
    $value$plusargs("dirpp2_qidin=%d",dir_pp_cq_2_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_2_qidin=%0d ", dir_pp_cq_2_qidin ), UVM_LOW);
    
    dir_pp_cq_3_qidin=3;    
    $value$plusargs("dirpp3_qidin=%d",dir_pp_cq_3_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_3_qidin=%0d ", dir_pp_cq_3_qidin ), UVM_LOW);
    
    dir_pp_cq_4_qidin=4;    
    $value$plusargs("dirpp4_qidin=%d",dir_pp_cq_4_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_4_qidin=%0d ", dir_pp_cq_4_qidin ), UVM_LOW);

    dir_pp_cq_5_qidin=5;    
    $value$plusargs("dirpp5_qidin=%d",dir_pp_cq_5_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_5_qidin=%0d ", dir_pp_cq_5_qidin ), UVM_LOW);
    
    dir_pp_cq_6_qidin=6;    
    $value$plusargs("dirpp6_qidin=%d",dir_pp_cq_6_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_6_qidin=%0d ", dir_pp_cq_6_qidin ), UVM_LOW);
    
    dir_pp_cq_7_qidin=7;    
    $value$plusargs("dirpp7_qidin=%d",dir_pp_cq_7_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_7_qidin=%0d ", dir_pp_cq_7_qidin ), UVM_LOW);
    
    dir_pp_cq_8_qidin=8;    
    $value$plusargs("dirpp8_qidin=%d",dir_pp_cq_8_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_8_qidin=%0d ", dir_pp_cq_8_qidin ), UVM_LOW);
    
    dir_pp_cq_9_qidin=9;    
    $value$plusargs("dirpp9_qidin=%d",dir_pp_cq_9_qidin);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: dir_pp_cq_9_qidin=%0d ", dir_pp_cq_9_qidin ), UVM_LOW);


       
    //-- when hqmproc_alltrf_sel=1, direct tests controls
    has_direct_test_0=0;   
    $value$plusargs("hqmproc_direct_test_0=%d",has_direct_test_0);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_direct_test_0=%0d ", has_direct_test_0 ), UVM_LOW);
         
    has_enq_hcw_num_0=0;   
    $value$plusargs("hqmproc_enq_hcw_num_0=%d",has_enq_hcw_num_0);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_enq_hcw_num_0=%0d ", has_enq_hcw_num_0 ), UVM_LOW);
         
    has_enq_hcw_num_1=0;   
    $value$plusargs("hqmproc_enq_hcw_num_1=%d",has_enq_hcw_num_1);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_enq_hcw_num_1=%0d ", has_enq_hcw_num_1 ), UVM_LOW);
         
    has_sch_hcw_num_0=0;   
    $value$plusargs("hqmproc_sch_hcw_num_0=%d",has_sch_hcw_num_0);
    uvm_report_info(get_type_name(),$psprintf("hcw_schtrf_test_hcw_seq setting: has_sch_hcw_num_0=%0d ", has_sch_hcw_num_0 ), UVM_LOW);
         
    has_sch_hcw_num_1=0;   
    $value$plusargs("hqmproc_sch_hcw_num_1=%d",has_sch_hcw_num_1);
    uvm_report_info(get_type_name(),$psprintf("hcw_schtrf_test_hcw_seq setting: has_sch_hcw_num_1=%0d ", has_sch_hcw_num_1 ), UVM_LOW);
         
    has_tok_hcw_num_0=0;   
    $value$plusargs("hqmproc_tok_hcw_num_0=%d",has_tok_hcw_num_0);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_tok_hcw_num_0=%0d ", has_tok_hcw_num_0 ), UVM_LOW);
         
    has_tok_hcw_num_1=0;   
    $value$plusargs("hqmproc_tok_hcw_num_1=%d",has_tok_hcw_num_1);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_tok_hcw_num_1=%0d ", has_tok_hcw_num_1 ), UVM_LOW);
 
    has_cmp_hcw_num_0=0;   
    $value$plusargs("hqmproc_cmp_hcw_num_0=%d",has_cmp_hcw_num_0);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cmp_hcw_num_0=%0d ", has_cmp_hcw_num_0 ), UVM_LOW);
         
    has_cmp_hcw_num_1=0;   
    $value$plusargs("hqmproc_cmp_hcw_num_1=%d",has_cmp_hcw_num_1);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_cmp_hcw_num_1=%0d ", has_cmp_hcw_num_1 ), UVM_LOW);
 

    //--
    has_ldb_pp_cq_trf_2stage=0;    
    $value$plusargs("ldbpp_trf_2stage=%d",has_ldb_pp_cq_trf_2stage);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_trf_2stage=%0d ", has_ldb_pp_cq_trf_2stage ), UVM_LOW);
    //--
    has_ldb_pp_cq_trf_2cont=0;    
    $value$plusargs("ldbpp_trf_2cont=%d",has_ldb_pp_cq_trf_2cont);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_trf_2cont=%0d ", has_ldb_pp_cq_trf_2cont ), UVM_LOW);

    //--
    has_ldb_pp_cq_0_trf_ord=0;    
    $value$plusargs("ldbpp0_trf_ord=%d",has_ldb_pp_cq_0_trf_ord);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_0_trf_ord=%0d ", has_ldb_pp_cq_0_trf_ord ), UVM_LOW);

    //--
    has_dir_pp_cq_trf_2stage=0;    
    $value$plusargs("dirpp_trf_2stage=%d",has_dir_pp_cq_trf_2stage);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_dir_pp_cq_trf_2stage=%0d ", has_dir_pp_cq_trf_2stage ), UVM_LOW);
    //--
    has_dir_pp_cq_trf_2cont=0;    
    $value$plusargs("dirpp_trf_2cont=%d",has_dir_pp_cq_trf_2cont);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_dir_pp_cq_trf_2cont=%0d ", has_dir_pp_cq_trf_2cont ), UVM_LOW);


    //--
    has_ldb_cqdisable_min=0;    
    $value$plusargs("ldb_cqdisable_min=%d",has_ldb_cqdisable_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_cqdisable_min=%0d ", has_ldb_cqdisable_min ), UVM_LOW);
    has_ldb_cqdisable_max=64;    
    $value$plusargs("ldb_cqdisable_max=%d",has_ldb_cqdisable_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_cqdisable_max=%0d ", has_ldb_cqdisable_max ), UVM_LOW);

    //--
    has_dir_cqdisable_min=0;    
    $value$plusargs("dir_cqdisable_min=%d",has_dir_cqdisable_min);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_dir_cqdisable_min=%0d ", has_dir_cqdisable_min ), UVM_LOW);
    has_dir_cqdisable_max=64;    
    $value$plusargs("dir_cqdisable_max=%d",has_dir_cqdisable_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_dir_cqdisable_max=%0d ", has_dir_cqdisable_max ), UVM_LOW);

    //--support scenario 2
    has_ldb_pp_cq_trf_scen2=0;    
    $value$plusargs("ldbpp_trf_scen2=%d",has_ldb_pp_cq_trf_scen2);
    has_ldb_cqrtn_min=0;
    $value$plusargs("ldb_cqrtn_min=%d",has_ldb_cqrtn_min);
    has_ldb_cqrtn_max=0;
    $value$plusargs("ldb_cqrtn_max=%d",has_ldb_cqrtn_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_trf_scen2=%0d has_ldb_cqrtn_min=%0d has_ldb_cqrtn_max=%0d", has_ldb_pp_cq_trf_scen2, has_ldb_cqrtn_min, has_ldb_cqrtn_max), UVM_LOW);



    //--support scenario 2
    has_ldb_pp_cq_2_trf_scen2=0;
    $value$plusargs("ldbpp2_trf_scen2=%d",has_ldb_pp_cq_2_trf_scen2);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_2_trf_scen2=%0d ", has_ldb_pp_cq_2_trf_scen2 ), UVM_LOW);

    has_ldb_pp_cq_3_trf_scen2=0;
    $value$plusargs("ldbpp3_trf_scen2=%d",has_ldb_pp_cq_3_trf_scen2);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_3_trf_scen2=%0d ", has_ldb_pp_cq_3_trf_scen2 ), UVM_LOW);

    has_ldb_pp_cq_4_trf_scen2=0;
    $value$plusargs("ldbpp4_trf_scen2=%d",has_ldb_pp_cq_4_trf_scen2);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_4_trf_scen2=%0d ", has_ldb_pp_cq_4_trf_scen2 ), UVM_LOW);

    has_ldb_pp_cq_5_trf_scen2=0;
    $value$plusargs("ldbpp5_trf_scen2=%d",has_ldb_pp_cq_5_trf_scen2);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_5_trf_scen2=%0d ", has_ldb_pp_cq_5_trf_scen2 ), UVM_LOW);

    has_ldb_pp_cq_6_trf_scen2=0;
    $value$plusargs("ldbpp6_trf_scen2=%d",has_ldb_pp_cq_6_trf_scen2);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_6_trf_scen2=%0d ", has_ldb_pp_cq_6_trf_scen2 ), UVM_LOW);

    has_ldb_pp_cq_7_trf_scen2=0;
    $value$plusargs("ldbpp7_trf_scen2=%d",has_ldb_pp_cq_7_trf_scen2);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_ldb_pp_cq_7_trf_scen2=%0d ", has_ldb_pp_cq_7_trf_scen2 ), UVM_LOW);

    //-- COS bin settings
    hqm_lsp_range_cos_0_val=32'h40; 
    $value$plusargs("hqm_lsp_range_cos_0_val=%h", hqm_lsp_range_cos_0_val);
    hqm_lsp_credit_sat_cos_0_val=32'h100; 
    $value$plusargs("hqm_lsp_credit_sat_cos_0_val=%h", hqm_lsp_credit_sat_cos_0_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_0: hqm_lsp_range_cos_0_val=0x%0x hqm_lsp_credit_sat_cos_0_val=0x%0x ", hqm_lsp_range_cos_0_val,hqm_lsp_credit_sat_cos_0_val), UVM_LOW);

    hqm_lsp_range_cos_1_val=32'h40; 
    $value$plusargs("hqm_lsp_range_cos_1_val=%h", hqm_lsp_range_cos_1_val);
    hqm_lsp_credit_sat_cos_1_val=32'h100; 
    $value$plusargs("hqm_lsp_credit_sat_cos_1_val=%h", hqm_lsp_credit_sat_cos_1_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_1: hqm_lsp_range_cos_1_val=0x%0x hqm_lsp_credit_sat_cos_1_val=0x%0x ", hqm_lsp_range_cos_1_val,hqm_lsp_credit_sat_cos_1_val), UVM_LOW);

    hqm_lsp_range_cos_2_val=32'h40; 
    $value$plusargs("hqm_lsp_range_cos_2_val=%h", hqm_lsp_range_cos_2_val);
    hqm_lsp_credit_sat_cos_2_val=32'h100; 
    $value$plusargs("hqm_lsp_credit_sat_cos_2_val=%h", hqm_lsp_credit_sat_cos_2_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_2: hqm_lsp_range_cos_2_val=0x%0x hqm_lsp_credit_sat_cos_2_val=0x%0x ", hqm_lsp_range_cos_2_val,hqm_lsp_credit_sat_cos_2_val), UVM_LOW);

    hqm_lsp_range_cos_3_val=32'h40; 
    $value$plusargs("hqm_lsp_range_cos_3_val=%h", hqm_lsp_range_cos_3_val);
    hqm_lsp_credit_sat_cos_3_val=32'h100; 
    $value$plusargs("hqm_lsp_credit_sat_cos_3_val=%h", hqm_lsp_credit_sat_cos_3_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_3: hqm_lsp_range_cos_3_val=0x%0x hqm_lsp_credit_sat_cos_3_val=0x%0x ", hqm_lsp_range_cos_3_val,hqm_lsp_credit_sat_cos_3_val), UVM_LOW);

    //-- COS bin recfg settings
    hqm_lsp_range_cosrecfg_0_val=32'h40; ;
    $value$plusargs("hqm_lsp_range_cosrecfg_0_val=%h", hqm_lsp_range_cosrecfg_0_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_0: hqm_lsp_range_cosrecfg_0_val=0x%0x  ", hqm_lsp_range_cosrecfg_0_val), UVM_LOW);

    hqm_lsp_range_cosrecfg_1_val=32'h40; 
    $value$plusargs("hqm_lsp_range_cosrecfg_1_val=%h", hqm_lsp_range_cosrecfg_1_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_1: hqm_lsp_range_cosrecfg_1_val=0x%0x ", hqm_lsp_range_cosrecfg_1_val), UVM_LOW);

    hqm_lsp_range_cosrecfg_2_val=32'h40; 
    $value$plusargs("hqm_lsp_range_cosrecfg_2_val=%h", hqm_lsp_range_cosrecfg_2_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_2: hqm_lsp_range_cosrecfg_2_val=0x%0x ", hqm_lsp_range_cosrecfg_2_val), UVM_LOW);

    hqm_lsp_range_cosrecfg_3_val=32'h40;
    $value$plusargs("hqm_lsp_range_cosrecfg_3_val=%h", hqm_lsp_range_cosrecfg_3_val);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting_COS_3: hqm_lsp_range_cosrecfg_3_val=0x%0x ", hqm_lsp_range_cosrecfg_3_val), UVM_LOW);

    hqmproc_tot_inflight_num=2048;
    $value$plusargs("hqmproc_tot_inflight_num=%d", hqmproc_tot_inflight_num);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_tot_inflight_num=%0d ", hqmproc_tot_inflight_num), UVM_LOW);


  endfunction
  




  //-------------------------
  // body()
  //------------------------- 
  virtual task body();

    uvm_object o_tmp;

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    //------------------------
    //-- get each reg file
    //------------------------



    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",cfg.inst_suffix}, o_tmp)) begin
       uvm_report_info(get_full_name(), "hcw_enqtrf_test_hcw_seq: Unable to find i_hqm_cfg object", UVM_LOW);
       i_hqm_cfg = null;
    end else begin
       if (!$cast(i_hqm_cfg, o_tmp)) begin
         uvm_report_fatal(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
       end 
    end 

    ///if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
    ///  uvm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
    ///end 

    ///if (!$cast(i_hqm_cfg, o_tmp)) begin
    ///  uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
    ///end   
    
    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hcw_scoreboard",cfg.inst_suffix}, o_tmp)) begin
       uvm_report_info(get_full_name(), "hcw_enqtrf_test_hcw_seq: Unable to find i_hcw_scoreboard object", UVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         uvm_report_fatal(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end 
    end 

    //-----------------------------
    // -- get i_hqm_pp_cq_status
    //-----------------------------
    if ( p_sequencer.get_config_object({"i_hqm_pp_cq_status",cfg.inst_suffix}, o_tmp) ) begin
        if ( ! ($cast(i_hqm_pp_cq_status, o_tmp)) ) begin
            uvm_report_fatal(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: Object passed through i_hqm_pp_cq_status not compatible with class type hqm_pp_cq_status"));
        end 
    end else begin
        uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: No i_hqm_pp_cq_status set through set_config_object"));
        i_hqm_pp_cq_status = null;
    end 


    //-----------------------------------------------------------------------------
    //--CQ addr reprogram
    //-----------------------------------------------------------------------------    
    //-----------------------------
    //-----------------------------
    if($test$plusargs("HQM_CQ_ADDR_REPROG")) begin
        hqm_cq_addr_reporgram();
    end 

    //-----------------------------------------------------------------------------
    //--Main_Cfg_Flow
    //-----------------------------------------------------------------------------    
  `ifdef IP_TYP_TE 
    //----------------------
    //-- survivability 
    //----------------------
    if(has_surv_enable==1) begin
        if(has_surv_lsp_ctrl_enable && has_surv_lsp_control_general0_sel==30) begin
           configure_surv_lsp_control_general0_task(has_surv_lsp_control_general0_sel);
        end 
        hqmproc_configure_surv_sel_task();
    end else begin
        //-- has_surv_delayclkoff_enable
        if(has_surv_delayclkoff_enable) begin
           configure_surv_delayclkoff_task();
        end 
        if(has_surv_csw_enable) begin
           configure_surv_csw_task(has_surv_csw_ctrl_sel);
        end 
        if(has_surv_plcrd_enable) begin
           configure_surv_pipeline_credit_task(has_surv_pipeline_credit_sel);
        end 
        if(has_surv_lsp_ctrl_enable) begin
           configure_surv_lsp_control_general0_task(has_surv_lsp_control_general0_sel);
        end 
        if(has_surv_sys_ctrl_enable) begin
           configure_surv_hqm_system_ctrl(has_surv_hqm_system_ctrl_sel);
        end 
        if(has_surv_fifo_hwm_enable) begin
           configure_surv_fifo_hwm_task(has_surv_fifo_hwm_ctrl_sel);
        end 
        if(has_surv_lsp_wb_ctrl_enable) begin
           configure_surv_lsp_disable_wb(has_surv_disable_wb);
        end 
    end 

    //----------------------
    //-- prochot disable 
    //----------------------
    cfg_config_master_prochot_disable(prochot_disable);

    //----------------------
    //-- system_cfg 
    //----------------------
    cfg_hqm_system_ctrl_task();

    if(has_sys_qidits_enable) begin
      cfg_hqm_system_qidits_task();
    end 
    if(has_sys_pasid_enable) begin
      cfg_hqm_system_pasid_task();
    end 
    if(has_sys_rob_ctrl>0) begin
      cfg_hqm_system_robcfg_task(has_sys_rob_ctrl);
    end 
    if(has_sys_aocfg_ctrl>0) begin
      cfg_hqm_system_aocfg_task(has_sys_aocfg_ctrl);
    end 

    //----------------------
    //-- chp reprog vas credit 
    //----------------------
    if(has_vas_credit_reprog>0) begin
      cfg_chp_vas_credit_reprog_task(hqm_pkg::NUM_CREDITS);
    end 

    //----------------------
    //-- lsp  list_sel_pipe.disabled_pcq 
    //----------------------
    if(has_lsp_cq_pcq_enable>0) begin
      configure_lsp_cq_pcq_task(has_lsp_cq_pcq_enable);
    end 

    //----------------------
    //-- lsp_qidthreshold 
    //----------------------
    configure_lsp_perfctrl_task();

    if(has_lsp_qidthreshold_enable) begin
      configure_lsp_qidthreshold_task();
    end 

    //----------------------
    //-- lsp_cos 
    //----------------------
    if(has_lsp_coscfg_enable) begin
      configure_lsp_cos_task(hqm_lsp_range_cos_0_val, hqm_lsp_range_cos_1_val, hqm_lsp_range_cos_2_val, hqm_lsp_range_cos_3_val, hqm_lsp_credit_sat_cos_0_val, hqm_lsp_credit_sat_cos_1_val, hqm_lsp_credit_sat_cos_2_val, hqm_lsp_credit_sat_cos_3_val);
    end 

    //----------------------
    //-- chp program armed registers to do init ARM 
    //----------------------
    if(has_cq_intr_cfg_on) begin
       cfg_chp_armallcq_task(); //turn on all ARM
       cfg_chp_cqtimer_cwdt_task(); //turn on/off CIAL.timer, CWDT
       if(has_cqirq_mask_enable) begin
          //-- call task cfg_chp_cqirq_mask_unmask_task(int loop, int is_ldb, int cq_int_mask, int cq_int_interactive, int wait_num, int cq_num_min, int cq_num_max);
          cfg_chp_cqirq_mask_unmask_task(1, 1, has_cqirq_mask_enable, 0, 1, hqmproc_cqirqmask_ldbppnum_min, hqmproc_cqirqmask_ldbppnum_max); //CQ IRQ Mask setting 
          cfg_chp_cqirq_mask_unmask_task(1, 0, has_cqirq_mask_enable, 0, 1, hqmproc_cqirqmask_dirppnum_min, hqmproc_cqirqmask_dirppnum_max); //CQ IRQ Mask setting
       end 
    end 

    //----------------------
    //-- chp program CFG_CMP_SN_CHK_ENBL to enable=1/disable=0 any CQ cmp_id check
    //----------------------
    for(int mm=has_cmpid_cqnum_min; mm<has_cmpid_cqnum_max; mm++) begin
       cfg_chp_cmpsnck_enable_task(1, mm);  //--turnon cmp_id check
    end 
  `endif //`ifdef IP_TYP_TE 
   
    //-----------------------------------------------------------------------------
    //--Main_Flow
    //-----------------------------------------------------------------------------    
    fork
    
    begin //--main_flow_traffic    
    //-----------------------------------------------------------------------------
    //-- Traffics 
    //----------------------------------------------------------------------------- 
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//
          //-- Case_hqmproc_alltrf_sel=2
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//	  
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//	  
	  if(hqmproc_alltrf_sel==2) begin
            //---------------------------------
            //-- Traffics hqmproc_alltrf_sel=2
            //---------------------------------
	        fork	
        	//---------------------
        	//--bgcfg
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+bgcfg
                       if(has_bgcfg_enable==1 && !$test$plusargs("hqmproc_bgcfg_disabled")) begin
                          wait_idle(bgcfg_waitnum);
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Start bg_cfg_seq"),UVM_LOW)    
                         `uvm_do(bg_cfg_seq)
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Done"),UVM_LOW)   
                       end else if(has_bgcfg_enable==2 && !$test$plusargs("hqmproc_bgcfg_disabled")) begin
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Start bgcfg with bgcfg_waitnum=%0d bgcfg_loopnum=%0d ", bgcfg_waitnum, bgcfg_loopnum),UVM_LOW)    
                          for(int bgcfg_loop=0; bgcfg_loop<bgcfg_loopnum; bgcfg_loop++) begin 
                             if(i_hqm_cfg.hqmproc_trfctrl!=2) begin
                                wait_idle(bgcfg_waitnum);
                               `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Process bgcfg_loop=%0d in bgcfg_loopnum=%0d ", bgcfg_loop, bgcfg_loopnum),UVM_LOW)    
                                backgroundcfg_access_sel_task();
                             end 
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Done"),UVM_LOW)
                       end 
                end //--level_1_bgcfg
               `endif //`ifdef IP_TYP_TE

        	//---------------------
        	//--cqirq_mask_unmask sequential flow
                //-- call task cfg_chp_cqirq_mask_unmask_task(int loop, int is_ldb, int cq_int_mask, int cq_int_interactive, int wait_num, int cq_num_min, int cq_num_max);
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+cqirq_mask_change
                   if(has_cqirq_maskunmask_paral==0) begin
                     for(int cqirq_idx=0; cqirq_idx<cqirq_mask_unmask_loop; cqirq_idx++) begin
                       if(has_cqirq_mask_enable==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
                          if(cqirq_idx==0) begin
                                 `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: Start cfg_chp_cqirq_mask_unmask_task mask flow_%0d round skip interactive-method", cqirq_idx),UVM_LOW)    
                                  wait_idle(has_cqirq_mask_waitnum*5);
                          end else begin
                             `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: Start cfg_chp_cqirq_mask_unmask_task mask flow_%0d round", cqirq_idx),UVM_LOW)    
                             if(hqmproc_cqirqmask_ldbppnum_max > hqmproc_cqirqmask_ldbppnum_min) begin
                                 wait_idle(has_cqirq_mask_waitnum);
                                `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: start cfg_chp_cqirq_mask_unmask_task mask flow_%0d round for ldb CQs", cqirq_idx),UVM_LOW)    
                                 cfg_chp_cqirq_mask_unmask_task(1, 1, 1, 1, has_cqirq_mask_loopwaitnum, hqmproc_cqirqmask_ldbppnum_min, hqmproc_cqirqmask_ldbppnum_max); //CQ IRQ Mask setting
                             end 
                             if(hqmproc_cqirqmask_dirppnum_max > hqmproc_cqirqmask_dirppnum_min) begin
                                 wait_idle(has_cqirq_mask_waitnum);
                                `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: start cfg_chp_cqirq_mask_unmask_task mask flow_%0d round for dir CQs", cqirq_idx),UVM_LOW)    
                                 cfg_chp_cqirq_mask_unmask_task(1, 0, 1, 1, has_cqirq_mask_loopwaitnum, hqmproc_cqirqmask_dirppnum_min, hqmproc_cqirqmask_dirppnum_max); //CQ IRQ Mask setting
                             end 
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: Done has_cqirq_mask_enable mask flow_%0d round", cqirq_idx),UVM_LOW)
                       end else begin
                          if(i_hqm_cfg.hqmproc_trfctrl==2) break;
                       end 

                       if(has_cqirq_unmask_enable==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
                          `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: Start cfg_chp_cqirq_mask_unmask_task unmask flow_%0d round", cqirq_idx),UVM_LOW)    
                          if(hqmproc_cqirqmask_ldbppnum_max > hqmproc_cqirqmask_ldbppnum_min) begin
                             wait_idle(has_cqirq_mask_waitnum);
                             `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: start cfg_chp_cqirq_mask_unmask_task unmask flow_%0d round for ldb CQs", cqirq_idx),UVM_LOW)    
                             cfg_chp_cqirq_mask_unmask_task(1, 1, 0, 1, has_cqirq_mask_loopwaitnum, hqmproc_cqirqmask_ldbppnum_min, hqmproc_cqirqmask_ldbppnum_max); //CQ IRQ Mask setting
                          end 
                          if(hqmproc_cqirqmask_dirppnum_max > hqmproc_cqirqmask_dirppnum_min) begin
                             wait_idle(has_cqirq_mask_waitnum);
                             `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: start cfg_chp_cqirq_mask_unmask_task unmask flow_%0d round for dir CQs", cqirq_idx),UVM_LOW)    
                             cfg_chp_cqirq_mask_unmask_task(1, 0, 0, 1, has_cqirq_mask_loopwaitnum, hqmproc_cqirqmask_dirppnum_min, hqmproc_cqirqmask_dirppnum_max); //CQ IRQ Mask setting
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: Done has_cqirq_unmask_enable  unmask flow_%0d round", cqirq_idx),UVM_LOW)
                       end else begin
                          if(i_hqm_cfg.hqmproc_trfctrl==2) break;
                       end 

                     end //for(int cqirq_idx
                   end else begin
                     `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: disabled has_cqirq_maskunmask_paral=1"),UVM_LOW)    
                   end //--if(has_cqirq_maskunmask_paral==0
                  `uvm_info(get_full_name(),$psprintf("Main_CQIRQUNMASK_flow: Done"),UVM_LOW)    
                end //--level_1_cqirq_mask_change
               `endif //`ifdef IP_TYP_TE


        	//---------------------
        	//--cqirq_pending_ck  parallel flow
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+cqirq_pending_ck_parallel
                   if(has_cqirq_maskunmask_paral==1) begin
        	     for(int cqirq_pend_idx=hqmproc_cqirqmask_ppnum_min; cqirq_pend_idx<hqmproc_cqirqmask_ppnum_max; cqirq_pend_idx++) begin
        	       fork
                	   automatic int cqirq_pend_idx_k = cqirq_pend_idx;  

                   	    if(cqirq_pend_idx_k <= 63 && (cqirq_pend_idx_k>=hqmproc_cqirqmask_ldbppnum_min && cqirq_pend_idx_k<hqmproc_cqirqmask_ldbppnum_max) && has_cqirq_maskunmask_paral) begin 
                	       `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_CQIRQMASKUNMASK_Parallel_flow[%0d]: Start ... ", cqirq_pend_idx_k),UVM_LOW)  
                   	       `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_CQIRQMASKUNMASK_Parallel_flow_LDBPP[%0d]: Start hqmproc_cqirq_maskunmask_parallel_tasks", cqirq_pend_idx_k),UVM_LOW)	 
                                hqmproc_cqirq_maskunmask_parallel_tasks(1, cqirq_pend_idx_k);  
                   	    end else if((cqirq_pend_idx_k > 63 && cqirq_pend_idx_k < 128) && (cqirq_pend_idx_k>=(64+hqmproc_cqirqmask_dirppnum_min) && cqirq_pend_idx_k<(64+hqmproc_cqirqmask_dirppnum_max))  && has_cqirq_maskunmask_paral) begin     
                	       `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_CQIRQMASKUNMASK_Parallel_flow[%0d]: Start ... ", cqirq_pend_idx_k),UVM_LOW)  
                   	       `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_CQIRQMASKUNMASK_Parallel_flow_DIRPP[%0d]: Start hqmproc_cqirq_maskunmask_parallel_tasks", (cqirq_pend_idx_k-64)),UVM_LOW)	  
                                hqmproc_cqirq_maskunmask_parallel_tasks(0, (cqirq_pend_idx_k-64));    
                   	    end 	   
        	       join_none
        	     end 
        	     wait fork;
                   end else begin
               	      `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_CQIRQMASKUNMASK_Parallel_flow: disabled has_cqirq_maskunmask_paral=0"),UVM_LOW)   
                   end //if(has_cqirq_maskunmask_paral==1
               	   `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_CQIRQMASKUNMASK_Parallel_flow: All_Done ... "),UVM_LOW)   
                end //--level_1_cqirq_pending_ck_parallel
               `endif //`ifdef IP_TYP_TE


        	//---------------------    
        	//--DynamicCfg COS
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+DynamicCfg
                       if(has_lsp_cosrecfg_enable) begin
                          while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_lsp_cosrecfg_hcwnum) begin 
                            wait_idle(has_lsp_cosrecfg_waitnum);
                            `uvm_info(get_full_name(),$psprintf("Main_DynamicCfgCOS_flow: total_enq_count=%0d total_sch_count=%0d has_lsp_cosrecfg_hcwnum=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, has_lsp_cosrecfg_hcwnum),UVM_LOW)    
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_DynamicCfgCOS_flow: Start configure_lsp_cos_task"),UVM_LOW)    
                         configure_lsp_cos_task(hqm_lsp_range_cosrecfg_0_val, hqm_lsp_range_cosrecfg_1_val, hqm_lsp_range_cosrecfg_2_val, hqm_lsp_range_cosrecfg_3_val, hqm_lsp_credit_sat_cos_0_val, hqm_lsp_credit_sat_cos_1_val, hqm_lsp_credit_sat_cos_2_val, hqm_lsp_credit_sat_cos_3_val);
                         `uvm_info(get_full_name(),$psprintf("Main_DynamicCfgCOS_flow: Done"),UVM_LOW)   
                       end 
                end //--level_1_DynamicCfg
               `endif //`ifdef IP_TYP_TE

        	//---------------------
        	//--UnitIdle Checking in cqirq mask case
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+unitidle_check
                       if(has_cqirq_mask_idleck==1) begin
                         while(i_hqm_cfg.hqmproc_trfctrl!=2) begin
                           wait_idle(100);
                           if(i_hqm_cfg.cq_irq_mask_unit_idle_check==1) begin
                              cqirq_mask_wait_unit_idle_task(hqmproc_unitidle_poll_num, 1, 1); //--expect_idle=1; has_report=0
                             `uvm_info(get_full_name(),$psprintf("Main_CQIRQMaskUnitIdleCk_flow: check cont=%0d ", i_hqm_cfg.cq_irq_mask_unit_idle_check),UVM_LOW)   
                           end 
                         end 
                         `uvm_info(get_full_name(),$psprintf("Main_CQIRQMaskUnitIdleCk_flow: Done"),UVM_LOW)   
                       end 
                end 
               `endif //`ifdef IP_TYP_TE

        	//---------------------
        	//--UnitIdle Checking
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+unitidle_check
                       if(hqmproc_unitidle_trfmid_check_enable) begin
                           traffic_unit_idle_check_task(1, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1; has_report=0
                           `uvm_info(get_full_name(),$psprintf("Main_UnitIdleCk_flow: Done"),UVM_LOW)   
                       end 
                end 
               `endif //`ifdef IP_TYP_TE

        	//---------------------
        	//--hwerrinj
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+hwerrinj
                       if(has_hwerrinj_enable) begin
                         `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Start hwerrinj with hwerrinj_waitnum=%0d hwerrinj_loopnum=%0d ", hwerrinj_waitnum, hwerrinj_loopnum),UVM_LOW)    
                          for(int hwerrinj_loop=0; hwerrinj_loop<hwerrinj_loopnum; hwerrinj_loop++) begin 
                             wait_idle(hwerrinj_waitnum);
                             configure_hwerrinj_task(hwerrinj_loop);
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Done"),UVM_LOW)   
                          if(has_force_stop_enable) begin
                            for(int ll=0; ll<has_force_stop_loop; ll++) begin
        	                for(int i=hqmproc_dirppnum_min; i<hqmproc_dirppnum_max; i++) begin
        	                   i_hqm_cfg.i_hqm_pp_cq_status.force_seq_stop(0, i);
                                end 
        	                for(int i=hqmproc_ldbppnum_min; i<hqmproc_ldbppnum_max; i++) begin
        	                   i_hqm_cfg.i_hqm_pp_cq_status.force_seq_stop(1, i);
                                end 
                                i_hqm_cfg.i_hqm_pp_cq_status.force_all_seq_stop();
                               `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Force TrfSeq Stop Done loop=%0d in %0d", ll, has_force_stop_loop),UVM_LOW)   
        	                i_hqm_cfg.i_hqm_pp_cq_status.report_status_upd();
                                wait_idle(has_force_stop_waitnum);
                             end //--for(ll
                          end 
                       end 
                end //--level_1_hwerrinj
               `endif //`ifdef IP_TYP_TE

        	//---------------------
        	//--VASRST_flow
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+vasrst
                       if(hqmproc_vasrst_enable) begin
                         `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow: Start VASRST when getting has_enq_hcw_num_0=%0d has_sch_hcw_num_0=%0d ", has_enq_hcw_num_0, has_sch_hcw_num_0),UVM_LOW)    
                          if($test$plusargs("HQMV30_ATS_INV_TEST")) begin 
                               //---------- VASRESET with ATS_INV		  
                               while(i_hqm_cfg.hqm_atsinvcpl_done==0) begin
                	               wait_idle(100);
                	              `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_1.1: Wait curr_hqm_atsinvcpl_done=%0d to 1, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", i_hqm_cfg.hqm_atsinvcpl_done, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)										       
                               end 

		 	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_2: hqm_atsinvcpl_done=1 - will issue VASRST, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.hqm_atsinvcpl_done, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
                               hqmproc_vasreset_task_main(); 

                          end else begin
                               //---------- Regular VASRESET without ATS_INV		  
                               //--S1: wait and check
                	       wait_idle(2000);				   
                	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_1: wait ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)									       
                               while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_0) begin
                	               wait_idle(500);
                	              `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_1.1: Wait ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)										       
                               end 

		 	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_2: will issue VASRST, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
                               hqmproc_vasreset_task_main(); 

                          end 

                          hqmproc_vasrst_finish=1;
                          `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_3: VASRST done, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
                	  wait_idle(2000);

                       end 
                end //--level_1_vasrst
               `endif //`ifdef IP_TYP_TE

		//-----------------------------------------------------------------------------
		//-- Traffic flow: run any numbder of ldbPP // dirPP
		//-----------------------------------------------------------------------------
                begin //--level_1_trf
		    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_1: Start all trf hqmproc_alltrf_sel=2, hqmproc_ppnum_min=%0d/max=%0d, hqmproc_ldbppnum_min=%0d/max=%0d, hqmproc_dirppnum_min=%0d/max=%0d; i_hqm_cfg.hqmproc_trfctrl=1", hqmproc_ldbppnum_min, hqmproc_ldbppnum_max, hqmproc_ldbppnum_min, hqmproc_ldbppnum_max, hqmproc_dirppnum_min, hqmproc_dirppnum_max),UVM_LOW)	
                    i_hqm_cfg.hqmproc_trfctrl=1; //--indicating trfgen started 

        	    //-- anyPP traffic (0~63: ldbPP) (64~159: dirPP)
        	    //-- ldbPP traffic
        	    for(int i=hqmproc_ppnum_min; i<hqmproc_ppnum_max; i++) begin
        		fork
                	    automatic int k = i;
                	    int           qid_tmp;


                	    waitnum = 1; //$urandom_range(waitnum_max, waitnum_min);
                	    `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Start_PP[%0d]: Start ... wait %0d before start", k, waitnum),UVM_LOW)	  

                            for(int seqloop=0; seqloop<ldb_pp_cq_0_loopnum; seqloop++) begin 

                                //-----------------------------------------------
                                //-----------------------------------------------
                                if(hqmproc_vasrst_trfcont==1 && seqloop==1) begin
                                    if(hqmproc_vasrst_enable) begin
                                       while(hqmproc_vasrst_finish==0) begin
                		            `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Loop_Wait_PP[%0d]: Wait hqmproc_vasrst_finish=1 when seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       
                                            wait_idle(1000);
                                       end 
                                      `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Loop_Wait_PP[%0d]: Done Wait hqmproc_vasrst_finish=1 when seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       
                                    end 
                                end //

                               `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Loop_Cont_PP[%0d]: Start seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       
                                //-----------------------------------------------
                                //-----------------------------------------------
                		if(k <= 63 && (k>=hqmproc_ldbppnum_min && k<hqmproc_ldbppnum_max))begin
                                    //--LDBPP
                		    if(k<32) qid_tmp=k;
                		    else     qid_tmp=k-32;

        			    wait_idle(waitnum); //#1ns;
                		   `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Run_LDBPP[%0d]: Start with qid=%0d seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, qid_tmp, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       

                             		if(has_ldb_pp_cq_trf_2stage && k>=has_ldb_cqdisable_min && k<has_ldb_cqdisable_max) begin
                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S0_LDBPP[%0d]: Disable ldbCQ[%0d]", k, k),UVM_LOW)	     
                	   		    `ifdef IP_TYP_TE 
                                              cfg_cq_disable_task(.is_ldb_in(1), .cq_num_in(k), .disable_in(1));
                                            `endif

                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S1_LDBPP[%0d]: Send ENQ Traffic without check cq_buffer: not to return anything", k),UVM_LOW)     
                	   		    start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(k), .is_vf(0), .vf_num(0), .qid(k), .qtype(QATM), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[k]));       

                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S2.1_LDBPP[%0d]: Pause before Enable ldbCQ[%0d]", k, k),UVM_LOW)  
                	   		    wait_idle(ldb_pp_cq_0_rtnwaitnum); 
                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S2.2_LDBPP[%0d]: Enable ldbCQ[%0d]", k, k),UVM_LOW)       
                	   		    `ifdef IP_TYP_TE 
                	   		    cfg_cq_disable_task(.is_ldb_in(1), .cq_num_in(k), .disable_in(0));
                                            `endif
                	   		    wait_idle(ldb_pp_cq_0_rtnwaitnum); 

                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S3_LDBPP[%0d]: Resume to do return and/or trf cont", k),UVM_LOW)  
                	   		    start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(k), .is_vf(0), .vf_num(0), .qid(k), .qtype(QATM), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(12), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[k]));      
                		            `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Send_S4_LDBPP[%0d]: Done with qid=%0d seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, qid_tmp, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       

                             		end else if(has_ldb_pp_cq_trf_scen2 && k>=has_ldb_cqrtn_min && k<has_ldb_cqrtn_max)begin
                	                     //--Scenario2: ldbPP[k] does return only, cqbuf_init_in=0
                                            wait_idle(ldb_pp_cq_rtnwaitnum);
        	           		    start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(k), .is_vf(0), .vf_num(0), .qid(qid_tmp), .qtype(QUNO), .renq_qid(qid_tmp), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[k]));		       
                		            `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Send_LDBPP[%0d]: RTN-Only Done with qid=%0d seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, qid_tmp, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       
                             		end else begin
        	           		    start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(k), .is_vf(0), .vf_num(0), .qid(qid_tmp), .qtype(QUNO), .renq_qid(qid_tmp), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[k]));		       
                		            `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Send_LDBPP[%0d]: Done with qid=%0d seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, qid_tmp, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       
                             		end			
                		end else if((k > 63 && k < 128) && (k>=(64+hqmproc_dirppnum_min) && k<(64+hqmproc_dirppnum_max)))begin	
                                    //--DIRPP
                		    wait_idle(waitnum);  
                		    `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Run_DIRPP[%0d]: Start with qid=%0d seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, (k-64), seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	  

                             		if(has_dir_pp_cq_trf_2stage && ((k-64)>=has_dir_cqdisable_min) && ((k-64)<has_dir_cqdisable_max)) begin
                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S0_DIRPP[%0d]: Disable dirCQ[%0d]", k-64, k-64),UVM_LOW)	     
                	   		    `ifdef IP_TYP_TE 
                	   		    cfg_cq_disable_task(.is_ldb_in(0), .cq_num_in(k-64), .disable_in(1));
                                            `endif

                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S1_DIRPP[%0d]: Send ENQ Traffic without check cq_buffer: not to return anything", k-64),UVM_LOW)     
                	   		    start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(k-64), .is_vf(0), .vf_num(0), .qid(k-64), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[k-64]));       

                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S2.1_DIRPP[%0d]: Pause before Enable dirCQ[%0d]", k-64, k-64),UVM_LOW)  
                	   		    wait_idle(dir_pp_cq_0_rtnwaitnum); 
                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S2.2_DIRPP[%0d]: Enable dirCQ[%0d]", k-64, k-64),UVM_LOW)       
                	   		    `ifdef IP_TYP_TE 
                	   		    cfg_cq_disable_task(.is_ldb_in(0), .cq_num_in(k-64), .disable_in(0));
                                            `endif
                	   		    wait_idle(dir_pp_cq_0_rtnwaitnum); 

                	   		   `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_Traffic_Send_S3_DIRPP[%0d]: Resume to do return and/or trf cont", k-64),UVM_LOW)  
                	   		    start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(k-64), .is_vf(0), .vf_num(0), .qid(k-64), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(12), .enq_flow_in(has_dir_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[k-64]));    
                		            `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Send_S4_DIRPP[%0d]: Done with qid=%0d seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, (k-64), seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	  
                                        end else begin
        	        	            start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(k-64), .is_vf(0), .vf_num(0), .qid(k-64), .qtype(QDIR), .renq_qid(qid_tmp), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_trf_pp_cq_hqmproc_seq[k-64]));		
                		            `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Send_DIRPP[%0d]: Done with qid=%0d seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, (k-64), seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	  
                                        end 
                		end 
                               `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Loop_Cont_PP[%0d]: Done seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", k, seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)	       
                            end //--for(int seqloop=0 			
                	    `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("Main_Trf_flow_Traffic_Start_PP[%0d]: Done ...", k),UVM_LOW)	  
        		join_none
        	    end //for(int i=hqmproc_ppnum_min; i<hqmproc_ppnum_max; i++)
        	    wait fork;

                     i_hqm_cfg.hqmproc_trfctrl=2; //--indicating trfgen done 
		    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_2: Done all trf hqmproc_alltrf_sel=2, set i_hqm_cfg.hqmproc_trfctrl=2"),UVM_LOW)  

		     //-------------------------------------------------------------------------------------------------------------
		     //-------------------------------------------------------------------------------------------------------------
		     if(hqmproc_return_flow==1) begin
			//-----------------------------------------------------------------------------
			//-- return flow (.cqbuf_init_in(0), .cqbuf_ctrl_in(1),.comp_flow_in(1), .cq_tok_flow_in(1),)
			//-----------------------------------------------------------------------------
			`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_all_3: Start all trf hqmproc_alltrf_sel=2"),UVM_LOW)	

        		  //-- allPP traffic return
        		  for(int i=hqmproc_ppnum_min; i<hqmproc_ppnum_max; i++) begin
        		      fork
                		  automatic int kk = i; 
                        	  if(kk<64) begin			
        	        	     start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(kk), .is_vf(0), .vf_num(0), .qid(kk), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[kk]));
                        	  end else if(kk>63 && kk<128) begin
        	        	     start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(kk-64), .is_vf(0), .vf_num(0), .qid(kk), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_trf_pp_cq_hqmproc_seq[kk-64]));  		
                        	  end			
        		      join_none
        		  end 
        		  wait fork; 

			`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_all_3: Done return flows hqmproc_alltrf_sel=2"),UVM_LOW)
		     end //--if(hqmproc_return_flow==1

                     i_hqm_cfg.hqmproc_trfctrl=2; //--indicating trfgen done 
        	    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_4: Done all trf hqmproc_alltrf_sel=2, i_hqm_cfg.hqmproc_trfctrl=2"),UVM_LOW)	  

		     //-------------------------------------------------------------------------------------------------------------
		     //-------------------------------------------------------------------------------------------------------------
                   `ifdef IP_TYP_TE
        	    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_5: start wait_unit_idle_task check, poll hqmproc_unitidle_poll_num=%0d", hqmproc_unitidle_poll_num),UVM_LOW)	  
                   
                     if(!$test$plusargs("HQM_ATS_ERRINJ_SKIP_UNITIDLE")) begin
                        wait_unit_idle_task(hqmproc_unitidle_poll_num, 1, 0); //--expect_idle=1; has_report=0
        	       `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_5.1: end wait_unit_idle_task check, poll hqmproc_unitidle_poll_num=%0d", hqmproc_unitidle_poll_num),UVM_LOW)	  
                     end else begin
        	       `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_5.1: skip wait_unit_idle_task check, poll hqmproc_unitidle_poll_num=%0d", hqmproc_unitidle_poll_num),UVM_LOW)	  
                     end 

        	    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_5.2: start hqmproc_eot_check_task hqmproc_alltrf_sel=2"),UVM_LOW)	  
                     hqmproc_eot_check_task_CHP_histlist();
                     hqmproc_eot_check_task_wb_state();
                     hqmproc_eot_check_task_CHP_INTR_IRQ_Poll();
                     hqmproc_eot_check_task_Misc_Count_Poll();  
                     hqmproc_eot_check_task_count();
        	     i_hqm_cfg.i_hqm_pp_cq_status.report_status_upd();
                     hqmproc_trf_eot_check();
        	    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_5.3: end hqmproc_eot_check_task hqmproc_alltrf_sel=2"),UVM_LOW)	  

                     //--PALB direct test check
                     if($test$plusargs("HQM_PALB_SET_0")) begin
                        for (int cqidx = 0 ; cqidx < 8 ; cqidx++) begin
        	           `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_5: PALB +HQM_PALB_SET0 checking  -sch_ldb_num[%0d]=%0d", cqidx, i_hqm_cfg.i_hqm_pp_cq_status.sch_ldb_num[cqidx]),UVM_LOW)	  
                           if(cqidx<7) begin
                              if(i_hqm_cfg.i_hqm_pp_cq_status.sch_ldb_num[cqidx]>0) 
                                  `uvm_error("HQM_PP_CQ_STATUS",$psprintf("ain_Trf_flow_all_4: PALB sch_ldb_num[%0d]=%0d not expected", cqidx, i_hqm_cfg.i_hqm_pp_cq_status.sch_ldb_num[cqidx]))
                           end 
                        end 
                     end if($test$plusargs("HQM_PALB_SET_1")) begin
                        for (int cqidx = 0 ; cqidx < 8 ; cqidx++) begin
        	           `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_5: PALB +HQM_PALB_SET1 checking  -sch_ldb_num[%0d]=%0d", cqidx, i_hqm_cfg.i_hqm_pp_cq_status.sch_ldb_num[cqidx]),UVM_LOW)	  
                           if(cqidx==1 || cqidx==3 || cqidx==5) begin
                              if(i_hqm_cfg.i_hqm_pp_cq_status.sch_ldb_num[cqidx]>0) 
                                  `uvm_error("HQM_PP_CQ_STATUS",$psprintf("ain_Trf_flow_all_4: PALB sch_ldb_num[%0d]=%0d not expected", cqidx, i_hqm_cfg.i_hqm_pp_cq_status.sch_ldb_num[cqidx]))
                           end 
                        end 
                     end //--PALB checking

                     if(has_hwerrinj_scherr_check) begin
                        if(i_hqm_cfg.i_hqm_pp_cq_status.total_sch_err_count==0)
                              `uvm_error(get_full_name(),$psprintf("Main_Trf_flow_all_5_has_hwerrinj_scherr_check=1: i_hqm_cfg.i_hqm_pp_cq_status.total_sch_err_count=0, expect is_error occurred"))
                     end 
                   `endif //`ifdef IP_TYP_TE
                end //--level_1_trf
                join //--level_1_join 

        	`uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_all: Done hqmproc_alltrf_sel=2"),UVM_LOW)
		
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//	
          //-- Case_hqmproc_alltrf_sel=0
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//	  
	  end else if(hqmproc_alltrf_sel==0) begin                 
            //---------------------------------
            //-- Traffics hqmproc_alltrf_sel=0
            //---------------------------------
		//-----------------------------------------------------------------------------
		//-----------------------------------------------------------------------------
		//-- Traffic flow: run 10 ldbPP + 10 dirPP  hqmproc_alltrf_sel=0
		//-----------------------------------------------------------------------------
		//-----------------------------------------------------------------------------
        	`uvm_info(get_full_name(),$psprintf("Trf_flow_all: Start"),UVM_LOW)	
        	fork
        	  //---------------------
        	  //--bgcfg
        	  //---------------------    
                 `ifdef IP_TYP_TE
                  begin
                     if(has_bgcfg_enable==1 && !$test$plusargs("hqmproc_bgcfg_disabled")) begin
                        wait_idle(bgcfg_waitnum);
                       `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Start bg_cfg_seq"),UVM_LOW)    
                       `uvm_do(bg_cfg_seq)
                       `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Done"),UVM_LOW)   
                     end else if(has_bgcfg_enable==2 && !$test$plusargs("hqmproc_bgcfg_disabled")) begin
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Start bgcfg with bgcfg_waitnum=%0d bgcfg_loopnum=%0d ", bgcfg_waitnum, bgcfg_loopnum),UVM_LOW)    
                          for(int bgcfg_loop=0; bgcfg_loop<bgcfg_loopnum; bgcfg_loop++) begin 
                             if(i_hqm_cfg.hqmproc_trfctrl!=2) begin
                                wait_idle(bgcfg_waitnum);
                               `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Process bgcfg_loop=%0d in bgcfg_loopnum=%0d ", bgcfg_loop, bgcfg_loopnum),UVM_LOW)    
                                backgroundcfg_access_sel_task();
                             end 
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Done"),UVM_LOW)
                     end 
                  end 
                 `endif //`ifdef IP_TYP_TE
          	  //---------------------    
          	  //--DynamicCfg COS
        	  //---------------------    
                 `ifdef IP_TYP_TE
                  begin //--level_1+DynamicCfg
                       if(has_lsp_cosrecfg_enable) begin
                          while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_lsp_cosrecfg_hcwnum) 
                            wait_idle(has_lsp_cosrecfg_waitnum);

                         `uvm_info(get_full_name(),$psprintf("Main_DynamicCfgCOS_flow: Start configure_lsp_cos_task"),UVM_LOW)    
                         configure_lsp_cos_task(hqm_lsp_range_cosrecfg_0_val, hqm_lsp_range_cosrecfg_1_val, hqm_lsp_range_cosrecfg_2_val, hqm_lsp_range_cosrecfg_3_val, hqm_lsp_credit_sat_cos_0_val, hqm_lsp_credit_sat_cos_1_val, hqm_lsp_credit_sat_cos_2_val, hqm_lsp_credit_sat_cos_3_val);
                         `uvm_info(get_full_name(),$psprintf("Main_DynamicCfgCOS_flow: Done"),UVM_LOW)   
                       end 
                  end //--level_1_DynamicCfg
                 `endif //`ifdef IP_TYP_TE

        	  //---------------------
          	  //--UnitIdle Checking
        	  //---------------------    
                 `ifdef IP_TYP_TE
                  begin //--level_1+unitidle_check
                       if(hqmproc_unitidle_trfmid_check_enable) begin
                           traffic_unit_idle_check_task(1, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1; has_report=0
                           `uvm_info(get_full_name(),$psprintf("Main_UnitIdleCk_flow: Done"),UVM_LOW)   
                       end 
                  end 
                 `endif //`ifdef IP_TYP_TE

          	  //---------------------
        	  //--hwerrinj
          	  //---------------------    
                 `ifdef IP_TYP_TE
                  begin //--level_1+hwerrinj
                       if(has_hwerrinj_enable) begin
                         `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Start hwerrinj with hwerrinj_waitnum=%0d hwerrinj_loopnum=%0d ", hwerrinj_waitnum, hwerrinj_loopnum),UVM_LOW)    
                          for(int hwerrinj_loop=0; hwerrinj_loop<hwerrinj_loopnum; hwerrinj_loop++) begin 
                             wait_idle(hwerrinj_waitnum);
                             configure_hwerrinj_task(hwerrinj_loop);
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Done"),UVM_LOW)   
                          if(has_force_stop_enable) begin
        	             for(int i=hqmproc_dirppnum_min; i<hqmproc_dirppnum_max; i++) begin
        	                 i_hqm_cfg.i_hqm_pp_cq_status.force_seq_stop(0, i);
                             end 
        	             for(int i=hqmproc_ldbppnum_min; i<hqmproc_ldbppnum_max; i++) begin
        	                 i_hqm_cfg.i_hqm_pp_cq_status.force_seq_stop(1, i);
                             end 
                             i_hqm_cfg.i_hqm_pp_cq_status.force_all_seq_stop();
                            `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Force TrfSeq Stop Done"),UVM_LOW)   
        	             i_hqm_cfg.i_hqm_pp_cq_status.report_status_upd();

                             hqmproc_trf_eot_check();

                             
                          end 
                       end 
                  end //--level_1_hwerrinj
                 `endif //`ifdef IP_TYP_TE

        	  //---------------------
          	  //--vasrst_flow
          	  //---------------------    
                 `ifdef IP_TYP_TE
                  begin //--level_1+vasrst
                       if(hqmproc_vasrst_enable) begin
                         `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow: Start VASRST when getting has_enq_hcw_num_0=%0d has_sch_hcw_num_0=%0d ", has_enq_hcw_num_0, has_sch_hcw_num_0),UVM_LOW)    
                               //---------- 			  
                               //--S1: wait and check
                	       wait_idle(2000);				   
                	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_1: wait ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)									       
                               while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_0) begin
                	               wait_idle(500);
                	              `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_1.1: Wait ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)										       
                               end 

		 	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_2: will issue VASRST, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
                               hqmproc_vasreset_task_main(); 

		 	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_3: VASRST done, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
                	       wait_idle(2000);

                       end 
                  end //--level_1_vasrst
                 `endif //`ifdef IP_TYP_TE

        	  //---------------------
        	  //--watchdog on trfgen
        	  //---------------------    

        	  //---------------------
        	  //--LDBPP
        	  //---------------------    
        	  begin
                     i_hqm_cfg.hqmproc_trfctrl=1; //--indicating trfgen started 
                     for(int seqloop=0; seqloop<ldb_pp_cq_0_loopnum; seqloop++) begin 		  
        		  wait_idle(ldb_pp_cq_0_waitnum); //#1ns;
        		  `uvm_info(get_full_name(),$psprintf("Trf_flow_0: Start seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)
			  	
      	        	  if(hqmproc_sel==0) begin
                	    start_pp_cq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_0_qidin), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_0_seq));
        		  end else begin
                	    if(has_ldb_pp_cq_trf_2stage) begin
                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S0: Disable ldbCQ[0]"),UVM_LOW)	
                              `ifdef IP_TYP_TE 
                	       cfg_cq_disable_task(.is_ldb_in(1), .cq_num_in(0), .disable_in(1));
                              `endif

                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: Send ENQ Traffic without check cq_buffer: not to return anything"),UVM_LOW)	
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_0_qidin), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	

                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Pause and Enable ldbCQ[0]"),UVM_LOW)	
                	       wait_idle(500);
                              `ifdef IP_TYP_TE 
                	       cfg_cq_disable_task(.is_ldb_in(1), .cq_num_in(0), .disable_in(0));
                              `endif
                	       wait_idle(ldb_pp_cq_0_rtnwaitnum); 

                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S3: Resume to do return and/or trf cont"),UVM_LOW)	
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_0_qidin), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	

                	    end else if(has_ldb_pp_cq_0_trf_ord) begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_0_qidin), .qtype(QORD), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	
                	    end else begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_0_qidin), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	
                	    end 
        		  end 
        		  `uvm_info(get_full_name(),$psprintf("Trf_flow_0: Done seqloop=%0d in ldb_pp_cq_0_loopnum=%0d", seqloop, ldb_pp_cq_0_loopnum),UVM_LOW)
                     end //--for(seqloop			  
        	  end 

        	  begin
        	    wait_idle(ldb_pp_cq_1_waitnum); //#3ns;
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_1: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin	
                	start_pp_cq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_1_qidin), .qtype(QATM), .renq_qid(1), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_1_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_1_qidin), .qtype(QATM), .renq_qid(1), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_1_seq));	
        	    end	
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_1: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(ldb_pp_cq_2_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_2: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_2_qidin), .qtype(QUNO), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_2_seq));
        	    end else begin
                       if(has_ldb_pp_cq_2_trf_scen2) begin
                	   //--Scenario2: ldbPP[2] does return only, cqbuf_init_in=0
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_2_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_2_seq));	
                       end else begin
                         start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_2_qidin), .qtype(QUNO), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_2_seq));	
                       end 
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_2: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(ldb_pp_cq_3_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_3: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_3_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_3_seq));
        	    end else begin
                       if(has_ldb_pp_cq_3_trf_scen2) begin
                	   //--Scenario2: ldbPP[3] does return only, cqbuf_init_in=0
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_3_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_3_seq));	
                       end else begin
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_3_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_3_seq));	
                       end 
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_3: Done"),UVM_LOW)
        	  end 

        	  begin
        	    wait_idle(ldb_pp_cq_4_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_4: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_4_qidin), .qtype(QUNO), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_4_seq));
        	    end else begin
                       if(has_ldb_pp_cq_4_trf_scen2) begin
                	   //--Scenario2: ldbPP[4] does return only, cqbuf_init_in=0
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_4_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_4_seq));	
                       end else begin
                          start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_4_qidin), .qtype(QUNO), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_4_seq));	
                       end 
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_4: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(ldb_pp_cq_5_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_5: Start"),UVM_LOW)	
        	   if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_5_qidin), .qtype(QUNO), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_5_seq));
        	    end else begin
                       if(has_ldb_pp_cq_5_trf_scen2) begin
                	   //--Scenario2: ldbPP[5] does return only, cqbuf_init_in=0
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_5_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_5_seq));	
                       end else begin
                         start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_5_qidin), .qtype(QUNO), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_5_seq));	
                       end 
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_5: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(ldb_pp_cq_6_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_6: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_6_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_6_seq));
        	    end else begin
                       if(has_ldb_pp_cq_6_trf_scen2) begin
                	   //--Scenario2: ldbPP[6] does return only, cqbuf_init_in=0
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_6_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_6_seq));	
                       end else begin
                           start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_6_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_6_seq));	
                       end 
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_6: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(ldb_pp_cq_7_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_7: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_7_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_7_seq));
        	    end else begin
                       if(has_ldb_pp_cq_7_trf_scen2) begin
                	   //--Scenario2: ldbPP[7] does return only, cqbuf_init_in=0
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_7_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_7_seq));	
                       end else begin
                	   start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_7_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_7_seq));	
                       end 
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_7: Done"),UVM_LOW)
        	  end            
        	  begin
        	    wait_idle(ldb_pp_cq_8_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_8: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_8_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_8_seq));
        	    end else begin
                       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_8_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_8_seq));	
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_8: Done"),UVM_LOW)
        	  end              
        	  begin
        	    wait_idle(ldb_pp_cq_9_waitnum);  
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_9: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                       start_pp_cq(.is_ldb(1), .pp_cq_num_in(9), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_9_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_9_seq));
        	    end else begin
                       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(9), .is_vf(0), .vf_num(0), .qid(ldb_pp_cq_9_qidin), .qtype(QATM), .renq_qid(2), .renq_qtype(QATM), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_9_seq));	
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_9: Done"),UVM_LOW)
        	  end  

        	  //---------------------
        	  //--DIRPP
        	  //---------------------      
        	  begin
        	    wait_idle(dir_pp_cq_0_waitnum); 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_0: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_0_qidin), .qtype(QDIR), .renq_qid(0), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_0_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_0_qidin), .qtype(QDIR), .renq_qid(0), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_0_seq));	
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_0: Done"),UVM_LOW)	
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_1_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_1: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_1_qidin), .qtype(QDIR), .renq_qid(1), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_1_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_1_qidin), .qtype(QDIR), .renq_qid(1), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_1_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_1: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_2_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_2: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_2_qidin), .qtype(QDIR), .renq_qid(2), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_2_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_2_qidin), .qtype(QDIR), .renq_qid(2), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_2_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_2: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_3_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_3: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_3_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_3_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_3_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_3_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_3: Done"),UVM_LOW)
        	  end 

        	  begin
        	    wait_idle(dir_pp_cq_4_waitnum); 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_4: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_4_qidin), .qtype(QDIR), .renq_qid(0), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_4_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_4_qidin), .qtype(QDIR), .renq_qid(0), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_4_seq));	
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_4: Done"),UVM_LOW)	
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_5_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_5: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_5_qidin), .qtype(QDIR), .renq_qid(1), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_5_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_5_qidin), .qtype(QDIR), .renq_qid(1), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_5_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_5: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_6_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_6: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_6_qidin), .qtype(QDIR), .renq_qid(2), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_6_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_6_qidin), .qtype(QDIR), .renq_qid(2), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_6_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_6: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_7_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_7: Start"),UVM_LOW)	
      		    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_7_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_7_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_7_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_7_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_7: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_8_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_8: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_8_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_8_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_8_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_8_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_8: Done"),UVM_LOW)
        	  end 
        	  begin
        	    wait_idle(dir_pp_cq_9_waitnum);
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_9: Start"),UVM_LOW)	
        	    if(hqmproc_sel==0) begin
                	start_pp_cq(.is_ldb(0), .pp_cq_num_in(9), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_9_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_9_seq));
        	    end else begin
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(9), .is_vf(0), .vf_num(0), .qid(dir_pp_cq_9_qidin), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_9_seq));
        	    end 
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_9: Done"),UVM_LOW)
        	  end 

                  //--dir62
        	  begin
                    if($test$plusargs("hqmproc_alltrf_upvsel")) begin
        	        wait_idle(dir_pp_cq_0_waitnum);
        	       `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_62: Start"),UVM_LOW)	
                        start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(hqm_pkg::NUM_DIR_CQ-2), .is_vf(0), .vf_num(0), .qid(hqm_pkg::NUM_DIR_CQ-2), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_62_seq));
        	       `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_62: Done"),UVM_LOW)
                     end 
        	  end 

                  //--dir63
        	  begin
                    if($test$plusargs("hqmproc_alltrf_upvsel")) begin
        	        wait_idle(dir_pp_cq_1_waitnum);
        	       `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_63: Start"),UVM_LOW)	
                        start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(hqm_pkg::NUM_DIR_CQ-1), .is_vf(0), .vf_num(0), .qid(hqm_pkg::NUM_DIR_CQ-1), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_63_seq));
        	       `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_63: Done"),UVM_LOW)
                     end 
        	  end 

                  //--dir95
        	  //begin
                  //  if($test$plusargs("hqmproc_alltrf_upvsel")) begin
        	  //      wait_idle(dir_pp_cq_2_waitnum);
        	  //     `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_95: Start"),UVM_LOW)	
                  //      start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(95), .is_vf(0), .vf_num(0), .qid(95), .qtype(QDIR), .renq_qid(3), .renq_qtype(QDIR), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_95_seq));
        	  //     `uvm_info(get_full_name(),$psprintf("Trf_flow_dir_95: Done"),UVM_LOW)
                  //   end 
        	  //end 


        	 join
        	`uvm_info(get_full_name(),$psprintf("Trf_flow_all: Done, i_hqm_cfg.hqmproc_trfctrl=2"),UVM_LOW)	
                 i_hqm_cfg.hqmproc_trfctrl=2; //--indicating trfgen done 

        	 //-------------------------------------------------------------------------------------------------------------
        	 //-------------------------------------------------------------------------------------------------------------
                 if(hqmproc_return_flow==1) begin
      		   //-----------------------------------------------------------------------------
        	   //-- return flow (.cqbuf_init_in(0), .cqbuf_ctrl_in(1),.comp_flow_in(1), .cq_tok_flow_in(1),)
      		   //-----------------------------------------------------------------------------
        	   `uvm_info(get_full_name(),$psprintf("Trf_flowrtn_all: Start"),UVM_LOW)	
        	   fork
      		   //---------------------
      		   //--LDBPP
      		   //---------------------    
      		   begin
                	wait_idle(ldb_pp_cq_0_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_0: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_0: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(ldb_pp_cq_1_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_1: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_1_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_1: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(ldb_pp_cq_2_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_2: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_1_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_2: Done"),UVM_LOW)	  
      		   end 
      		   begin
                	wait_idle(ldb_pp_cq_3_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_3: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_3_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_3: Done"),UVM_LOW)	  
      		   end 
      		   begin
                	wait_idle(ldb_pp_cq_4_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_4: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_4_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_4: Done"),UVM_LOW)	  
      		   end 
      		   begin
                	wait_idle(ldb_pp_cq_5_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_5: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_5_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_5: Done"),UVM_LOW)	  
      		   end 	  
      		   begin
                	wait_idle(ldb_pp_cq_6_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_6: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_6_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_6: Done"),UVM_LOW)	  
      		   end 	  
      		   begin
                	wait_idle(ldb_pp_cq_7_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_7: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_7_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_7: Done"),UVM_LOW)	  
      		   end 	  
      		   begin
                	wait_idle(ldb_pp_cq_8_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_8: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_8_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_8: Done"),UVM_LOW)	  
      		   end 
        	   begin
                	wait_idle(ldb_pp_cq_9_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_9: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(9), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_9_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_9: Done"),UVM_LOW)	  
      		   end 

      		   //---------------------
      		   //--DIRPP
      		   //---------------------      
      		   begin
                	wait_idle(dir_pp_cq_0_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_0: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_0_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_0: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(dir_pp_cq_1_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_1: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_1_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_1: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(dir_pp_cq_2_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_2: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_2_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_2: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(dir_pp_cq_3_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_3: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_3_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_3: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(dir_pp_cq_4_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_4: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_4_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_4: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(dir_pp_cq_5_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_5: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_5_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_5: Done"),UVM_LOW)
      		   end	
      		   begin
                	wait_idle(dir_pp_cq_6_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_6: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_6_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_6: Done"),UVM_LOW)
      		   end	    	  
      		   begin
                	wait_idle(dir_pp_cq_7_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_7: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_7_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_7: Done"),UVM_LOW)
      		   end 
      		   begin
                	wait_idle(dir_pp_cq_8_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_8: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(8), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_8_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_8: Done"),UVM_LOW)
      		   end	  
      		   begin
                	wait_idle(dir_pp_cq_9_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_9: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(9), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_9_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_9: Done"),UVM_LOW)
      		   end 

                   //--dir64
        	   begin
                       if($test$plusargs("hqmproc_alltrf_upvsel")) begin
                	wait_idle(dir_pp_cq_0_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_62: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(hqm_pkg::NUM_DIR_CQ-2), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_62_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_62: Done"),UVM_LOW)
                       end 
        	   end 

                   //--dir63
        	   begin
                       if($test$plusargs("hqmproc_alltrf_upvsel")) begin
                	wait_idle(dir_pp_cq_1_rtnwaitnum);  
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_63: Start"),UVM_LOW)   
                	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(hqm_pkg::NUM_DIR_CQ-1), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_63_seq));	             
                	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_63: Done"),UVM_LOW)
                       end 
        	   end 

                   //--dir95
        	   //begin
                   //    if($test$plusargs("hqmproc_alltrf_upvsel")) begin
                //	wait_idle(dir_pp_cq_2_rtnwaitnum);  
                //	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_95: Start"),UVM_LOW)   
                //	start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(95), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_95_seq));	             
                //	`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_dir_95: Done"),UVM_LOW)
                //       end 
        	//   end 

      		   join    
        	  `uvm_info(get_full_name(),$psprintf("Trf_flowrtn_all: Done hqmproc_alltrf_sel=0"),UVM_LOW)
        	 end //--if(hqmproc_return_flow==1

		 //-------------------------------------------------------------------------------------------------------------
		 //-------------------------------------------------------------------------------------------------------------
                 i_hqm_cfg.hqmproc_trfctrl=2; //--indicating trfgen done 
        	 `uvm_info(get_full_name(),$psprintf("Trf_flowrtn_all::: start wait_unit_idle_task check, poll hqmproc_unitidle_poll_num=%0d, i_hqm_cfg.hqmproc_trfctrl=2 hqmproc_alltrf_sel=0", hqmproc_unitidle_poll_num),UVM_LOW)	  
                 `ifdef IP_TYP_TE
                  wait_unit_idle_task(hqmproc_unitidle_poll_num, 1, 0); //--expect_idle=1; has_report=0

                 `uvm_info(get_full_name(),$psprintf("Trf_flowrtn_all:: start hqmproc_eot_check_task hqmproc_alltrf_sel=0"),UVM_LOW)	  
                 hqmproc_eot_check_task_CHP_histlist();
                 hqmproc_eot_check_task_wb_state();
                 hqmproc_eot_check_task_CHP_INTR_IRQ_Poll();
                 hqmproc_eot_check_task_Misc_Count_Poll();  
                 hqmproc_eot_check_task_count();
        	 i_hqm_cfg.i_hqm_pp_cq_status.report_status_upd();
                 hqmproc_trf_eot_check();
                 `endif //`ifdef IP_TYP_TE

                 if(has_hwerrinj_scherr_check) begin
                      if(i_hqm_cfg.i_hqm_pp_cq_status.total_sch_err_count==0)
                              `uvm_error(get_full_name(),$psprintf("Main_Trf_flow_all_has_hwerrinj_scherr_check=1: i_hqm_cfg.i_hqm_pp_cq_status.total_sch_err_count=0, expect is_error occurred"))
                 end 



		 if(hqmproc_wuctl_schcnt_check > 0) begin
        	    `uvm_info(get_full_name(),$psprintf("Trf_flow_all_all: Done : check WU control results hqmproc_wuctl_schcnt_check=%0d", hqmproc_wuctl_schcnt_check),UVM_LOW)  
        	     for(int ldbcqid=0; ldbcqid<4; ldbcqid++) begin
                       `uvm_info(get_full_name(),$psprintf("Trf_flow_all_all: check WU control results ldb_pp_cq_status[%0d].st_sch_ckcurrcnt=%0d, hqmproc_wuctl_schcnt_diff=%0d", ldbcqid, i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[ldbcqid].st_sch_ckcurrcnt, hqmproc_wuctl_schcnt_diff),UVM_LOW)
                       `uvm_info(get_full_name(),$psprintf("Trf_flow_all_all: check WU control results ldb_pp_cq_status[%0d].st_sch_cnt=%0d", ldbcqid, i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[ldbcqid].st_sch_cnt),UVM_LOW)
        	     end              

        	     if(hqmproc_wuctl_schcnt_check==1) begin
                	   if((i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[0].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[1].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff)) ||
                              (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[0].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[3].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff)) ||
                              (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[2].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[1].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff)) ||
                              (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[2].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[3].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff))) begin 
                              `uvm_error(get_full_name(),$psprintf("Trf_flow_all_all: check WU control results expect cq[0]/[2] receive less hcws, check!"))
                	   end 
        	     end 
        	     if(hqmproc_wuctl_schcnt_check==2) begin
                	   if((i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[1].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[0].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff)) ||
                              (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[1].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[2].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff)) ||
                              (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[3].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[0].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff)) ||
                              (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[3].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[2].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff))) begin 
                              `uvm_error(get_full_name(),$psprintf("Trf_flow_all_all: check WU control results expect cq[1]/[3] receive less hcws, check!"))
                	   end 
        	     end 
        	     if(hqmproc_wuctl_schcnt_check==3) begin
                	   if((i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[1].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[0].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff)) ||
                              (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[1].st_sch_ckcurrcnt > (i_hqm_cfg.i_hqm_pp_cq_status.ldb_pp_cq_status[2].st_sch_ckcurrcnt - hqmproc_wuctl_schcnt_diff))) begin 
                              `uvm_error(get_full_name(),$psprintf("Trf_flow_all_all: check WU control results expect cq[1] receive less hcws, check!"))
                	   end 
        	     end 
		 end //--if(hqmproc_wuctl_schcnt_check



        	`uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_all: Done hqmproc_alltrf_sel=0"),UVM_LOW)
		 
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//	  
          //-- Case_hqmproc_alltrf_sel=1
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//
	  //----------------------------------------------------------------------------------------------------------------------------------------------------------//	  
	  end else if(hqmproc_alltrf_sel==1) begin 
            //---------------------------------
            //-- Traffics hqmproc_alltrf_sel=1
            //---------------------------------
	        fork	
        	//---------------------
        	//--bgcfg
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+bgcfg
                       if(has_bgcfg_enable==1 && !$test$plusargs("hqmproc_bgcfg_disabled")) begin
                          wait_idle(bgcfg_waitnum);
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Start bg_cfg_seq"),UVM_LOW)    
                         `uvm_do(bg_cfg_seq)
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Done"),UVM_LOW)   
                       end else if(has_bgcfg_enable==2 && !$test$plusargs("hqmproc_bgcfg_disabled")) begin
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Start bgcfg with bgcfg_waitnum=%0d bgcfg_loopnum=%0d ", bgcfg_waitnum, bgcfg_loopnum),UVM_LOW)    
                          for(int bgcfg_loop=0; bgcfg_loop<bgcfg_loopnum; bgcfg_loop++) begin 
                             if(i_hqm_cfg.hqmproc_trfctrl!=2) begin
                                wait_idle(bgcfg_waitnum);
                               `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Process bgcfg_loop=%0d in bgcfg_loopnum=%0d ", bgcfg_loop, bgcfg_loopnum),UVM_LOW)    
                                backgroundcfg_access_sel_task();
                             end 
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_BGCFG_flow: Done"),UVM_LOW)
                       end 
                end //--level_1_bgcfg
               `endif //`ifdef IP_TYP_TE
			  
        	//---------------------
        	//--DynamicCfg COS
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+DynamicCfg
                       if(has_lsp_cosrecfg_enable) begin
                          while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_lsp_cosrecfg_hcwnum) 
                            wait_idle(has_lsp_cosrecfg_waitnum);

                         `uvm_info(get_full_name(),$psprintf("Main_DynamicCfgCOS_flow: Start configure_lsp_cos_task"),UVM_LOW)    
                         configure_lsp_cos_task(hqm_lsp_range_cosrecfg_0_val, hqm_lsp_range_cosrecfg_1_val, hqm_lsp_range_cosrecfg_2_val, hqm_lsp_range_cosrecfg_3_val, hqm_lsp_credit_sat_cos_0_val, hqm_lsp_credit_sat_cos_1_val, hqm_lsp_credit_sat_cos_2_val, hqm_lsp_credit_sat_cos_3_val);
                         `uvm_info(get_full_name(),$psprintf("Main_DynamicCfgCOS_flow: Done"),UVM_LOW)   
                       end 
                end //--level_1_DynamicCfg
               `endif //`ifdef IP_TYP_TE
			  
        	//---------------------
        	//--UnitIdle Checking
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+unitidle_check
                       if(hqmproc_unitidle_trfmid_check_enable) begin
                           traffic_unit_idle_check_task(1, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1; has_report=0
                           `uvm_info(get_full_name(),$psprintf("Main_UnitIdleCk_flow: Done"),UVM_LOW)   
                       end 
                end 
               `endif //`ifdef IP_TYP_TE

        	//---------------------
        	//--hwerrinj
        	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+hwerrinj
                       if(has_hwerrinj_enable) begin
                         `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Start hwerrinj with hwerrinj_waitnum=%0d hwerrinj_loopnum=%0d ", hwerrinj_waitnum, hwerrinj_loopnum),UVM_LOW)    
                          for(int hwerrinj_loop=0; hwerrinj_loop<hwerrinj_loopnum; hwerrinj_loop++) begin 
                             wait_idle(hwerrinj_waitnum);
                             configure_hwerrinj_task(hwerrinj_loop);
                          end 
                         `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Done"),UVM_LOW)   
                          if(has_force_stop_enable) begin
        	             for(int i=hqmproc_dirppnum_min; i<hqmproc_dirppnum_max; i++) begin
        	                 i_hqm_cfg.i_hqm_pp_cq_status.force_seq_stop(0, i);
                             end 
        	             for(int i=hqmproc_ldbppnum_min; i<hqmproc_ldbppnum_max; i++) begin
        	                 i_hqm_cfg.i_hqm_pp_cq_status.force_seq_stop(1, i);
                             end 
                             i_hqm_cfg.i_hqm_pp_cq_status.force_all_seq_stop();
                            `uvm_info(get_full_name(),$psprintf("Main_HWERRINJ_flow: Force TrfSeq Stop Done"),UVM_LOW)   
        	             i_hqm_cfg.i_hqm_pp_cq_status.report_status_upd();
                             hqmproc_trf_eot_check();
                          end 
                       end 
                end //--level_1_hwerrinj
               `endif //`ifdef IP_TYP_TE


        	//---------------------
          	//--vasrst_flow
          	//---------------------    
               `ifdef IP_TYP_TE
                begin //--level_1+vasrst
                       if(hqmproc_vasrst_enable) begin
                         `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow: Start VASRST when getting has_enq_hcw_num_0=%0d has_sch_hcw_num_0=%0d ", has_enq_hcw_num_0, has_sch_hcw_num_0),UVM_LOW)    
                               //---------- 			  
                               //--S1: wait and check
                	       wait_idle(2000);				   
                	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_1: wait ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)									       
                               while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_0) begin
                	               wait_idle(500);
                	              `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_1.1: Wait ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)										       
                               end 

		 	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_2: will issue VASRST, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
                               hqmproc_vasreset_task_main(); 

		 	       `uvm_info(get_full_name(),$psprintf("Main_VASRST_flow_3: VASRST done, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
                	       wait_idle(2000);

                       end 
                end //--level_1_vasrst
               `endif //`ifdef IP_TYP_TE

		//-----------------------------------------------------------------------------
		//-- Traffic flow: run any numbder of dirPP + ldbPP
		//-----------------------------------------------------------------------------
                begin //--level_1_trf		
		    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_1: Start all trf hqmproc_alltrf_sel=1, i_hqm_cfg.hqmproc_trfctrl=1"),UVM_LOW)
                		    	
                    i_hqm_cfg.hqmproc_trfctrl=1; //--indicating trfgen started 
		    
                    //----------------------------------------------------
                    //-- direct_test_0==1 (this method doesn't work for all cases) 	
                    //----------------------------------------------------		    	    		    
                    if(has_direct_test_0==1) begin  
                            //----------			       
                            //--S1: TRF: Start DIRPP[0] and LDBPP[0] traffic, start to run LDBPP[1] ~ LDBPP[7] also without traffic	                             
                	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: Send ENQ Traffic from DIRPP[0] dir_pp_cq_hqmproc_0_seq and LDBPP[0] ldb_pp_cq_hqmproc_0_seq without returning anything"),UVM_LOW)	
                            fork 
                            begin			                              			      
                	       start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_0_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: dir_pp_cq_hqmproc_0_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_0_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(1), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_1_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_1_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(2), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_2_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_2_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(3), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_3_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_3_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(3), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_4_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_4_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(3), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_5_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_5_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(3), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_6_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_6_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(3), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_7_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_7_seq Done"),UVM_LOW)				    			    			    
                            end 			    			    			    			    			    			    			  
                            join_none

                            //----------			       
                            //--S2: wait and check
                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Start to wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			    			    
                            while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_0) begin
                	      wait_idle(500);
                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			    			    
                            end 
                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, wait...", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			 
                	    wait_idle(2000);

                            //----------			       
                            //--S3: check unit_idle			       
                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S3: Check unit_idle"),UVM_LOW)	 
                            `ifdef IP_TYP_TE
                            traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                            `endif

                            fork //--S4/S5/S6
                            begin //--S4
                               //----------			       
                               //--S4: TRF: Start DIRPP[1] traffic	                             
                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S4: Send ENQ Traffic from DIRPP[1] dir_pp_cq_hqmproc_1_seq without returning anything"),UVM_LOW) 
                	       start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(4), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(0), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_1_seq));	
                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S4: dir_pp_cq_hqmproc_1_seq Done, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			    			    
                            end //--S4

                            begin //--S5 S6
                	       wait_idle(2000);
                               //----------			       
                               //--S5: wait and check
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Start to wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    	
                               while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_1) begin
                	          wait_idle(500);
                	          `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", has_enq_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    	
                               end 
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, wait...", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			 
                	       wait_idle(2000);
			       	
                               //----------			       
                               //--S6: check unit_idle				       
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S6: Check unit_idle"),UVM_LOW)	 
                               `ifdef IP_TYP_TE
                               traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                               `endif
                            end //--S5 S6
                            join_any //--S4/S5/S6
                	    wait_idle(2000);
			       
                            //----------			       
                            //--S7: RTN: DIRPP[0] return tokens	
               	            `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S7: DIRPP[0] dir_pp_cq_hqmproc_0_seq Start to return "),UVM_LOW)	
                	     start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_0_seq));	
                	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S7: dir_pp_cq_hqmproc_0_seq Done, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)  	
                	     wait_idle(1000);			                       	      
			       
                            //----------			       
                            //--S8: RTN: LDBPP[0] ~ LDBPP[3] return tokens and completions
               	            `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: LDBPP[0]-LDBPP[3] ldb_pp_cq_hqmproc_0_seq ~ ldb_pp_cq_hqmproc_3_seq Start to return "),UVM_LOW)	
                             fork 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: ldb_pp_cq_hqmproc_0_seq Done"),UVM_LOW)				    			    			    
                             end 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_1_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: ldb_pp_cq_hqmproc_1_seq Done"),UVM_LOW)				    			    			    
                             end 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_2_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: ldb_pp_cq_hqmproc_2_seq Done"),UVM_LOW)				    			    			    
                             end 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_3_seq));	    
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: ldb_pp_cq_hqmproc_3_seq Done"),UVM_LOW)				    			    			    
                             end			    			    			    
                             join			    
                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: ldbpp0/1/2/3 seq Done, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    			    			    
                	     wait_idle(1000);
			     
                            //----------			       
                            //--S9: RTN: LDBPP[4] ~ LDBPP[7] return tokens and completions
               	            `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S9: LDBPP[4]-LDBPP[7] ldb_pp_cq_hqmproc_4_seq ~ ldb_pp_cq_hqmproc_7_seq Start to return "),UVM_LOW)	
                             fork 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(4), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_4_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S9: ldb_pp_cq_hqmproc_4_seq Done"),UVM_LOW)				    			    			    
                             end 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(5), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_5_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S9: ldb_pp_cq_hqmproc_5_seq Done"),UVM_LOW)				    			    			    
                             end 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(6), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_6_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S9: ldb_pp_cq_hqmproc_6_seq Done"),UVM_LOW)				    			    			    
                             end 
                             begin			    
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(7), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(has_ldb_pp_cq_trf_2cont), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_7_seq));	    
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S9: ldb_pp_cq_hqmproc_7_seq Done"),UVM_LOW)				    			    			    
                             end			    			    			    
                             join			    
                	     `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S9: ldbpp4/5/6/7 seq Done, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    			    			    
                	     wait_idle(2000);				     			     

                            //----------			       
                            //--S10: wait and check
                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S10: Wait to complete SCH total_sch_count=%0d reach to total_enq_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				  
                            while(i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count < i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count) begin 
                	      wait_idle(500);
                	      `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S10: Wait to complete SCH total_sch_count=%0d reach to total_enq_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				  
                            end 
                	    wait_idle(1000);

                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S10: Check unit_idle"),UVM_LOW)	 
                            `ifdef IP_TYP_TE
                            traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                            `endif
                    end //--direct_test_0==1

                    //----------------------------------------------------
                    //-- direct_test_0==2	
                    //----------------------------------------------------		    	    		    
                    else if(has_direct_test_0==2) begin
                            `ifdef IP_TYP_TE
		            configure_lsp_totinflight_task(hqmproc_tot_inflight_num);
                            `endif
 
                            foreach(i_hqm_cfg.hqmproc_dir_trfctrl[idx]) i_hqm_cfg.hqmproc_dir_trfctrl[idx]=0;   		    
                            foreach(i_hqm_cfg.hqmproc_ldb_trfctrl[idx]) i_hqm_cfg.hqmproc_ldb_trfctrl[idx]=0; 
                            foreach(i_hqm_cfg.hqmproc_dir_tokctrl[idx]) i_hqm_cfg.hqmproc_dir_tokctrl[idx]=0;
                            foreach(i_hqm_cfg.hqmproc_ldb_tokctrl[idx]) i_hqm_cfg.hqmproc_ldb_tokctrl[idx]=0;
                            foreach(i_hqm_cfg.hqmproc_ldb_cmpctrl[idx]) i_hqm_cfg.hqmproc_ldb_cmpctrl[idx]=0;
				     
                            i_hqm_cfg.hqmproc_dir_trfctrl[0]=1;	
                            i_hqm_cfg.hqmproc_ldb_trfctrl[0]=1;	
			    			    	    
                            //----------			       
                            //--S1: TRF: Start DIRPP[0] and LDBPP[0] traffic, start to run LDBPP[1] ~ LDBPP[7] also without traffic	                             
                	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: Send ENQ Traffic from DIRPP[0] dir_pp_cq_hqmproc_0_seq and LDBPP[0] ldb_pp_cq_hqmproc_0_seq without returning anything"),UVM_LOW)	
                            fork 
                            begin			                              			      
                	       start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_0_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: dir_pp_cq_hqmproc_0_seq Done"),UVM_LOW)				    			    			    
                            end 
			    
                            begin			                              			      
                	       start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(4), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_1_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: dir_pp_cq_hqmproc_1_seq Done"),UVM_LOW)				    			    			    
                            end 
			    			    
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_0_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(1), .is_vf(0), .vf_num(0), .qid(1), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_1_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_1_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(2), .is_vf(0), .vf_num(0), .qid(2), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_2_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_2_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(3), .is_vf(0), .vf_num(0), .qid(3), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_3_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_3_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(4), .is_vf(0), .vf_num(0), .qid(4), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_4_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_4_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(5), .is_vf(0), .vf_num(0), .qid(5), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_5_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_5_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(6), .is_vf(0), .vf_num(0), .qid(6), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_6_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_6_seq Done"),UVM_LOW)				    			    			    
                            end 
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(7), .is_vf(0), .vf_num(0), .qid(7), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_7_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_7_seq Done"),UVM_LOW)				    			    			    
                            end 
			    
                            begin			    
                                //----------			       
                                //--S2: wait and check
                	    	wait_idle(5000);				
                	        `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Start to wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			    			    
                                while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_0) begin
                	            wait_idle(500);
                	           `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			    			    
                                end 
                	        `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, wait...", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)				    			 
                	        wait_idle(2000);

                                //----------			       
                                //--S3: check unit_idle			       
                	        `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S3: Check unit_idle"),UVM_LOW)	 
                                `ifdef IP_TYP_TE
                                traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                                `endif
 
                                //----------			       
                                //--S4: turn on DIRPP[1] traffic
                	        `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S4: Turn on DIRPP[1] traffic"),UVM_LOW)					
                                i_hqm_cfg.hqmproc_dir_trfctrl[1]=1;					             
                	    	wait_idle(2000);
				
                            	//----------				
                            	//--S5: wait and check
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Start to wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW) 				 
                            	while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_1) begin
                	    	   wait_idle(500);
                	    	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", has_enq_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)					 
                            	end 
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, wait...", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)							  
                	    	wait_idle(2000);
			    	 
                            	//----------				
                            	//--S6: check unit_idle 				
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S6: Check unit_idle"),UVM_LOW)    
                                `ifdef IP_TYP_TE
                            	traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                                `endif

                            	//----------				
                            	//----------				
                            	//--S7: Turn on DIRPP[0] return
                	        `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S7: Turn on DIRPP[0] token return"),UVM_LOW)					
                                i_hqm_cfg.hqmproc_dir_tokctrl[0]=1;
               		 	wait_idle(500);
				
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S7: Start to wait to complete RTN total_tok_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_tok_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW) 				 
                            	while(i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count < has_tok_hcw_num_0) begin
                	    	   wait_idle(500);
                	    	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S7: Wait to complete ENQ total_tok_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", has_tok_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)					 
                            	end     	
				wait_idle(100);								
		 	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S7: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)					 
               		 
                            	//----------				
                            	//--S7: check unit_idle 				
               		 	wait_idle(2000);
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S7: Check unit_idle"),UVM_LOW)    
                                `ifdef IP_TYP_TE
                            	traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                                `endif

			 
                            	//----------				
                            	//--S8: Turn on LDBPP[0] ~ LDBPP[7] token return
                	        `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: Turn on LDBPP[0]-LDBPP[7] token return"),UVM_LOW)					
                                i_hqm_cfg.hqmproc_ldb_tokctrl[0]=1;
                                i_hqm_cfg.hqmproc_ldb_tokctrl[1]=1;
                                i_hqm_cfg.hqmproc_ldb_tokctrl[2]=1;
                                i_hqm_cfg.hqmproc_ldb_tokctrl[3]=1;
                                i_hqm_cfg.hqmproc_ldb_tokctrl[4]=1;
                                i_hqm_cfg.hqmproc_ldb_tokctrl[5]=1;
                                i_hqm_cfg.hqmproc_ldb_tokctrl[6]=1;
                                i_hqm_cfg.hqmproc_ldb_tokctrl[7]=1;																
               		 	wait_idle(500);
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: Start to wait to complete RTN total_tok_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_tok_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW) 				 
                            	while(i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count < has_tok_hcw_num_1) begin
                	    	   wait_idle(500);
                	    	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: Wait to complete ENQ total_tok_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", has_tok_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)					 
                            	end     	
				wait_idle(100);								
		 	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S8: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)					 
               		 	wait_idle(2000);
			    	 
                            	//----------				
                            	//--S9: check unit_idle 				
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S9: Check unit_idle"),UVM_LOW)    
                                `ifdef IP_TYP_TE
                            	traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                                `endif

					
			 
                            	//----------				
                            	//--S9: Turn on LDBPP[0] ~ LDBPP[7] completion return
                	        `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S10: Turn on LDBPP[0]-LDBPP[7] completion return"),UVM_LOW)					
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[0]=1;
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[1]=1;
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[2]=1;
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[3]=1;
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[4]=1;
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[5]=1;
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[6]=1;
                                i_hqm_cfg.hqmproc_ldb_cmpctrl[7]=1;																
               		 	wait_idle(2000);
                	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S10: Start to wait to complete RTN total_tok_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_cmp_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW) 				 
                            	while(i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count < has_cmp_hcw_num_1) begin
                	    	   wait_idle(1000);
                	    	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S10: Wait to complete ENQ total_cmp_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", has_cmp_hcw_num_1, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)					 
                            	end     	
				wait_idle(100);								
		 	    	`uvm_info(get_full_name(),$psprintf("Trf_flow_0_S10: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)					 
               		 									 
                            end //--S2 -S10			    			    
			    			    			    			    			    			    			    			  
                            join
			    
               		    wait_idle(2000);
			     
                            //----------			    
                            //--S11: check unit_idle				    
                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S11: Check unit_idle"),UVM_LOW)    
                            `ifdef IP_TYP_TE
                            traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                            `endif
 
                    end //--direct_test_0==2
		    
                    //----------------------------------------------------
                    //-- direct_test_0==3  (interactive unit_idle check and BAT_T return)	
                    //----------------------------------------------------		    	    		    
                    else if(has_direct_test_0==3) begin
		    
                            foreach(i_hqm_cfg.hqmproc_dir_trfctrl[idx]) i_hqm_cfg.hqmproc_dir_trfctrl[idx]=0;   		    
                            foreach(i_hqm_cfg.hqmproc_ldb_trfctrl[idx]) i_hqm_cfg.hqmproc_ldb_trfctrl[idx]=0; 
                            foreach(i_hqm_cfg.hqmproc_dir_tokctrl[idx]) i_hqm_cfg.hqmproc_dir_tokctrl[idx]=0;
                            foreach(i_hqm_cfg.hqmproc_ldb_tokctrl[idx]) i_hqm_cfg.hqmproc_ldb_tokctrl[idx]=0;
                            foreach(i_hqm_cfg.hqmproc_ldb_cmpctrl[idx]) i_hqm_cfg.hqmproc_ldb_cmpctrl[idx]=0;
				     
                            i_hqm_cfg.hqmproc_ldb_trfctrl[0]=1;	 
			    			    	    
                            //----------			       
                            //--S1: TRF: Start DIRPP[0] and LDBPP[0] 	                             
                	   `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: Send ENQ Traffic from DIRPP[0] dir_pp_cq_hqmproc_0_seq and LDBPP[0] ldb_pp_cq_hqmproc_0_seq without returning anything"),UVM_LOW)	
                            fork 
                            begin			                              			      
                	       start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QUNO), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_pp_cq_hqmproc_0_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: dir_pp_cq_hqmproc_0_seq Done"),UVM_LOW)				    			    			    
                            end  		    
                            begin
                	       start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(0), .is_vf(0), .vf_num(0), .qid(0), .qtype(QDIR), .renq_qid(0), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(1), .cqbuf_init_in(1), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_pp_cq_hqmproc_0_seq));	
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S1: ldb_pp_cq_hqmproc_0_seq Done"),UVM_LOW)				    			    			    
                            end  
                            begin
                               //---------- 			  
                               //--S2: wait and check
                	       wait_idle(2000);				   
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Start to wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)									       
                               while(i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count < has_enq_hcw_num_0) begin
                	               wait_idle(500);
                	              `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Wait to complete ENQ total_enq_count reach to %0d, Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d", has_enq_hcw_num_0, i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)										       
                               end 
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S2: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, wait...", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count),UVM_LOW)						    
                	       wait_idle(2000);

                               //---------- 			  
                               //--S3: check unit_idle			  
                	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S3: Check unit_idle"),UVM_LOW)   
                               `ifdef IP_TYP_TE
                               traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                               `endif
		 	       `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S3: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
 
                               while(i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count < has_tok_hcw_num_1) begin			    			    
                                   //---------- 			   
                                   //---------- 			   
                                   //--S4: Turn on DIRPP[0] return
                	           `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S4: Turn on DIRPP[0] token return"),UVM_LOW) 				   
                                   i_hqm_cfg.hqmproc_dir_tokctrl[0]=2;
               		      	   wait_idle(300);
		 	           `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S4: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    
               		 
                                   //---------- 			   
                                   //--S5: check unit_idle				   
               		      	   wait_idle(1000);
                	           `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Check unit_idle"),UVM_LOW)    
                                   `ifdef IP_TYP_TE
                                   traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                                   `endif
		 	           `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S5: Get Curr ENQ total_enq_count=%0d, SCH total_sch_count=%0d, RTN total_tok_count=%0d total_cmp_count=%0d", i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count, i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count, i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count, i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count),UVM_LOW)				    

                               end //--while 		 
                            end //--S2 -S5			    			    
			    			    			    			    			    			    			    			  
                            join
			    
               		    wait_idle(2000);
			     
                            //----------			    
                            //--S6: check unit_idle				    
                	    `uvm_info(get_full_name(),$psprintf("Trf_flow_0_S6: Check unit_idle"),UVM_LOW)    
                            `ifdef IP_TYP_TE
                            traffic_unit_idle_check_task(0, hqmproc_unitidle_poll_num, hqmproc_unitidle_trfmid_expect_idle, hqmproc_unitidle_trfmid_report); //--expect_idle=1
                            `endif
 
                    end //--direct_test_0==3		    		              	     

		    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_2: Done all trf hqmproc_alltrf_sel=1, set i_hqm_cfg.hqmproc_trfctrl=2"),UVM_LOW)  
                     i_hqm_cfg.hqmproc_trfctrl=2; //--indicating trfgen done 

		     //-------------------------------------------------------------------------------------------------------------
		     //-------------------------------------------------------------------------------------------------------------
                     if(hqmproc_return_flow==1) begin
			//-----------------------------------------------------------------------------
			//-- return flow (.cqbuf_init_in(0), .cqbuf_ctrl_in(1),.comp_flow_in(1), .cq_tok_flow_in(1),)
			//-----------------------------------------------------------------------------
			`uvm_info(get_full_name(),$psprintf("Main_Trf_flowrtn_all_3: Start all trf hqmproc_alltrf_sel=1"),UVM_LOW)	

        		  //-- dirPP traffic
        		  for(int i=hqmproc_dirppnum_min; i<hqmproc_dirppnum_max; i++) begin
        		      fork
                		  automatic int jj = i;  
        			  start_pp_cq_hqmprocseq(.is_ldb(0), .pp_cq_num_in(jj), .is_vf(0), .vf_num(0), .qid(jj), .qtype(QDIR), .renq_qid(jj), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(dir_trf_pp_cq_hqmproc_seq[jj]));
        		      join_none
        		  end 
        		  wait fork;

        		  //-- ldbPP traffic
        		  for(int i=hqmproc_ldbppnum_min; i<hqmproc_ldbppnum_max; i++) begin
        		      fork
                		  automatic int kk = i; 
        	        	  start_pp_cq_hqmprocseq(.is_ldb(1), .pp_cq_num_in(kk), .is_vf(0), .vf_num(0), .qid(kk), .qtype(QUNO), .renq_qid(kk), .renq_qtype(QUNO), .queue_list_size(1), .hcw_delay_in(8), .enq_flow_in(0), .cqbuf_init_in(0), .cqbuf_ctrl_in(1), .comp_flow_in(1), .cq_tok_flow_in(1), .pp_cq_seq(ldb_trf_pp_cq_hqmproc_seq[kk]));
        		      join_none
        		  end 
        		  wait fork; 

			`uvm_info(get_full_name(),$psprintf("Trf_flowrtn_all_4: Done return flows hqmproc_alltrf_sel=1"),UVM_LOW)
		     end //--if(hqmproc_return_flow==1
 
        	    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_4: Done all trf hqmproc_alltrf_sel=1, i_hqm_cfg.hqmproc_trfctrl=2"),UVM_LOW)	  

		     //-------------------------------------------------------------------------------------------------------------
		     //-------------------------------------------------------------------------------------------------------------
                   `ifdef IP_TYP_TE
        	    `uvm_info(get_full_name(),$psprintf("Main_Trf_fl1ow_all_4: start wait_unit_idle_task check, poll hqmproc_unitidle_poll_num=%0d hqmproc_alltrf_sel=1", hqmproc_unitidle_poll_num),UVM_LOW)	  
                     wait_unit_idle_task(hqmproc_unitidle_poll_num, 1, 0); //--expect_idle=1; has_report=0

        	    `uvm_info(get_full_name(),$psprintf("Main_Trf_flow_all_4: start hqmproc_eot_check_task hqmproc_alltrf_sel=1"),UVM_LOW)	  
                     hqmproc_eot_check_task_CHP_histlist();
                     hqmproc_eot_check_task_wb_state();
                     hqmproc_eot_check_task_CHP_INTR_IRQ_Poll();
                     hqmproc_eot_check_task_Misc_Count_Poll();  
                     hqmproc_eot_check_task_count();
        	     i_hqm_cfg.i_hqm_pp_cq_status.report_status_upd();
                     hqmproc_trf_eot_check();

                     if(has_hwerrinj_scherr_check) begin
                        if(i_hqm_cfg.i_hqm_pp_cq_status.total_sch_err_count==0)
                              `uvm_error(get_full_name(),$psprintf("Main_Trf_flow_all_4_has_hwerrinj_scherr_check=1: i_hqm_cfg.i_hqm_pp_cq_status.total_sch_err_count=0, expect is_error occurred"))
                     end 
                   `endif//`ifdef IP_TYP_TE
                end //--level_1_trf	
                join		 			
	  end //if(hqmproc_alltrf_sel==2
    end //--main_flow_traffic    
    
 

   `ifdef IP_TYP_TE
    begin //--main_flow_interruption_services
       `uvm_info(get_full_name(),$psprintf("Main_INTR_flow: Start hqmproc_intr_enable=%0d", hqmproc_intr_enable),UVM_LOW)    
        detect_alarm_intr(hqmproc_intr_enable); 
       `uvm_info(get_full_name(),$psprintf("Main_INTR_flow: Done"),UVM_LOW)         
    end //--main_flow_interruption_services    
   `endif//`ifdef IP_TYP_TE
    join_any
    
    `uvm_info(get_full_name(),$psprintf("Main_flow: ALL Done"),UVM_LOW)	        
    super.body();

  endtask


  //---------------------------------------------
  //--  hqm_cq_addr_reporgram()
  //---------------------------------------------
  task hqm_cq_addr_reporgram();
     uvm_reg_block       ral;
     uvm_reg             my_reg;
     uvm_reg_field       my_field;
     uvm_reg_data_t      ral_data;
     uvm_status_e        status;
     string              pp_cq_prefix;
     string              ral_access_path;

     bit [63:0]                    decode_cq_gpa_tmp; 
     bit [63:0]                    decode_cq_gpa_addr; 
     int                           pasid_tmp;
     int                           pp_idx;

     ral_access_path = i_hqm_cfg.ral_access_path; //"iosf_pri";
     uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: Reprogramming CQ address with the setting of cfg.dir_cq_addr_q.size=%0d cfg.dir_cq_hpa_addr_q.size=%0d cfg.dir_cq_base_addr=0x%0x cfg.dir_cq_space=0x%0x; cfg.ldb_cq_addr_q.size=%0d cfg.ldb_cq_hpa_addr_q.size=%0d ldb_cq_base_addr=0x%0x cfg.ldb_cq_space=0x%0x; ral_access_path=%0s", cfg.dir_cq_addr_q.size(), cfg.dir_cq_hpa_addr_q.size(), cfg.dir_cq_base_addr, cfg.dir_cq_space, cfg.ldb_cq_addr_q.size(), cfg.ldb_cq_hpa_addr_q.size(), cfg.ldb_cq_base_addr, cfg.ldb_cq_space,ral_access_path), UVM_NONE);

     if ($value$plusargs("HQM_RAL_ACCESS_PATH=%s", ral_access_path)) begin
      `uvm_info(get_full_name(),$psprintf("hcw_enqtrf_test_hcw_seq: Reprogramming access_path is overrided by +HQM_RAL_ACCESS_PATH=%s", ral_access_path), UVM_LOW)
     end 

     //--08122022  $cast(ral, sla_ral_env::get_ptr());
     $cast(ral, slu_ral_db::get_regmodel());
     if (ral == null) begin
       uvm_report_fatal("CFG", "hcw_enqtrf_test_hcw_seq: Unable to get RAL handle in hqm_cq_addr_reporgram");
     end 


       //-- LDB
       pp_idx=0;
       if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin 
          decode_cq_gpa_tmp=i_hqm_cfg.allocate_dram("HQM_LDB_CQ_MEM_ALL", ((hqmproc_ldbppnum_max - hqmproc_ldbppnum_min) * cfg.ldb_cq_space), 'h3f, 0, 0, 0, 0, pasid_tmp);
       end 

       foreach(i_hqm_cfg.ldb_pp_cq_cfg[pp]) begin
          if(i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned) begin
              pp_cq_prefix = "LDB";
              if(pp < cfg.ldb_cq_addr_q.size()) begin
                    decode_cq_gpa_addr = cfg.ldb_cq_addr_q[pp];  
              end else begin
                 if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin
                    decode_cq_gpa_addr = decode_cq_gpa_tmp + pp_idx * cfg.ldb_cq_space; 
                    if ($test$plusargs("HQM_CQ_HPA_ADDR")) begin
                        cfg.ldb_cq_hpa_addr_q[pp] = decode_cq_gpa_addr;
                        uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: HPA cfg.ldb_cq_hpa_addr_q[%0d]=0x%0x, cfg.ldb_cq_hpa_addr_q.size=%0d", pp, cfg.ldb_cq_hpa_addr_q[pp], cfg.ldb_cq_hpa_addr_q.size()), UVM_LOW);
                    end                
                 end else begin 
                    decode_cq_gpa_addr = cfg.ldb_cq_base_addr + pp_idx * cfg.ldb_cq_space;
                 end 
              end 
              uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d from cq_gpa=0x%0x to ldb_cq_base_addr=0x%0x + offset=0x%0x, decode_cq_gpa_tmp=0x%0x new ldb_cq_addr=0x%0x, pp_idx=%0d", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa, cfg.ldb_cq_base_addr, pp*cfg.ldb_cq_space, decode_cq_gpa_tmp, decode_cq_gpa_addr, pp_idx), UVM_LOW);

              i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;

              my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              //--08122022  my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, this);
              my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, .parent(this));

              my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              //--08122022  my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, this);
              my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, .parent(this));
              pp_idx++; 
          end 
       end 


       //-- DIR
       pp_idx=0;
       if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin
          decode_cq_gpa_tmp=i_hqm_cfg.allocate_dram("HQM_DIR_CQ_MEM_ALL", ((hqmproc_dirppnum_max - hqmproc_dirppnum_min) * cfg.dir_cq_space), 'h3f, 0, 0, 0, 0, pasid_tmp);
       end 

       foreach(i_hqm_cfg.dir_pp_cq_cfg[pp]) begin
          if(i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned) begin
              pp_cq_prefix = "DIR";
              if(pp < cfg.dir_cq_addr_q.size()) begin
                    decode_cq_gpa_addr = cfg.dir_cq_addr_q[pp];  
              end else begin
                 if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin
                    decode_cq_gpa_addr = decode_cq_gpa_tmp + pp_idx * cfg.dir_cq_space; 
                    if ($test$plusargs("HQM_CQ_HPA_ADDR")) begin
                        cfg.dir_cq_hpa_addr_q[pp] = decode_cq_gpa_addr;
                        uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: HPA cfg.dir_cq_hpa_addr_q[%0d]=0x%0x, cfg.dir_cq_hpa_addr_q.size=%0d", pp, cfg.dir_cq_hpa_addr_q[pp], cfg.dir_cq_hpa_addr_q.size()), UVM_LOW);
                    end       
                 end else begin 
                    decode_cq_gpa_addr = cfg.dir_cq_base_addr + pp_idx * cfg.dir_cq_space;
                 end 
              end 
              uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d from cq_gpa=0x%0x to dir_cq_base_addr=0x%0x + offset=0x%0x, decode_cq_gpa_tmp=0x%0x new dir_cq_addr=0x%0x, pp_idx=%0d", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa, cfg.dir_cq_base_addr, pp*cfg.dir_cq_space, decode_cq_gpa_tmp, decode_cq_gpa_addr, pp_idx), UVM_LOW);

              i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;
              my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              //--08122022 my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, this);
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, .parent(this));

              my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              //--08122022 my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, this);
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, .parent(this));
              pp_idx++; 
          end 
       end 

       uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: Reprogramming CQ address done"), UVM_NONE);
  endtask:hqm_cq_addr_reporgram



//--################
//-- start_pp_cq
//--################
  virtual task start_pp_cq(bit is_ldb, int pp_cq_num_in, bit is_vf, int vf_num, int qid, hcw_qtype qtype, int renq_qid, hcw_qtype renq_qtype,  int queue_list_size, int hcw_delay_in, int enq_flow_in, int comp_flow_in, int cq_tok_flow_in, output hqm_pp_cq_base_seq pp_cq_seq);
    uvm_reg_block       ral;
    uvm_reg             my_reg;
    uvm_reg_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    int                 num_hcw_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;
    int                 wu_min;
    int                 wu_max;
    int                 cq_poll_int;
    int                 illegal_hcw_prob;
    int                 illegal_hcw_burst_len;
    hqm_pp_cq_base_seq::illegal_hcw_gen_mode_t      illegal_hcw_gen_mode;
    hqm_pp_cq_base_seq::illegal_hcw_type_t          illegal_hcw_type;
    string                      illegal_hcw_type_str;
    bit [6:0]           pf_pp_cq_num;
    int                 new_weight_in;
    int                 comp_weight_in;
    int                 has_multiple_qid_in;
 
    int                 hqmproc_trfctrl_sel_mode_in;
    int                 hqmproc_trfflow_ctrl_mode_in;
    int                 hqmproc_rtntokctrl_sel_mode_in;
    int                 hqmproc_rtntokctrl_holdnum_in;
    int                 hqmproc_rtntokctrl_holdnum_waitnum_in;
    int                 hqmproc_rtncmpctrl_sel_mode_in;
    int                 hqmproc_rtncmpctrl_holdnum_in;
    int                 hqmproc_rtncmpctrl_holdnum_waitnum_in;
    int                 hqmproc_rtn_a_cmpctrl_sel_mode_in;
    int                 hqmproc_rtn_a_cmpctrl_holdnum_in;
    int                 hqmproc_rtn_a_cmpctrl_holdnum_waitnum_in;

    int                 hqmproc_qid_sel_mode_in;
    int                 hqmproc_qpri_sel_mode_in;
    int                 hqmproc_qtype_sel_mode_in;
    int                 hqmproc_lockid_sel_mode_in;

    int                 pp_cq_enable;


     //--08122022  $cast(ral, sla_ral_env::get_ptr());
     $cast(ral, slu_ral_db::get_regmodel());

    if (ral == null) begin
      uvm_report_fatal(get_full_name(), "start_pp_cq - Unable to get RAL handle");
    end  

    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end 

    pf_pp_cq_num = i_hqm_cfg.get_pf_pp(is_vf, vf_num, is_ldb, pp_cq_num_in, 1'b1);

    `ifdef IP_TYP_TE
       cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pf_pp_cq_num);
       uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: is_ldb=%0d pf_pp_cq_num=%0d cq_addr_val=0x%0x by get_cq_addr_val", is_ldb, pf_pp_cq_num, cq_addr_val), UVM_LOW);
    `else
       my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pf_pp_cq_num), {cfg.tb_env_hier,".hqm_system_csr"});
       ral_data = my_reg.get_mirrored_value();
       cq_addr_val[63:32] = ral_data[31:0];

       my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pf_pp_cq_num), {cfg.tb_env_hier,".hqm_system_csr"});
       ral_data = my_reg.get_mirrored_value();
       cq_addr_val[31:6] = ral_data[31:6];
    `endif

    cq_addr_val[5:0] = 0;
    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: is_ldb=%0d pf_pp_cq_num=%0d get cq_addr_val=0x%0x from cq_addr_u/l RAL ", is_ldb, pf_pp_cq_num, cq_addr_val), UVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pf_pp_cq_num); 
        uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: is_ldb=%0d pf_pp_cq_num=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pf_pp_cq_num, cq_addr_val), UVM_LOW);
    end  

    //----------------------------------
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);

    illegal_hcw_prob = 0;
    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_PROB",pp_cq_prefix,pp_cq_num_in),"=%d"}, illegal_hcw_prob);

    illegal_hcw_burst_len = 0;
    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_BURST_LEN",pp_cq_prefix,pp_cq_num_in),"=%d"}, illegal_hcw_burst_len);

    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_HCW_TYPE",pp_cq_prefix,pp_cq_num_in),"=%s"}, illegal_hcw_type_str);
    illegal_hcw_type_str = illegal_hcw_type_str.tolower();

    new_weight_in = 1;
    $value$plusargs({$psprintf("%s_PP%0d_NEW_WEIGHT",pp_cq_prefix,pp_cq_num_in),"=%d"}, new_weight_in);

    comp_weight_in = 0;
    $value$plusargs({$psprintf("%s_PP%0d_COMP_WEIGHT",pp_cq_prefix,pp_cq_num_in),"=%d"}, comp_weight_in);

    pp_cq_enable = 0;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_ENA",pp_cq_prefix,pp_cq_num_in),"=%d"}, pp_cq_enable);
    
    has_multiple_qid_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_MULPQIDQTYPE",pp_cq_prefix,pp_cq_num_in),"=%d"}, has_multiple_qid_in);

    wu_min=0;
    $value$plusargs({$psprintf("%s_PP%0d_WU_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, wu_min);
    wu_max=0;
    $value$plusargs({$psprintf("%s_PP%0d_WU_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, wu_max);

    hqmproc_trfctrl_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRFCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfctrl_sel_mode_in);
        
    hqmproc_trfflow_ctrl_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFLOW_CTRLMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfflow_ctrl_mode_in);

    hqmproc_rtntokctrl_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_sel_mode_in);
    
    hqmproc_rtntokctrl_holdnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_holdnum_in);
    
    hqmproc_rtntokctrl_holdnum_waitnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_WAITNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_holdnum_waitnum_in);
    
    hqmproc_rtncmpctrl_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_sel_mode_in);

    hqmproc_rtncmpctrl_holdnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_holdnum_in);

    hqmproc_rtncmpctrl_holdnum_waitnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_WAITNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_holdnum_waitnum_in);


    hqmproc_rtn_a_cmpctrl_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTN_ACMPCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtn_a_cmpctrl_sel_mode_in);

    hqmproc_rtn_a_cmpctrl_holdnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTN_ACMPCTRL_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtn_a_cmpctrl_holdnum_in);

    hqmproc_rtn_a_cmpctrl_holdnum_waitnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTN_ACMPCTRL_WAITNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtn_a_cmpctrl_holdnum_waitnum_in);


    hqmproc_qid_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_QID_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_qid_sel_mode_in);

    hqmproc_qtype_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_QTYPE_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_qtype_sel_mode_in);

    hqmproc_qpri_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_QPRI_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_qpri_sel_mode_in);

    hqmproc_lockid_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_LOCKID_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_lockid_sel_mode_in);

    
    case (illegal_hcw_type_str)
      "illegal_hcw_cmd":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_HCW_CMD;
      "all_0":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_0;
      "all_1":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_1;
      "illegal_pp_num":         illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_NUM;
      "illegal_pp_type":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_TYPE;
      "illegal_qid_num":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_NUM;
      "illegal_qid_type":       illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_TYPE;
      "illegal_dirpp_rels":     illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_DIRPP_RELS;
      "illegal_dev_vf_num":     illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_DEV_VF_NUM;
      "qid_grt_127":            illegal_hcw_type = hqm_pp_cq_base_seq::QID_GRT_127;
      "vas_write_permission":   illegal_hcw_type = hqm_pp_cq_base_seq::VAS_WRITE_PERMISSION;
    endcase

    `uvm_info("START_PP_CQ",$psprintf("Starting PP/CQ processing: pp_cq_enable=%0d %s PP/CQ 0x%0x is_vf=%d vf_num=0x%0x qid=0x%0x qtype=%s queue_list_size=%0d hcw_delay=%0d enq_flow_in=%0d comp_flow_in=%0d cq_tok_flow_in=%0d has_multiple_qid_in=%0d hqmproc_qtype_sel_mode_in=%0d hqmproc_qpri_sel_mode_in=%0d hqmproc_lockid_sel_mode_in=%0d illegal_hcw_type=%0s",pp_cq_enable,is_ldb?"LDB":"DIR",pp_cq_num_in,is_vf,vf_num,qid,qtype.name(),queue_list_size,hcw_delay_in, enq_flow_in, comp_flow_in, cq_tok_flow_in, has_multiple_qid_in, has_multiple_qid_in, hqmproc_qtype_sel_mode_in, hqmproc_qpri_sel_mode_in, hqmproc_lockid_sel_mode_in, illegal_hcw_type),UVM_LOW)

    cq_poll_int = 1;
    $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_num_in),"=%d"}, cq_poll_int);

    if(pp_cq_enable) begin
	`uvm_create(pp_cq_seq)
        pp_cq_seq.inst_suffix = cfg.inst_suffix;
        pp_cq_seq.tb_env_hier = cfg.tb_env_hier;
	pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in)); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
	start_item(pp_cq_seq);
	if (!pp_cq_seq.randomize() with {
                	 pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                	 pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                	 cq_depth                   == 1024;

                	 queue_list.size()          == queue_list_size;

                	 hcw_enqueue_batch_min      == hqmproc_batch_min;  //1 : Minimum number of HCWs to send as a batch (1-4)
                	 hcw_enqueue_batch_max      == hqmproc_batch_max;  //1 : Maximum number of HCWs to send as a batch (1-4)

                         hcw_enqueue_wu_min         == wu_min;  // Minimum WU value for HCWs
                         hcw_enqueue_wu_max         == wu_max;  // Maximum WU value for HCWs

                	 queue_list_delay_min       == hcw_delay_in;
                	 queue_list_delay_max       == hcw_delay_in;

                	 cq_addr                    == cq_addr_val;

                	 cq_poll_interval           == cq_poll_int;
                	 new_weight                 == new_weight_in;
                	 comp_weight                == comp_weight_in;
                       } ) begin
	  `uvm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
	end 

	if ($value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num)) begin
	  if (vf_num >= 0) begin
            is_vf   = 1;
	  end else begin
            is_vf   = 0;
	  end 
	end 

	pp_cq_seq.is_vf   = is_vf;
	pp_cq_seq.vf_num  = vf_num;

	$value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, qid);

	qtype_str = qtype.name();
	$value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str);
	qtype_str = qtype_str.tolower();

	lock_id = 16'h4001;
	$value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, lock_id);

	 dsi = 16'h0100;
       // $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, dsi);

	case (qtype_str)
	  "qdir": qtype = QDIR;
	  "quno": qtype = QUNO;
	  "qatm": qtype = QATM;
	  "qord": qtype = QORD;
	endcase

	for (int i = 0 ; i < queue_list_size ; i++) begin
	  num_hcw_gen = 1;
	  $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);

	  pp_cq_seq.queue_list[i].num_hcw                   = (enq_flow_in==1)? num_hcw_gen : 0;

	  if (qtype == QORD) begin
            pp_cq_seq.queue_list[i].qid                       = (i == 0) ? qid : renq_qid;
            pp_cq_seq.queue_list[i].qtype                     = (i == 0) ? qtype : renq_qtype;
            pp_cq_seq.queue_list[i].comp_flow                 = (i == 0) ? 0 : 1;
            pp_cq_seq.queue_list[i].cq_token_return_flow      = cq_tok_flow_in;
	  end else begin
            pp_cq_seq.queue_list[i].qid                       = qid + i;
            pp_cq_seq.queue_list[i].qtype                     = qtype;
            pp_cq_seq.queue_list[i].comp_flow                 = comp_flow_in;
            pp_cq_seq.queue_list[i].cq_token_return_flow      = cq_tok_flow_in;
	  end 

	  pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
	  pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_in * queue_list_size;
	  pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_in * queue_list_size;
	  pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
	  pp_cq_seq.queue_list[i].lock_id                   = lock_id;
	  pp_cq_seq.queue_list[i].illegal_hcw_burst_len     = (i == 0) ? illegal_hcw_burst_len : 0;
	  pp_cq_seq.queue_list[i].illegal_hcw_prob          = (i == 0) ? illegal_hcw_prob : 0;
	  if (pp_cq_seq.queue_list[i].illegal_hcw_prob > 0) begin
            pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::RAND_ILLEGAL;
	  end else if (pp_cq_seq.queue_list[i].illegal_hcw_burst_len > 0) begin
            pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::BURST_ILLEGAL;
	  end else begin
            pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::NO_ILLEGAL;
	  end 

	  pp_cq_seq.queue_list[i].illegal_hcw_type_q.push_back(illegal_hcw_type);
	end 

	finish_item(pp_cq_seq);
    	
    end //if(pp_cq_enable
    	
  endtask:start_pp_cq



//--#######################################################################################################
//-- start_pp_cq_hqmprocseq
//--#######################################################################################################
  virtual task start_pp_cq_hqmprocseq(bit is_ldb, int pp_cq_num_in, bit is_vf, int vf_num, int qid, hcw_qtype qtype, int renq_qid, hcw_qtype renq_qtype,  int queue_list_size, int hcw_delay_in, int enq_flow_in, int cqbuf_ctrl_in, int cqbuf_init_in, int comp_flow_in, int cq_tok_flow_in, output hqm_pp_cq_hqmproc_seq pp_cq_seq);
    uvm_reg_block       ral;
    uvm_reg             my_reg;
    uvm_reg_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    logic [63:0]        cq_physical_addr_val;
    logic [63:0]        ims_poll_addr_val;
    int                 num_hcw_gen;
    int                 illegal_num_hcw_gen;
    string              pp_cq_prefix;
    string              qtype_str;
    string              renq_qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;

    int                 is_rob_enabled;
    int                 cacheline_max_num_min;
    int                 cacheline_max_num_max;
    int                 cacheline_max_num;
    int                 cacheline_max_pad_min;
    int                 cacheline_max_pad_max;
    int                 cacheline_max_shuffle_min;
    int                 cacheline_max_shuffle_max;

    int                 cl_pad;

    int                 wu_min;
    int                 wu_max;
    int                 cq_poll_int;
    int                 illegal_hcw_prob;
    int                 illegal_hcw_burst_len;
    hqm_pp_cq_base_seq::illegal_hcw_gen_mode_t      illegal_hcw_gen_mode;
    hqm_pp_cq_base_seq::illegal_hcw_type_t          illegal_hcw_type;
    string                      illegal_hcw_type_str;
    bit [6:0]           pf_pp_cq_num;
    int                 new_weight_in;
    int                 comp_weight_in;

    int                 hqmproc_trfgen_watchdog_ena_in;
    int                 hqmproc_trfgen_watchdog_num_in;

    int                 hqmproc_trfctrl_sel_mode_in;
    int                 hqmproc_trfflow_ctrl_mode_in;
    int                 hqmproc_rtntokctrl_sel_mode_in;
    int                 hqmproc_rtntokctrl_holdnum_in;
    int                 hqmproc_rtntokctrl_holdnum_waitnum_in;
    int                 hqmproc_rtntokctrl_checknum_in;
    int                 hqmproc_rtntokctrl_keepnum_min_in;
    int                 hqmproc_rtntokctrl_keepnum_max_in;
    int                 hqmproc_rtntokctrl_rtnnum_min_in;
    int                 hqmproc_rtntokctrl_rtnnum_max_in;
    int                 hqmproc_rtntokctrl_threshold_in;
    int                 hqmproc_rtncmpctrl_sel_mode_in;
    int                 hqmproc_rtncmpctrl_rtnnum_in;
    int                 hqmproc_rtncmpctrl_holdnum_in;
    int                 hqmproc_rtncmpctrl_holdnum_waitnum_in;
    int                 hqmproc_rtncmpctrl_checknum_in;

    int                 hqmproc_rtn_a_cmpctrl_sel_mode_in;
    int                 hqmproc_rtn_a_cmpctrl_holdnum_in;
    int                 hqmproc_rtn_a_cmpctrl_holdnum_waitnum_in;
    
    int                 hqmproc_cq_intr_thres_num_in;
    int                 has_cq_rearm_ctrl_in;
    int                 hqmproc_cq_rearm_ctrl_in;

    int                 has_cq_cwdt_ctrl_in;
    int                 hqmproc_cq_cwdt_ctrl_in;

    int                 hqmproc_watchdog_ctrl_mode_in;
    int                 has_trfidle_enable; 
    int                 has_trfidle_num; 
    int                 hqmproc_trfidle_enable_in;
    int                 hqmproc_trfidle_num_in;

    int                 hqmproc_dta_ctrl_in;
    int                 hqmproc_dta_srcpp_in;
    int                 hqmproc_dta_wpp_idlenum_in;

    int                 has_enqctrl_sel_mode_in;
    int                 hqmproc_enqctrl_sel_mode_in;
    int                 hqmproc_enqctrl_newnum_in;
    int                 hqmproc_enqctrl_fragnum_in;
    int                 hqmproc_enqctrl_enqnum_in;
    int                 hqmproc_enqctrl_enqnum_1_in;
    int                 hqmproc_enqctrl_hold_waitnum_in;

    int                 has_cq_dep_chk_adj_in;
    int                 hqmproc_cq_dep_chk_adj_in;

    int                 hqmproc_qid_sel_mode_in;
    int                 hqmproc_qid_gen_prob_in;
    int                 hqmproc_qpri_sel_mode_in;
    int                 hqmproc_qtype_sel_mode_in;
    int                 hqmproc_lockid_sel_mode_in;
 
    int                 hqmproc_acomp_ctrl_in;

    int                 hqmproc_frag_ctrl_in;
    int                 hqmproc_frag_replay_ctrl_in;
    int                 hqmproc_frag_num_min_in;
    int                 hqmproc_frag_num_max_in;
    int                 hqmproc_frag_t_ctrl_in;

    int                 hqmproc_frag_new_ctrl_in;
    int                 hqmproc_frag_new_prob_in;

    int                 hqmproc_renq_qid_sel_mode_in;
    int                 hqmproc_renq_qpri_sel_mode_in;
    int                 hqmproc_renq_qtype_sel_mode_in;
    int                 hqmproc_renq_lockid_sel_mode_in;

    int                 hqmproc_stream_ctrl_in;
    int                 hqmproc_strenq_num_min_in;
    int                 hqmproc_strenq_num_max_in;
    int                 hqmproc_rels_ctrl_in;

    int                 hqmproc_nodec_fragnum_in;
    int                 hqmproc_rel_qtype_sel_in;
    int                 hqmproc_rel_qtype_rndsel;
    string              hqmproc_rel_qtype_str_in;
    hcw_qtype           hqmproc_rel_qtype_in;
    int                 hqmproc_rel_qtype_dir_in;
    int                 hqmproc_rel_qid_in;

    bit [2:0]           renq_qpri;
    bit [15:0]          renq_lockid;

    int                 comp_return_delay;
    int                 comp_return_delay_mode;
    int                 a_comp_return_delay;
    int                 a_comp_return_delay_mode;
    int                 tok_return_delay;
    int                 tok_return_delay_mode;

    int                 pp_cq_enable;

    //-- these controls provide a global setting for all CQs, this is to simplify number of options in opt file or cmd line
    int                 has_pp_cq_enable;
    int                 has_num_hcw_gen;
    int                 has_new_weight_in;
    int                 has_comp_weight_in;
    int                 has_hcw_delay_in;

    int                 has_trfctrl_sel_mode_in;
    int                 has_trfflow_ctrl_mode_in;
    int                 has_rtntokctrl_sel_mode_in;
    int                 has_rtntokctrl_cqthres_ctrl_in;
    int                 has_rtntokctrl_holdnum_in;
    int                 has_rtntokctrl_rtnnum_min_in;
    int                 has_rtntokctrl_rtnnum_max_in;

    int                 has_rtncmpctrl_sel_mode_in;
    int                 has_rtncmpctrl_rtnnum_in;
    int                 has_rtncmpctrl_holdnum_in;
    
    int                 has_qid_sel_mode_in;
    int                 has_qid_gen_prob_in;
    int                 has_qpri_sel_mode_in;
    int                 has_qtype_sel_mode_in;
    int                 has_lockid_sel_mode_in;
 
    int                 has_acomp_ctrl_in;

    int                 has_frag_ctrl_in;
    int                 has_frag_replay_ctrl_in;
    int                 has_frag_t_ctrl_in;
    int                 has_frag_num_min_in;
    int                 has_frag_num_max_in;

    int                 has_frag_new_ctrl_in;
    int                 has_frag_new_prob_in;

    int                 has_rels_ctrl_in;
    int                 has_stream_ctrl_in;
    int                 has_strenq_num_min_in;
    int                 has_strenq_num_max_in;

    int                 has_renq_qid_sel_mode_in;
    int                 has_renq_qpri_sel_mode_in;
    int                 has_renq_qtype_sel_mode_in;
    int                 has_renq_lockid_sel_mode_in;

    int                 has_comp_return_delay_min, has_comp_return_delay_max, has_comp_return_delay_num;
    int                 has_comp_return_delay_mode_in;
    int                 has_comp_return_delay_qsize;
    int                 has_a_comp_return_delay_min, has_a_comp_return_delay_max, has_a_comp_return_delay_num;
    int                 has_a_comp_return_delay_mode_in;
    int                 has_a_comp_return_delay_qsize;
    int                 has_tok_return_delay_min, has_tok_return_delay_max, has_tok_return_delay_num;
    int                 has_tok_return_delay_mode_in;
    int                 has_tok_return_delay_qsize;

    int                 waitnum_min, waitnum_max, waitnum;
    int                 newhcw_delay_min_in, newhcw_delay_max_in;  
    int                 hcw_delay_min_in, hcw_delay_max_in;
    int                 hcw_delay_ctrl_mode_in;

    int                 has_trfgen_watchdog_ena_in;
    int                 has_trfgen_watchdog_num_in;

    int                 hqmproc_hcw_batch_min, hqmproc_hcw_batch_max;   
    int                 hqmproc_hcw_pad_prob_min, hqmproc_hcw_pad_prob_max;   
    int                 hqmproc_hcw_expad_prob_min, hqmproc_hcw_expad_prob_max;   
    int                 hqmproc_lsp_qid_ck_congest_in;
    int                 hqmproc_lsp_qid_congest_in;
  
    int                 hqmproc_meas_enable_in;
    int                 hqmproc_meas_rand_in;
    int                 hqmproc_idsi_ctrl_in;
 
    int                 hqmproc_ingerrinj_ingress_drop_in;

    int                 hqmproc_ingerrinj_excess_tok_rand_in;
    int                 hqmproc_ingerrinj_excess_tok_ctrl_in;
    int                 hqmproc_ingerrinj_excess_tok_rate_in;
    int                 hqmproc_ingerrinj_excess_tok_num_in;

    int                 hqmproc_ingerrinj_excess_cmp_rand_in;
    int                 hqmproc_ingerrinj_excess_cmp_ctrl_in;
    int                 hqmproc_ingerrinj_excess_cmp_rate_in;
    int                 hqmproc_ingerrinj_excess_cmp_num_in;

    int                 hqmproc_ingerrinj_excess_a_cmp_rand_in;
    int                 hqmproc_ingerrinj_excess_a_cmp_ctrl_in;
    int                 hqmproc_ingerrinj_excess_a_cmp_rate_in;
    int                 hqmproc_ingerrinj_excess_a_cmp_num_in;

    int                 hqmproc_ingerrinj_cmpid_rand_in;
    int                 hqmproc_ingerrinj_cmpid_ctrl_in;
    int                 hqmproc_ingerrinj_cmpid_rate_in;

    //-- completion sending from dirPP (drop whole HCW)
    int                 hqmproc_ingerrinj_cmpdirpp_rand_in;
    int                 hqmproc_ingerrinj_cmpdirpp_ctrl_in;
    int                 hqmproc_ingerrinj_cmpdirpp_rate_in;

    //-- incorrect QID (drop QE, pass token/compl HCW)
    int                 hqmproc_ingerrinj_qidill_rand_in;
    int                 hqmproc_ingerrinj_qidill_ctrl_in;
    int                 hqmproc_ingerrinj_qidill_rate_in;
    int                 hqmproc_ingerrinj_qidill_min_in; 
    int                 hqmproc_ingerrinj_qidill_max_in; 

    //-- illegal PP
    int                 hqmproc_ingerrinj_ppill_rand_in;
    int                 hqmproc_ingerrinj_ppill_ctrl_in;
    int                 hqmproc_ingerrinj_ppill_rate_in;
    int                 hqmproc_ingerrinj_ppill_min_in; 
    int                 hqmproc_ingerrinj_ppill_max_in; 

    int                 hqmproc_ingerrinj_ooc_rand_in;
    int                 hqmproc_ingerrinj_ooc_ctrl_in;
    int                 hqmproc_ingerrinj_ooc_rate_in;

    int                 has_mon_watchdog_timeout; 
    int                 seq_mon_watchdog_timeout_in; 

    int                 has_cq_intr_resp_waitnum_min_in;
    int                 has_cq_intr_resp_waitnum_max_in;
    int                 hqmproc_cq_intr_resp_waitnum_min_in;
    int                 hqmproc_cq_intr_resp_waitnum_max_in;
  
    int                 has_cqirq_mask_waitnum_min_in;
    int                 has_cqirq_mask_waitnum_max_in;
    int                 hqmproc_cqirq_mask_waitnum_min_in;
    int                 hqmproc_cqirq_mask_waitnum_max_in;
 
    int                 hqmproc_cqirq_mask_ena_in;

    int                 has_hcw_qpri_weight0, has_hcw_qpri_weight1, has_hcw_qpri_weight2, has_hcw_qpri_weight3, has_hcw_qpri_weight4, has_hcw_qpri_weight5, has_hcw_qpri_weight6, has_hcw_qpri_weight7;  
    int                 hcw_qpri_weight0, hcw_qpri_weight1, hcw_qpri_weight2, hcw_qpri_weight3, hcw_qpri_weight4, hcw_qpri_weight5, hcw_qpri_weight6, hcw_qpri_weight7;  


     //--08122022  $cast(ral, sla_ral_env::get_ptr());
     $cast(ral, slu_ral_db::get_regmodel());

    if (ral == null) begin
      uvm_report_fatal(get_full_name(), "start_pp_cq_hqmprocseq - Unable to get RAL handle");
    end  

    cq_addr_val = '0;
    cq_physical_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end 

    pf_pp_cq_num = i_hqm_cfg.get_pf_pp(is_vf, vf_num, is_ldb, pp_cq_num_in, 1'b1);

    `ifdef IP_TYP_TE
       cq_addr_val      = get_cq_addr_val(e_port_type'(is_ldb), pf_pp_cq_num);
       uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: is_ldb=%0d pf_pp_cq_num=%0d cq_addr_val=0x%0x by get_cq_addr_val", is_ldb, pf_pp_cq_num, cq_addr_val), UVM_LOW);
    `else
       my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pf_pp_cq_num), {cfg.tb_env_hier,".hqm_system_csr"});
       ral_data = my_reg.get_mirrored_value();
       cq_addr_val[63:32] = ral_data[31:0];

       my_reg   = i_hqm_cfg.hqm_find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pf_pp_cq_num), {cfg.tb_env_hier,".hqm_system_csr"});
       ral_data = my_reg.get_mirrored_value();
       cq_addr_val[31:6] = ral_data[31:6];
    `endif
    cq_addr_val[5:0] = 0;

     
    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- cq_addr_val is virtual address
    //-- cq_physical_addr_val=get_cq_hpa(is_ldb, pf_pp_cq_num);  
    //----------------------------------
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: is_ldb=%0d pf_pp_cq_num=0x%0x get cq_addr_val=0x%0x from RAL cq_addr_u/cq_addr_l ", is_ldb, pf_pp_cq_num, cq_addr_val ), UVM_LOW);
    if(i_hqm_cfg.ats_enabled==1) begin
       cq_physical_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pf_pp_cq_num);
       cq_addr_val = cq_physical_addr_val;  
       uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: is_ldb=%0d pf_pp_cq_num=0x%0x get cq_addr_val=0x%0x from i_hqm_cfg.get_cq_hpa when i_hqm_cfg.ats_enabled=1", is_ldb, pf_pp_cq_num, cq_addr_val ), UVM_LOW);
    end 



    ims_poll_addr_val = i_hqm_cfg.get_ims_poll_addr(pp_cq_num_in,is_ldb);

    hqmproc_cqirq_mask_ena_in = 0;
    if(has_cqirq_mask_enable) begin
       if(is_ldb) begin
          if(pp_cq_num_in >= hqmproc_cqirqmask_ldbppnum_min && pp_cq_num_in < hqmproc_cqirqmask_ldbppnum_max) hqmproc_cqirq_mask_ena_in = 1;
       end else begin
          if(pp_cq_num_in >= hqmproc_cqirqmask_dirppnum_min && pp_cq_num_in < hqmproc_cqirqmask_dirppnum_max) hqmproc_cqirq_mask_ena_in = 1;
       end 
    end 
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: is_ldb=%0d pf_pp_cq_num=0x%0x cq_addr_val=0x%0x ims_poll_addr_val=0x%0x hqmproc_cqirq_mask_ena_in=%0d", is_ldb, pf_pp_cq_num, cq_addr_val, ims_poll_addr_val, hqmproc_cqirq_mask_ena_in ), UVM_LOW);

    has_pp_cq_enable=0;
    $value$plusargs("has_pp_cq_enable=%d",has_pp_cq_enable);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_pp_cq_enable=%0d ", has_pp_cq_enable ), UVM_LOW);


    has_mon_watchdog_timeout=4000;
    $value$plusargs("has_mon_watchdog_timeout=%d",has_mon_watchdog_timeout);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_mon_watchdog_timeout=%0d ",has_mon_watchdog_timeout ), UVM_LOW);
 
    has_trfidle_enable=0;
    $value$plusargs("has_trfidle_enable=%d",has_trfidle_enable);

    has_trfidle_num=0;
    $value$plusargs("has_trfidle_num=%d",has_trfidle_num);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_trfidle_enable=%0d has_trfidle_num=%0d", has_trfidle_enable, has_trfidle_num), UVM_LOW);

    has_hcw_qpri_weight0=1;
    has_hcw_qpri_weight1=1;
    has_hcw_qpri_weight2=1;
    has_hcw_qpri_weight3=1;
    has_hcw_qpri_weight4=1;
    has_hcw_qpri_weight5=1;
    has_hcw_qpri_weight6=1;
    has_hcw_qpri_weight7=1;
    $value$plusargs("has_hcw_qpri_weight0=%d", has_hcw_qpri_weight0);
    $value$plusargs("has_hcw_qpri_weight1=%d", has_hcw_qpri_weight1);
    $value$plusargs("has_hcw_qpri_weight2=%d", has_hcw_qpri_weight2);
    $value$plusargs("has_hcw_qpri_weight3=%d", has_hcw_qpri_weight3);
    $value$plusargs("has_hcw_qpri_weight4=%d", has_hcw_qpri_weight4);
    $value$plusargs("has_hcw_qpri_weight5=%d", has_hcw_qpri_weight5);
    $value$plusargs("has_hcw_qpri_weight6=%d", has_hcw_qpri_weight6);
    $value$plusargs("has_hcw_qpri_weight7=%d", has_hcw_qpri_weight7);

    waitnum_min=0;
    $value$plusargs("pp_wait2st_num_min=%d",waitnum_min);
    uvm_report_info(get_type_name(),$psprintf("start_pp_cq_hqmprocseq setting: waitnum_min=%0d ", waitnum_min ), UVM_LOW);

    waitnum_max=500;
    $value$plusargs("pp_wait2st_num_max=%d",waitnum_max);
    uvm_report_info(get_type_name(),$psprintf("start_pp_cq_hqmprocseq setting: waitnum_max=%0d ", waitnum_max ), UVM_LOW);

    newhcw_delay_min_in = waitnum_min;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_NEWDELAY_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, newhcw_delay_min_in);

    newhcw_delay_max_in = waitnum_max;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_NEWDELAY_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, newhcw_delay_max_in);

    hcw_delay_ctrl_mode_in = 0;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_ctrl_mode_in);

    hcw_delay_min_in = hcw_delay_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_DELAY_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_min_in);

    hcw_delay_max_in = hcw_delay_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_DELAY_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_max_in);

    //--batch control
    hqmproc_hcw_batch_min = hqmproc_batch_min; 
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_hcw_batch_min);

    hqmproc_hcw_batch_max = hqmproc_batch_max; 
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_hcw_batch_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_hcw_batch_min=%0d hqmproc_hcw_batch_max=%0d",hqmproc_hcw_batch_min, hqmproc_hcw_batch_max), UVM_LOW);

    //--HQMV30 ROB: max cacheline num/pad/shuffle control
    cacheline_max_num_min = is_ldb ? cfg.ldb_cacheline_max_num_min : cfg.dir_cacheline_max_num_min;
    cacheline_max_num_max = is_ldb ? cfg.ldb_cacheline_max_num_max : cfg.dir_cacheline_max_num_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLNUM_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, cacheline_max_num_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLNUM_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, cacheline_max_num_max);
    cacheline_max_num = $urandom_range(cacheline_max_num_min,cacheline_max_num_max); 
    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: cacheline_max_num_min=%0d cacheline_max_num_max=%0d => cacheline_max_num=%0d", cacheline_max_num_min, cacheline_max_num_max, cacheline_max_num), UVM_LOW);

    cacheline_max_pad_min = is_ldb ? cfg.ldb_cacheline_max_pad_min : cfg.dir_cacheline_max_pad_min;
    cacheline_max_pad_max = is_ldb ? cfg.ldb_cacheline_max_pad_max : cfg.dir_cacheline_max_pad_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, cacheline_max_pad_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, cacheline_max_pad_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: cacheline_max_pad_min=%0d cacheline_max_pad_max=%0d", cacheline_max_pad_min, cacheline_max_pad_max), UVM_LOW);

    cacheline_max_shuffle_min = is_ldb ? cfg.ldb_cacheline_max_shuffle_min : cfg.dir_cacheline_max_shuffle_min;
    cacheline_max_shuffle_max = is_ldb ? cfg.ldb_cacheline_max_shuffle_max : cfg.dir_cacheline_max_shuffle_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, cacheline_max_shuffle_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, cacheline_max_shuffle_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", cacheline_max_shuffle_min, cacheline_max_shuffle_max), UVM_LOW);

    cl_pad = is_ldb ? cfg.ldb_cl_pad : cfg.dir_cl_pad;
    $value$plusargs({$psprintf("%s_PP%0d_CL_PAD",pp_cq_prefix,pp_cq_num_in),"=%d"}, cl_pad);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cl_pad=%0d ", cl_pad), UVM_LOW);

    //-- call i_hqm_cfg.get_cl_rob to check if HQMV30 RTL has been programmed to set ROB=1 
    is_rob_enabled = i_hqm_cfg.get_cl_rob(is_ldb, pp_cq_num_in);
    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: is_rob_enabled=%0d ", is_rob_enabled), UVM_LOW);

    //-- if ROB is not set to 1 in this PP, reset cacheline_max_num=1, cl_pad=0
    //-- Be carefull when use +HQM_PP_FORCE_CL_SHUFFLED for ROB_V=0 case, the shuffle will change the order of Enq HCWs, for intrruption case with token return followed by rearm, it will cause simulation hung case
    if(is_rob_enabled==0) begin /// && !$test$plusargs("HQM_PP_FORCE_CL_SHUFFLED")) begin 
        cacheline_max_num = 1;
        cacheline_max_pad_min = 0;
        cacheline_max_pad_max = 0;
        cacheline_max_shuffle_min = 0;
        cacheline_max_shuffle_max = 0;
        cl_pad = 0;
        uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_hcw_seq: is_rob_enabled=%0d reset cacheline_max_num=%0d cl_pad=%0d cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", is_rob_enabled, cacheline_max_num, cl_pad, cacheline_max_shuffle_min, cacheline_max_shuffle_max), UVM_LOW);
    end 


    //--pad_prob control
    hqmproc_hcw_pad_prob_min = hqmproc_pad_prob_min; 
    $value$plusargs({$psprintf("%s_PP%0d_PAD_PROB_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_hcw_pad_prob_min);

    hqmproc_hcw_pad_prob_max = hqmproc_pad_prob_max; 
    $value$plusargs({$psprintf("%s_PP%0d_PAD_PROB_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_hcw_pad_prob_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_hcw_pad_prob_min=%0d hqmproc_hcw_pad_prob_max=%0d",hqmproc_hcw_pad_prob_min, hqmproc_hcw_pad_prob_max), UVM_LOW);

    //--expad_prob control
    hqmproc_hcw_expad_prob_min = hqmproc_expad_prob_min; 
    $value$plusargs({$psprintf("%s_PP%0d_EXPAD_PROB_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_hcw_expad_prob_min);

    hqmproc_hcw_expad_prob_max = hqmproc_expad_prob_max; 
    $value$plusargs({$psprintf("%s_PP%0d_EXPAD_PROB_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_hcw_expad_prob_max);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: hqmproc_hcw_expad_prob_min=%0d hqmproc_hcw_expad_prob_max=%0d",hqmproc_hcw_expad_prob_min, hqmproc_hcw_expad_prob_max), UVM_LOW);


    //--control trfgen_watchdog
    has_trfgen_watchdog_ena_in=0;
    $value$plusargs("has_trfgen_watchdog_ena_in=%d", has_trfgen_watchdog_ena_in);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_trfgen_watchdog_ena_in=%0d ", has_trfgen_watchdog_ena_in), UVM_LOW);

    hqmproc_trfgen_watchdog_ena_in=has_trfgen_watchdog_ena_in; //--this is hqm_pp_cq_hqmproc_seq trfgen watchdog
    $value$plusargs({$psprintf("%s_PP%0d_TRFGEN_WATCHDOG_ENA",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfgen_watchdog_ena_in);

    has_trfgen_watchdog_num_in=80000;
    $value$plusargs("has_trfgen_watchdog_num_in=%d", has_trfgen_watchdog_num_in);
    uvm_report_info(get_type_name(),$psprintf("hcw_enqtrf_test_hcw_seq setting: has_trfgen_watchdog_num_in=%0d ", has_trfgen_watchdog_num_in), UVM_LOW);

    hqmproc_trfgen_watchdog_num_in=has_trfgen_watchdog_num_in; //--this is hqm_pp_cq_hqmproc_seq trfgen watchdog
    $value$plusargs({$psprintf("%s_PP%0d_TRFGEN_WATCHDOG_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfgen_watchdog_num_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_trfgen_watchdog_ena_in=%0d hqmproc_trfgen_watchdog_num_in=%0d ", hqmproc_trfgen_watchdog_ena_in, hqmproc_trfgen_watchdog_num_in ), UVM_LOW);


    has_num_hcw_gen=1;
    $value$plusargs("has_num_hcw_gen=%d",has_num_hcw_gen);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_num_hcw_gen=%0d ", has_num_hcw_gen ), UVM_LOW);

    has_new_weight_in=1;
    $value$plusargs("has_new_weight=%d",has_new_weight_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_new_weight_in=%0d ", has_new_weight_in ), UVM_LOW);

    has_comp_weight_in=1;
    $value$plusargs("has_comp_weight=%d",has_comp_weight_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_comp_weight_in=%0d ", has_comp_weight_in ), UVM_LOW);

    has_hcw_delay_in=1; //--not used
    $value$plusargs("has_hcw_delay=%d",has_hcw_delay_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_hcw_delay_in=%0d ", has_hcw_delay_in ), UVM_LOW);


    has_trfctrl_sel_mode_in=0;
    $value$plusargs("has_trfctrl_sel_mode=%d",has_trfctrl_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_trfctrl_sel_mode_in=%0d ", has_trfctrl_sel_mode_in ), UVM_LOW);

    has_trfflow_ctrl_mode_in=0;
    $value$plusargs("has_trfflow_ctrl_mode=%d",has_trfflow_ctrl_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_trfflow_ctrl_mode_in=%0d ", has_trfflow_ctrl_mode_in ), UVM_LOW);

    has_rtntokctrl_sel_mode_in=0;
    $value$plusargs("has_rtntokctrl_sel_mode=%d",has_rtntokctrl_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rtntokctrl_sel_mode_in=%0d ", has_rtntokctrl_sel_mode_in ), UVM_LOW);

    has_rtntokctrl_cqthres_ctrl_in=0;
    $value$plusargs("has_rtntokctrl_cqthres_ctrl=%d",has_rtntokctrl_cqthres_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rtntokctrl_cqthres_ctrl_in=%0d (1:has_rtntokctrl_holdnum_in is cfg.cq_thres+1)  ", has_rtntokctrl_cqthres_ctrl_in ), UVM_LOW);

    if(has_rtntokctrl_cqthres_ctrl_in) begin
       if(is_ldb)
          has_rtntokctrl_holdnum_in = i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_num_in].cq_depth_intr_thresh + 1;
       else
          has_rtntokctrl_holdnum_in = i_hqm_cfg.dir_pp_cq_cfg[pp_cq_num_in].cq_depth_intr_thresh + 1;
    end else begin
       has_rtntokctrl_holdnum_in=0;
    end 
    $value$plusargs("has_rtntokctrl_holdnum=%d",has_rtntokctrl_holdnum_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rtntokctrl_holdnum_in=%0d ", has_rtntokctrl_holdnum_in ), UVM_LOW);

    has_rtntokctrl_rtnnum_min_in=0;
    $value$plusargs("has_rtntokctrl_rtnnum_min=%d",has_rtntokctrl_rtnnum_min_in);
    has_rtntokctrl_rtnnum_max_in=0;
    $value$plusargs("has_rtntokctrl_rtnnum_max=%d",has_rtntokctrl_rtnnum_max_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rtntokctrl_rtnnum_min_in=%0d has_rtntokctrl_rtnnum_max_in=%0d", has_rtntokctrl_rtnnum_min_in, has_rtntokctrl_rtnnum_max_in ), UVM_LOW);


    has_rtncmpctrl_sel_mode_in=0;
    $value$plusargs("has_rtncmpctrl_sel_mode=%d",has_rtncmpctrl_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rtncmpctrl_sel_mode_in=%0d ", has_rtncmpctrl_sel_mode_in ), UVM_LOW);

    has_rtncmpctrl_rtnnum_in=0;
    $value$plusargs("has_rtncmpctrl_rtnnum=%d",has_rtncmpctrl_rtnnum_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rtncmpctrl_rtnnum_in=%0d ", has_rtncmpctrl_rtnnum_in ), UVM_LOW);

    has_rtncmpctrl_holdnum_in=0;
    $value$plusargs("has_rtncmpctrl_holdnum=%d",has_rtncmpctrl_holdnum_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rtncmpctrl_holdnum_in=%0d ", has_rtncmpctrl_holdnum_in ), UVM_LOW);


    has_qid_sel_mode_in=0;
    $value$plusargs("has_qid_sel_mode=%d",has_qid_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_qid_sel_mode_in=%0d ", has_qid_sel_mode_in ), UVM_LOW);

    has_qid_gen_prob_in=0;
    $value$plusargs("has_qid_gen_prob=%d",has_qid_gen_prob_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_qid_gen_prob_in=%0d ", has_qid_gen_prob_in ), UVM_LOW);

    has_qpri_sel_mode_in=0;
    $value$plusargs("has_qpri_sel_mode=%d",has_qpri_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_qpri_sel_mode_in=%0d ", has_qpri_sel_mode_in ), UVM_LOW);

    has_qtype_sel_mode_in=0;
    $value$plusargs("has_qtype_sel_mode=%d",has_qtype_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_qtype_sel_mode_in=%0d ", has_qtype_sel_mode_in ), UVM_LOW);

    has_lockid_sel_mode_in=0;
    $value$plusargs("has_lockid_sel_mode=%d",has_lockid_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_lockid_sel_mode_in=%0d ", has_lockid_sel_mode_in ), UVM_LOW);

    has_acomp_ctrl_in=0;
    $value$plusargs("has_acomp_ctrl=%d",has_acomp_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_acomp_ctrl=%0d ", has_acomp_ctrl_in ), UVM_LOW);

    has_frag_ctrl_in=0;
    $value$plusargs("has_frag_ctrl=%d",has_frag_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_frag_ctrl=%0d ", has_frag_ctrl_in ), UVM_LOW);

    has_frag_replay_ctrl_in=0;
    $value$plusargs("has_frag_replay_ctrl=%d",has_frag_replay_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_frag_replay_ctrl=%0d ", has_frag_replay_ctrl_in ), UVM_LOW);

    has_frag_t_ctrl_in=1;
    $value$plusargs("has_frag_t_ctrl=%d",has_frag_t_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_frag_t_ctrl=%0d ", has_frag_t_ctrl_in ), UVM_LOW);

    has_frag_num_min_in=0;
    $value$plusargs("has_frag_num_min=%d",has_frag_num_min_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_frag_num_min=%0d ", has_frag_num_min_in ), UVM_LOW);

    has_frag_num_max_in=0;
    $value$plusargs("has_frag_num_max=%d",has_frag_num_max_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_frag_num_max=%0d ", has_frag_num_max_in ), UVM_LOW);

    has_frag_new_ctrl_in=0;
    $value$plusargs("has_frag_new_ctrl=%d",has_frag_new_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_frag_new_ctrl=%0d ", has_frag_new_ctrl_in ), UVM_LOW);

    has_frag_new_prob_in=0;
    $value$plusargs("has_frag_new_prob=%d",has_frag_new_prob_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_frag_new_prob=%0d ", has_frag_new_prob_in ), UVM_LOW);

    has_renq_qid_sel_mode_in=0;
    $value$plusargs("has_renq_qid_sel_mode=%d",has_renq_qid_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_renq_qid_sel_mode_in=%0d ", has_renq_qid_sel_mode_in ), UVM_LOW);

    has_renq_qpri_sel_mode_in=0;
    $value$plusargs("has_renq_qpri_sel_mode=%d",has_renq_qpri_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_renq_qpri_sel_mode_in=%0d ", has_renq_qpri_sel_mode_in ), UVM_LOW);

    has_renq_qtype_sel_mode_in=0;
    $value$plusargs("has_renq_qtype_sel_mode=%d",has_renq_qtype_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_renq_qtype_sel_mode_in=%0d ", has_renq_qtype_sel_mode_in ), UVM_LOW);

    has_renq_lockid_sel_mode_in=0;
    $value$plusargs("has_renq_lockid_sel_mode=%d",has_renq_lockid_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_renq_lockid_sel_mode_in=%0d ", has_renq_lockid_sel_mode_in ), UVM_LOW);

    
    has_rels_ctrl_in=0;
    $value$plusargs("has_rels_ctrl=%d",has_rels_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_rels_ctrl=%0d ", has_rels_ctrl_in ), UVM_LOW);

    has_stream_ctrl_in=0;
    $value$plusargs("has_stream_ctrl=%d",has_stream_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_stream_ctrl=%0d ", has_stream_ctrl_in ), UVM_LOW);

    has_strenq_num_min_in=0;
    $value$plusargs("has_strenq_num_min=%d",has_strenq_num_min_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_strenq_num_min=%0d ", has_strenq_num_min_in ), UVM_LOW);

    has_strenq_num_max_in=0;
    $value$plusargs("has_strenq_num_max=%d",has_strenq_num_max_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_strenq_num_max=%0d ", has_strenq_num_max_in ), UVM_LOW);

    //---------------------------------------
    //-- per CQ based settings 
    //---------------------------------------
    hcw_delay_in=has_hcw_delay_in; //-- not used
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_delay_in);

    illegal_hcw_prob = 0;
    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_PROB",pp_cq_prefix,pp_cq_num_in),"=%d"}, illegal_hcw_prob);

    illegal_hcw_burst_len = 0;
    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_BURST_LEN",pp_cq_prefix,pp_cq_num_in),"=%d"}, illegal_hcw_burst_len);

    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_HCW_TYPE",pp_cq_prefix,pp_cq_num_in),"=%s"}, illegal_hcw_type_str);
    illegal_hcw_type_str = illegal_hcw_type_str.tolower();

    new_weight_in = has_new_weight_in;
    $value$plusargs({$psprintf("%s_PP%0d_NEW_WEIGHT",pp_cq_prefix,pp_cq_num_in),"=%d"}, new_weight_in);

    comp_weight_in = has_comp_weight_in;
    $value$plusargs({$psprintf("%s_PP%0d_COMP_WEIGHT",pp_cq_prefix,pp_cq_num_in),"=%d"}, comp_weight_in);

    pp_cq_enable = has_pp_cq_enable;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_ENA",pp_cq_prefix,pp_cq_num_in),"=%d"}, pp_cq_enable);
    

    wu_min=0;
    $value$plusargs({$psprintf("%s_PP%0d_WU_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, wu_min);

    wu_max=3;
    $value$plusargs({$psprintf("%s_PP%0d_WU_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, wu_max);

    hcw_qpri_weight0=has_hcw_qpri_weight0;
    hcw_qpri_weight1=has_hcw_qpri_weight1;
    hcw_qpri_weight2=has_hcw_qpri_weight2;
    hcw_qpri_weight3=has_hcw_qpri_weight3;
    hcw_qpri_weight4=has_hcw_qpri_weight4;
    hcw_qpri_weight5=has_hcw_qpri_weight5;
    hcw_qpri_weight6=has_hcw_qpri_weight6;
    hcw_qpri_weight7=has_hcw_qpri_weight7;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W0",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight0 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W1",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight1 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W2",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight2 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W3",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight3 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W4",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight4 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W5",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight5 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W6",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight6 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W7",pp_cq_prefix,pp_cq_num_in),"=%d"}, hcw_qpri_weight7 );
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight0=%0d ", hcw_qpri_weight0), UVM_LOW);
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight1=%0d ", hcw_qpri_weight1), UVM_LOW);
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight2=%0d ", hcw_qpri_weight2), UVM_LOW);
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight3=%0d ", hcw_qpri_weight3), UVM_LOW);
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight4=%0d ", hcw_qpri_weight4), UVM_LOW);
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight5=%0d ", hcw_qpri_weight5), UVM_LOW);
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight6=%0d ", hcw_qpri_weight6), UVM_LOW);
    uvm_report_info("START_PP_CQ_HQMPROC", $psprintf("start_pp_cq_hqmprocseq setting: hcw_qpri_weight7=%0d ", hcw_qpri_weight7), UVM_LOW);

 
    seq_mon_watchdog_timeout_in=has_mon_watchdog_timeout;
    $value$plusargs({$psprintf("%s_PP%0d_SEQ_MON_WATCHDOG_TIMEOUT",pp_cq_prefix,pp_cq_num_in),"=%d"}, seq_mon_watchdog_timeout_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: %0s PP %0d seq_mon_watchdog_timeout_in=%0d ", is_ldb?"LDB":"DIR", pp_cq_num_in, seq_mon_watchdog_timeout_in ), UVM_LOW);

    hqmproc_trfidle_enable_in=has_trfidle_enable; //--this is a watchdog trying to stop seq by calling force_seq_stop
    $value$plusargs({$psprintf("%s_PP%0d_TRFIDLE_ENA",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfidle_enable_in);

    hqmproc_trfidle_num_in=has_trfidle_num; //--this is a watchdog trying to stop seq by calling force_seq_stop
    $value$plusargs({$psprintf("%s_PP%0d_TRFIDLE_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfidle_num_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: %0s PP %0d hqmproc_trfidle_enable_in=%0d hqmproc_trfidle_num_in=%0d", is_ldb?"LDB":"DIR", pp_cq_num_in, hqmproc_trfidle_enable_in, hqmproc_trfidle_num_in ), UVM_LOW);

    hqmproc_watchdog_ctrl_mode_in=1; //--watchdog default mode is on (1); when set to 0: bypass watchdog_monitor();
    $value$plusargs({$psprintf("%s_PP%0d_WATCHDOGCTRL_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_watchdog_ctrl_mode_in);

    hqmproc_trfctrl_sel_mode_in=has_trfctrl_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfctrl_sel_mode_in);
        
    hqmproc_trfflow_ctrl_mode_in=has_trfflow_ctrl_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFLOW_CTRLMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_trfflow_ctrl_mode_in);

    hqmproc_rtntokctrl_sel_mode_in=has_rtntokctrl_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_sel_mode_in);
    
    hqmproc_rtntokctrl_holdnum_in=has_rtntokctrl_holdnum_in;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_holdnum_in);
    
    hqmproc_rtntokctrl_holdnum_waitnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_WAITNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_holdnum_waitnum_in);
    
    hqmproc_rtntokctrl_checknum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_CHKNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_checknum_in);

    hqmproc_rtntokctrl_keepnum_min_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_KEEPNUM_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_keepnum_min_in);

    hqmproc_rtntokctrl_keepnum_max_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_KEEPNUM_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_keepnum_max_in);

    hqmproc_rtntokctrl_rtnnum_min_in=has_rtntokctrl_rtnnum_min_in;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_RTNNUM_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_rtnnum_min_in);

    hqmproc_rtntokctrl_rtnnum_max_in=has_rtntokctrl_rtnnum_max_in;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_RTNNUM_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_rtnnum_max_in);

    hqmproc_rtntokctrl_threshold_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNTOKCTRL_THRESHOLD",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtntokctrl_threshold_in);
   
    hqmproc_rtncmpctrl_sel_mode_in=has_rtncmpctrl_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_sel_mode_in);

    hqmproc_rtncmpctrl_rtnnum_in=has_rtncmpctrl_rtnnum_in;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_RTNNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_rtnnum_in);

    hqmproc_rtncmpctrl_holdnum_in=has_rtncmpctrl_holdnum_in;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_holdnum_in);

    hqmproc_rtncmpctrl_holdnum_waitnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_WAITNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_holdnum_waitnum_in);

    hqmproc_rtncmpctrl_checknum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTNCMPCTRL_CHKNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtncmpctrl_checknum_in);



    hqmproc_rtn_a_cmpctrl_sel_mode_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTN_ACMPCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtn_a_cmpctrl_sel_mode_in);

    hqmproc_rtn_a_cmpctrl_holdnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTN_ACMPCTRL_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtn_a_cmpctrl_holdnum_in);

    hqmproc_rtn_a_cmpctrl_holdnum_waitnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_RTN_ACMPCTRL_WAITNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rtn_a_cmpctrl_holdnum_waitnum_in);


    hqmproc_cq_intr_thres_num_in=1;
    $value$plusargs({$psprintf("%s_PP%0d_CQINTR_THRES_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_cq_intr_thres_num_in);

    has_cq_rearm_ctrl_in=0;
    $value$plusargs("has_cq_rearm_ctrl=%h",has_cq_rearm_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cq_rearm_ctrl_in=0x%0x ", has_cq_rearm_ctrl_in ), UVM_LOW);

    //--cial flow control
    //--when has_cq_intr_run_on=1, it's free run, overwrite hqmproc_cq_rearm_ctrl_in=0x80
    if(has_cq_intr_run_on) begin
       hqmproc_cq_rearm_ctrl_in=has_cq_rearm_ctrl_in;
       $value$plusargs({$psprintf("%s_PP%0d_CQREARM_CTRL",pp_cq_prefix,pp_cq_num_in),"=%h"}, hqmproc_cq_rearm_ctrl_in);
       hqmproc_cq_rearm_ctrl_in[7]=1;
       uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cq_intr_run_on=1; hqmproc_cq_intr_thres_num_in=%0d hqmproc_cq_rearm_ctrl_in=0x%0x  ", hqmproc_cq_intr_thres_num_in, hqmproc_cq_rearm_ctrl_in ), UVM_LOW);
    end else begin
       hqmproc_cq_rearm_ctrl_in=has_cq_rearm_ctrl_in;
       $value$plusargs({$psprintf("%s_PP%0d_CQREARM_CTRL",pp_cq_prefix,pp_cq_num_in),"=%h"}, hqmproc_cq_rearm_ctrl_in);
       uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cq_intr_run_on=0; hqmproc_cq_intr_thres_num_in=%0d hqmproc_cq_rearm_ctrl_in=0x%0x  ", hqmproc_cq_intr_thres_num_in, hqmproc_cq_rearm_ctrl_in ), UVM_LOW);
    end 

    //-- after receiving cq.intr, control cq_intr response time, then return tokens, and rearm afterwards
    has_cq_intr_resp_waitnum_min_in=0;
    $value$plusargs("has_cq_intr_resp_waitnum_min=%d",has_cq_intr_resp_waitnum_min_in);
    has_cq_intr_resp_waitnum_max_in=8;
    $value$plusargs("has_cq_intr_resp_waitnum_max=%d",has_cq_intr_resp_waitnum_max_in);

    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cq_intr_resp_waitnum_min_in=%0d has_cq_intr_resp_waitnum_max_in=%0d", has_cq_intr_resp_waitnum_min_in, has_cq_intr_resp_waitnum_max_in ), UVM_LOW);

    hqmproc_cq_intr_resp_waitnum_min_in=has_cq_intr_resp_waitnum_min_in;
    hqmproc_cq_intr_resp_waitnum_max_in=has_cq_intr_resp_waitnum_max_in;
    $value$plusargs({$psprintf("%s_PP%0d_CQINTR_RESP_WAITNUM_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_cq_intr_resp_waitnum_min_in);
    $value$plusargs({$psprintf("%s_PP%0d_CQINTR_RESP_WAITNUM_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_cq_intr_resp_waitnum_max_in);
       uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_cq_intr_resp_waitnum_min_in=%0d hqmproc_cq_intr_resp_waitnum_max_in=%0d ", hqmproc_cq_intr_resp_waitnum_min_in, hqmproc_cq_intr_resp_waitnum_max_in ), UVM_LOW);

    //-- cq_irq_mask support 
    has_cqirq_mask_waitnum_min_in=1000;
    $value$plusargs("has_cqirq_mask_waitnum_min=%d",has_cqirq_mask_waitnum_min_in);
    has_cqirq_mask_waitnum_max_in=1000;
    $value$plusargs("has_cqirq_mask_waitnum_max=%d",has_cqirq_mask_waitnum_max_in);

    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cqirq_mask_waitnum_min_in=%0d has_cqirq_mask_waitnum_max_in=%0d", has_cqirq_mask_waitnum_min_in, has_cqirq_mask_waitnum_max_in ), UVM_LOW);

    hqmproc_cqirq_mask_waitnum_min_in=has_cqirq_mask_waitnum_min_in;
    hqmproc_cqirq_mask_waitnum_max_in=has_cqirq_mask_waitnum_max_in;
    $value$plusargs({$psprintf("%s_PP%0d_CQIRQ_MASK_WAITNUM_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_cqirq_mask_waitnum_min_in);
    $value$plusargs({$psprintf("%s_PP%0d_CQIRQ_MASK_WAITNUM_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_cqirq_mask_waitnum_max_in);
       uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_cqirq_mask_waitnum_min_in=%0d hqmproc_cqirq_mask_waitnum_max_in=%0d ", hqmproc_cqirq_mask_waitnum_min_in, hqmproc_cqirq_mask_waitnum_max_in ), UVM_LOW);


    //--cq_cwdt_ctrl
    has_cq_cwdt_ctrl_in=0;
    $value$plusargs("has_cq_cwdt_ctrl=%d",has_cq_cwdt_ctrl_in);

    hqmproc_cq_cwdt_ctrl_in=has_cq_cwdt_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_CQCWDT_CTRL",pp_cq_prefix,pp_cq_num_in),"=%h"}, hqmproc_cq_cwdt_ctrl_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cq_cwdt_ctrl_in=%0d; hqmproc_cq_cwdt_ctrl_in=%0d   ", has_cq_cwdt_ctrl_in, hqmproc_cq_cwdt_ctrl_in ), UVM_LOW);

    //--dta_ctrl
    hqmproc_dta_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_DTA_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_dta_ctrl_in);
    hqmproc_dta_srcpp_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_DTA_SRCPP",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_dta_srcpp_in);
    hqmproc_dta_wpp_idlenum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_DTA_WPP_IDLENUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_dta_wpp_idlenum_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_dta_ctrl_in=%0d; hqmproc_dta_srcpp_in=%0d hqmproc_dta_wpp_idlenum_in=%0d", hqmproc_dta_ctrl_in, hqmproc_dta_srcpp_in, hqmproc_dta_wpp_idlenum_in ), UVM_LOW);



    //--enqctrl
    has_enqctrl_sel_mode_in=0;
    $value$plusargs("has_enqctrl_sel_mode=%d",has_enqctrl_sel_mode_in);

    hqmproc_enqctrl_sel_mode_in=has_enqctrl_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_ENQCTRL_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_enqctrl_sel_mode_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_enqctrl_sel_mode_in=%0d; hqmproc_enqctrl_sel_mode_in=%0d   ", has_enqctrl_sel_mode_in, hqmproc_enqctrl_sel_mode_in ), UVM_LOW);

    has_cq_dep_chk_adj_in=0;
    $value$plusargs("has_cq_dep_chk_adj=%d",has_cq_dep_chk_adj_in);

    hqmproc_cq_dep_chk_adj_in=has_cq_dep_chk_adj_in;
    $value$plusargs({$psprintf("%s_PP%0d_CQDEP_CHK_ADJ",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_cq_dep_chk_adj_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: has_cq_dep_chk_adj_in=%0d; hqmproc_cq_dep_chk_adj_in=%0d", has_cq_dep_chk_adj_in, hqmproc_cq_dep_chk_adj_in ), UVM_LOW);


    hqmproc_enqctrl_newnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_ENQCTRL_NEWNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_enqctrl_newnum_in);

    hqmproc_enqctrl_fragnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_ENQCTRL_FRAGNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_enqctrl_fragnum_in);

    hqmproc_enqctrl_enqnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_ENQCTRL_ENQNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_enqctrl_enqnum_in);

    hqmproc_enqctrl_enqnum_1_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_ENQCTRL_ENQNUM_1",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_enqctrl_enqnum_1_in);

    hqmproc_enqctrl_hold_waitnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_ENQCTRL_WAITNUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_enqctrl_hold_waitnum_in);


    hqmproc_qid_sel_mode_in=has_qid_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_QID_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_qid_sel_mode_in);

    hqmproc_qid_gen_prob_in=has_qid_gen_prob_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_QID_GENPROB",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_qid_gen_prob_in);

    hqmproc_qtype_sel_mode_in=has_qtype_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_QTYPE_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_qtype_sel_mode_in);

    hqmproc_qpri_sel_mode_in=has_qpri_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_QPRI_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_qpri_sel_mode_in);

    hqmproc_lockid_sel_mode_in=has_lockid_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRF_LOCKID_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_lockid_sel_mode_in);

    hqmproc_acomp_ctrl_in=has_acomp_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_ACOMP_CTRL_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_acomp_ctrl_in);

    hqmproc_frag_ctrl_in=has_frag_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFRAG_CTRL_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_frag_ctrl_in);

    hqmproc_frag_replay_ctrl_in=has_frag_replay_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFRAG_REPLAY_CTRL_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_frag_replay_ctrl_in);

    hqmproc_frag_t_ctrl_in=has_frag_t_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFRAG_T_CTRL_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_frag_t_ctrl_in);

    hqmproc_frag_num_min_in=has_frag_num_min_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFRAG_NUM_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_frag_num_min_in);

    hqmproc_frag_num_max_in=has_frag_num_max_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFRAG_NUM_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_frag_num_max_in);

    hqmproc_frag_new_ctrl_in=has_frag_new_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFRAG_NEW_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_frag_new_ctrl_in);

    hqmproc_frag_new_prob_in=has_frag_new_prob_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFFRAG_NEW_PROB",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_frag_new_prob_in);

    hqmproc_renq_qid_sel_mode_in=has_renq_qid_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFRENQ_QID_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_renq_qid_sel_mode_in);

    hqmproc_renq_qtype_sel_mode_in=has_renq_qtype_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFRENQ_QTYPE_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_renq_qtype_sel_mode_in);

    hqmproc_renq_qpri_sel_mode_in=has_renq_qpri_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFRENQ_QPRI_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_renq_qpri_sel_mode_in);

    hqmproc_renq_lockid_sel_mode_in=has_renq_lockid_sel_mode_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFRENQ_LOCKID_SELMODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_renq_lockid_sel_mode_in);

    hqmproc_nodec_fragnum_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRFNODEC_FRAG_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_nodec_fragnum_in);


    hqmproc_rel_qtype_sel_in=1;
    $value$plusargs({$psprintf("%s_PP%0d_TRFREL_QTYPE_SEL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rel_qtype_sel_in);
    hqmproc_rel_qtype_in=QATM;
    hqmproc_rel_qtype_str_in="QATM";
    $value$plusargs({$psprintf("%s_PP%0d_TRFREL_QTYPE",pp_cq_prefix,pp_cq_num_in),"=%s"}, hqmproc_rel_qtype_str_in);
    if(hqmproc_rel_qtype_sel_in==1) begin
      case(hqmproc_rel_qtype_str_in)
         "QATM" : hqmproc_rel_qtype_in=QATM;
         "QUNO" : hqmproc_rel_qtype_in=QUNO;
         "QORD" : hqmproc_rel_qtype_in=QORD;
         "QDIR" : hqmproc_rel_qtype_in=QDIR;
       default  : begin
                    hqmproc_rel_qtype_rndsel=$urandom_range(0,2);
                    case(hqmproc_rel_qtype_rndsel)
                      0: hqmproc_rel_qtype_in=QATM;
                      1: hqmproc_rel_qtype_in=QUNO;
                      2: hqmproc_rel_qtype_in=QORD;
                    endcase
                  end 
      endcase
    end 
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_rel_qtype_sel_in=%0d hqmproc_rel_qtype_str_in=%0s, hqmproc_rel_qtype_in=%0s ", hqmproc_rel_qtype_sel_in, hqmproc_rel_qtype_str_in, hqmproc_rel_qtype_in.name() ), UVM_LOW);

    hqmproc_rel_qtype_dir_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRFREL_QTYPE_DIR",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rel_qtype_dir_in);
    if(hqmproc_rel_qtype_dir_in==1) hqmproc_rel_qtype_in=QDIR;
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_rel_qtype_inmodified=%0s hqmproc_rel_qtype_dir_in=%0d  ", hqmproc_rel_qtype_in.name(), hqmproc_rel_qtype_dir_in ), UVM_LOW);

    hqmproc_rel_qid_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_TRFREL_QID",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rel_qid_in);


    hqmproc_rels_ctrl_in=has_rels_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFRELS_CTRL_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_rels_ctrl_in);

    hqmproc_stream_ctrl_in=has_stream_ctrl_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFSTREAM_CTRL_MODE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_stream_ctrl_in);

    hqmproc_strenq_num_min_in=has_strenq_num_min_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFSTREAM_NUM_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_strenq_num_min_in);

    hqmproc_strenq_num_max_in=has_strenq_num_max_in;
    $value$plusargs({$psprintf("%s_PP%0d_TRFSTREAM_NUM_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_strenq_num_max_in);

    hqmproc_lsp_qid_ck_congest_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_CONGEST_CK",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_lsp_qid_ck_congest_in);

    hqmproc_lsp_qid_congest_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_CONGEST_QID",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_lsp_qid_congest_in);

    hqmproc_meas_enable_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_MEAS_ENB",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_meas_enable_in);
    hqmproc_meas_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_MEAS_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_meas_rand_in);
    hqmproc_idsi_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_IDSI_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_idsi_ctrl_in);

    hqmproc_ingerrinj_ingress_drop_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_INGRESS_DROP",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ingress_drop_in);

    hqmproc_ingerrinj_excess_tok_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCTOK_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_tok_rand_in);
 
    hqmproc_ingerrinj_excess_tok_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCTOK_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_tok_ctrl_in);

    hqmproc_ingerrinj_excess_tok_rate_in=50;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCTOK_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_tok_rate_in);

    hqmproc_ingerrinj_excess_tok_num_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCTOK_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_tok_num_in);

    hqmproc_ingerrinj_excess_cmp_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCCMP_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_cmp_rand_in);

    hqmproc_ingerrinj_excess_cmp_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCCMP_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_cmp_ctrl_in);

    hqmproc_ingerrinj_excess_cmp_rate_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCCMP_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_cmp_rate_in);

    hqmproc_ingerrinj_excess_cmp_num_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXCCMP_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_cmp_num_in);


    hqmproc_ingerrinj_excess_a_cmp_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXC_ACMP_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_a_cmp_rand_in);

    hqmproc_ingerrinj_excess_a_cmp_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXC_ACMP_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_a_cmp_ctrl_in);

    hqmproc_ingerrinj_excess_a_cmp_rate_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXC_ACMP_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_a_cmp_rate_in);

    hqmproc_ingerrinj_excess_a_cmp_num_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_EXC_ACMP_NUM",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_excess_a_cmp_num_in);



    hqmproc_ingerrinj_cmpid_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_CMPID_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_cmpid_rand_in);

    hqmproc_ingerrinj_cmpid_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_CMPID_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_cmpid_ctrl_in);

    hqmproc_ingerrinj_cmpid_rate_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_CMPID_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_cmpid_rate_in);

    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_ingerrinj_cmpid_rand_in=%0d hqmproc_ingerrinj_cmpid_ctrl_in=%0d hqmproc_ingerrinj_cmpid_rate_in=%0d  ", hqmproc_ingerrinj_cmpid_rand_in, hqmproc_ingerrinj_cmpid_ctrl_in,  hqmproc_ingerrinj_cmpid_rate_in ), UVM_LOW);


    hqmproc_ingerrinj_cmpdirpp_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_CMPDIRPP_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_cmpdirpp_rand_in);

    hqmproc_ingerrinj_cmpdirpp_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_CMPDIRPP_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_cmpdirpp_ctrl_in);

    hqmproc_ingerrinj_cmpdirpp_rate_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_CMPDIRPP_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_cmpdirpp_rate_in);

    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_ingerrinj_cmpdirpp_rand_in=%0d hqmproc_ingerrinj_cmpdirpp_ctrl_in=%0d hqmproc_ingerrinj_cmpdirpp_rate_in=%0d  ", hqmproc_ingerrinj_cmpdirpp_rand_in, hqmproc_ingerrinj_cmpdirpp_ctrl_in,  hqmproc_ingerrinj_cmpdirpp_rate_in ), UVM_LOW);

    hqmproc_ingerrinj_qidill_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_QIDILL_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_qidill_rand_in);

    hqmproc_ingerrinj_qidill_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_QIDILL_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_qidill_ctrl_in);

    hqmproc_ingerrinj_qidill_rate_in=50;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_QIDILL_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_qidill_rate_in);

    hqmproc_ingerrinj_qidill_min_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_QIDILL_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_qidill_min_in);
    hqmproc_ingerrinj_qidill_max_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_QIDILL_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_qidill_max_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_ingerrinj_qidill_rand_in=%0d hqmproc_ingerrinj_qidill_ctrl_in=%0d hqmproc_ingerrinj_qidill_rate_in=%0d hqmproc_ingerrinj_qidill_min_in=%0d hqmproc_ingerrinj_qidill_max_in=%0d ", hqmproc_ingerrinj_qidill_rand_in, hqmproc_ingerrinj_qidill_ctrl_in,  hqmproc_ingerrinj_qidill_rate_in, hqmproc_ingerrinj_qidill_min_in, hqmproc_ingerrinj_qidill_max_in ), UVM_LOW);


    hqmproc_ingerrinj_ppill_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_PPILL_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ppill_rand_in);

    hqmproc_ingerrinj_ppill_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_PPILL_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ppill_ctrl_in);

    hqmproc_ingerrinj_ppill_rate_in=50;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_PPILL_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ppill_rate_in);

    hqmproc_ingerrinj_ppill_min_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_PPILL_MIN",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ppill_min_in);
    hqmproc_ingerrinj_ppill_max_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_PPILL_MAX",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ppill_max_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_ingerrinj_ppill_rand_in=%0d hqmproc_ingerrinj_ppill_ctrl_in=%0d hqmproc_ingerrinj_ppill_rate_in=%0d hqmproc_ingerrinj_ppill_min_in=%0d hqmproc_ingerrinj_ppill_max_in=%0d ", hqmproc_ingerrinj_ppill_rand_in, hqmproc_ingerrinj_ppill_ctrl_in,  hqmproc_ingerrinj_ppill_rate_in, hqmproc_ingerrinj_ppill_min_in, hqmproc_ingerrinj_ppill_max_in ), UVM_LOW);



    hqmproc_ingerrinj_ooc_rand_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_OOC_RAND",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ooc_rand_in);
 
    hqmproc_ingerrinj_ooc_ctrl_in=0;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_OOC_CTRL",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ooc_ctrl_in);

    hqmproc_ingerrinj_ooc_rate_in=50;
    $value$plusargs({$psprintf("%s_PP%0d_INGERRINJ_OOC_RATE",pp_cq_prefix,pp_cq_num_in),"=%d"}, hqmproc_ingerrinj_ooc_rate_in);
    uvm_report_info("START_PP_CQ_HQMPROC",$psprintf("start_pp_cq_hqmprocseq setting: hqmproc_ingerrinj_ooc_rand_in=%0d hqmproc_ingerrinj_ooc_ctrl_in=%0d hqmproc_ingerrinj_ooc_rate_in=%0d ", hqmproc_ingerrinj_ooc_rand_in, hqmproc_ingerrinj_ooc_ctrl_in,  hqmproc_ingerrinj_ooc_rate_in ), UVM_LOW);


    

    
    case (illegal_hcw_type_str)
      "illegal_hcw_cmd":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_HCW_CMD;
      "all_0":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_0;
      "all_1":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_1;
      "illegal_pp_num":         illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_NUM;
      "illegal_pp_type":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_TYPE;
      "illegal_qid_num":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_NUM;
      "illegal_qid_type":       illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_TYPE;
      "illegal_dirpp_rels":     illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_DIRPP_RELS;
      "illegal_dev_vf_num":     illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_DEV_VF_NUM;
      "qid_grt_127":            illegal_hcw_type = hqm_pp_cq_base_seq::QID_GRT_127;
      "vas_write_permission":   illegal_hcw_type = hqm_pp_cq_base_seq::VAS_WRITE_PERMISSION;
    endcase

    `uvm_info("START_PP_CQ_HQMPROC",$psprintf("Starting PP/CQ processing: pp_cq_enable=%0d %s PP/CQ 0x%0x cq_addr=0x%0x is_vf=%d vf_num=0x%0x qid=0x%0x qtype=%s queue_list_size=%0d hcw_delay=%0d enq_flow_in=%0d cqbuf_ctrl_in=%0d cqbuf_init_in=%0d comp_flow_in=%0d cq_tok_flow_in=%0d hqmproc_qid_sel_mode_in=%0d hqmproc_qtype_sel_mode_in=%0d hqmproc_qpri_sel_mode_in=%0d hqmproc_lockid_sel_mode_in=%0d, hqmproc_acomp_ctrl_in=%0d, hqmproc_frag_ctrl_in=%0d hqmproc_frag_replay_ctrl_in=%0d hqmproc_frag_t_ctrl_in=%0d hqmproc_frag_num_min_in=%0d hqmproc_frag_num_max_in=%0d,renq_qid_sel_mode=%0d renq_qtype_sel_mode=%0d renq_qpri_sel_mode=%0d renq_lockid_sel_mode=%0d;; hqmproc_nodec_fragnum_in=%0d hqmproc_rel_qtype_in=%0s hqmproc_rel_qid_in=%0d; hqmproc_rels_ctrl_in=%0d hqmproc_stream_ctrl_in=%0d; hqmproc_lsp_qid_ck_congest_in=%0d hqmproc_lsp_qid_congest_in=%0d; hqmproc_watchdog_ctrl_mode_in=%0d; hqmproc_meas_enable_in=%0d hqmproc_meas_rand_in=%0d hqmproc_idsi_ctrl_in=%0d;   illegal_hcw_prob=%0d, illegal_hcw_burst_len=%0d, illegal_hcw_type=%0s",pp_cq_enable,is_ldb?"LDB":"DIR",pp_cq_num_in,cq_addr_val,is_vf,vf_num,qid,qtype.name(),queue_list_size,hcw_delay_in, enq_flow_in, cqbuf_ctrl_in, cqbuf_init_in, comp_flow_in, cq_tok_flow_in, hqmproc_qid_sel_mode_in, hqmproc_qtype_sel_mode_in, hqmproc_qpri_sel_mode_in, hqmproc_lockid_sel_mode_in, hqmproc_acomp_ctrl_in, hqmproc_frag_ctrl_in, hqmproc_frag_replay_ctrl_in, hqmproc_frag_t_ctrl_in, hqmproc_frag_num_min_in, hqmproc_frag_num_max_in, hqmproc_renq_qid_sel_mode_in, hqmproc_renq_qtype_sel_mode_in, hqmproc_renq_qpri_sel_mode_in, hqmproc_renq_lockid_sel_mode_in,hqmproc_nodec_fragnum_in, hqmproc_rel_qtype_in.name(), hqmproc_rel_qid_in, hqmproc_rels_ctrl_in, hqmproc_stream_ctrl_in, hqmproc_lsp_qid_ck_congest_in, hqmproc_lsp_qid_congest_in, hqmproc_watchdog_ctrl_mode_in, hqmproc_meas_enable_in, hqmproc_meas_rand_in, hqmproc_idsi_ctrl_in, illegal_hcw_prob, illegal_hcw_burst_len, illegal_hcw_type),UVM_LOW)
    
    cq_poll_int = 1;
    $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_num_in),"=%d"}, cq_poll_int);

    if(pp_cq_enable) begin
	`uvm_create(pp_cq_seq)
        pp_cq_seq.inst_suffix = cfg.inst_suffix;
        pp_cq_seq.tb_env_hier = cfg.tb_env_hier;
	pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_num_in)); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
	start_item(pp_cq_seq);
	if (!pp_cq_seq.randomize() with {
                	 pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                	 pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                	 cq_depth                   == 1024;

                	 queue_list.size()          == queue_list_size;

                	 hcw_enqueue_batch_min      == hqmproc_hcw_batch_min;  //1 : Minimum number of HCWs to send as a batch (1-4)
                	 hcw_enqueue_batch_max      == hqmproc_hcw_batch_max;  //1 : Maximum number of HCWs to send as a batch (1-4)

                         pp_max_cacheline_num_min   == cacheline_max_num;
                         pp_max_cacheline_num_max   == cacheline_max_num;
                         pp_max_cacheline_pad_min   == cacheline_max_pad_min;
                         pp_max_cacheline_pad_max   == cacheline_max_pad_max;
                         pp_max_cacheline_shuffle_min   == cacheline_max_shuffle_min;
                         pp_max_cacheline_shuffle_max   == cacheline_max_shuffle_max;
  
                         hcw_enqueue_cl_pad         == cl_pad;

                         hcw_enqueue_wu_min         == wu_min;  // Minimum WU value for HCWs
                         hcw_enqueue_wu_max         == wu_max;  // Maximum WU value for HCWs

                	 hcw_enqueue_pad_prob_min   == hqmproc_hcw_pad_prob_min;  //noop pad_prob 
                	 hcw_enqueue_pad_prob_max   == hqmproc_hcw_pad_prob_max;  //noop pad_prob 

                	 hcw_enqueue_expad_prob_min == hqmproc_hcw_expad_prob_min;  //extra noop pad_prob 
                	 hcw_enqueue_expad_prob_max == hqmproc_hcw_expad_prob_max;  //extra noop pad_prob 

                	 queue_list_delay_min       == hcw_delay_min_in; //hcw_delay_in;
                	 queue_list_delay_max       == hcw_delay_max_in; //hcw_delay_in;
                	 new_hcw_en_delay_min       == newhcw_delay_min_in;
                	 new_hcw_en_delay_max       == newhcw_delay_max_in;

                         hcw_delay_ctrl_mode        == hcw_delay_ctrl_mode_in;

                	 cq_addr                    == cq_addr_val;  //--AY_HQMV30_ATS cq_physical_addr_val
                         ims_poll_addr              == ims_poll_addr_val;

                	 cq_poll_interval           == cq_poll_int;
                	 new_weight                 == new_weight_in;
                	 comp_weight                == comp_weight_in;
			 
                         mon_watchdog_timeout       == seq_mon_watchdog_timeout_in; //--pp_cq_base_seq mon_watchdog_timeout
 
                         hqmproc_trfgen_watchdog_ena == hqmproc_trfgen_watchdog_ena_in;
                         hqmproc_trfgen_watchdog_num == hqmproc_trfgen_watchdog_num_in;
                         hqmproc_trfctrl_sel_mode    == hqmproc_trfctrl_sel_mode_in;
                         hqmproc_trfflow_ctrl_mode   == hqmproc_trfflow_ctrl_mode_in;
                         hqmproc_trfidle_enable      == hqmproc_trfidle_enable_in; //--watchdog counting idles trying to force_seq_stop
                         hqmproc_trfidle_num         == hqmproc_trfidle_num_in;    //--watchdog counting idles trying to force_seq_stop
                         hqmproc_watchdogctrl_sel_mode == hqmproc_watchdog_ctrl_mode_in;
                         hqmproc_cqbufctrl_sel_mode  == cqbuf_ctrl_in;
                         hqmproc_cqbufinit_sel_mode  == cqbuf_init_in;
                         hqmproc_rtntokctrl_sel_mode == hqmproc_rtntokctrl_sel_mode_in;
                         hqmproc_rtntokctrl_holdnum  == hqmproc_rtntokctrl_holdnum_in;
                         hqmproc_rtntokctrl_holdnum_waitnum  == hqmproc_rtntokctrl_holdnum_waitnum_in;
			 hqmproc_rtntokctrl_checknum == hqmproc_rtntokctrl_checknum_in;
			 hqmproc_rtntokctrl_keepnum_min == hqmproc_rtntokctrl_keepnum_min_in;
			 hqmproc_rtntokctrl_keepnum_max == hqmproc_rtntokctrl_keepnum_max_in;
			 hqmproc_rtntokctrl_rtnnum_min == hqmproc_rtntokctrl_rtnnum_min_in;
			 hqmproc_rtntokctrl_rtnnum_max == hqmproc_rtntokctrl_rtnnum_max_in;
                         hqmproc_rtntokctrl_threshold  == hqmproc_rtntokctrl_threshold_in;
                         hqmproc_rtncmpctrl_sel_mode == hqmproc_rtncmpctrl_sel_mode_in;
			 hqmproc_rtncmpctrl_rtnnum   == hqmproc_rtncmpctrl_rtnnum_in;
			 hqmproc_rtncmpctrl_holdnum  == hqmproc_rtncmpctrl_holdnum_in;
			 hqmproc_rtncmpctrl_holdnum_waitnum  == hqmproc_rtncmpctrl_holdnum_waitnum_in;
			 hqmproc_rtncmpctrl_checknum == hqmproc_rtncmpctrl_checknum_in;
			 
                         hqmproc_rtn_a_cmpctrl_sel_mode == hqmproc_rtn_a_cmpctrl_sel_mode_in;
			 hqmproc_rtn_a_cmpctrl_holdnum  == hqmproc_rtn_a_cmpctrl_holdnum_in;
			 hqmproc_rtn_a_cmpctrl_holdnum_waitnum  == hqmproc_rtn_a_cmpctrl_holdnum_waitnum_in;

                         hqmproc_cq_intr_thres_num   == hqmproc_cq_intr_thres_num_in;
                         hqmproc_cq_rearm_ctrl       == hqmproc_cq_rearm_ctrl_in;

                         hqmproc_cq_cwdt_ctrl        == hqmproc_cq_cwdt_ctrl_in;

                         hqmproc_cq_intr_resp_waitnum_min    == hqmproc_cq_intr_resp_waitnum_min_in;
                         hqmproc_cq_intr_resp_waitnum_max    == hqmproc_cq_intr_resp_waitnum_max_in;
  
                         hqmproc_cqirq_mask_waitnum_min    == hqmproc_cqirq_mask_waitnum_min_in;
                         hqmproc_cqirq_mask_waitnum_max    == hqmproc_cqirq_mask_waitnum_max_in;
                         hqmproc_cqirq_mask_ena            == hqmproc_cqirq_mask_ena_in;
  
                         hqmproc_dta_ctrl            == hqmproc_dta_ctrl_in;
                         hqmproc_dta_srcpp           == hqmproc_dta_srcpp_in;
                         hqmproc_dta_wpp_idlenum     == hqmproc_dta_wpp_idlenum_in;

                         hqmproc_enqctrl_sel_mode    == hqmproc_enqctrl_sel_mode_in;
                         hqmproc_enqctrl_newnum      == hqmproc_enqctrl_newnum_in;
                         hqmproc_enqctrl_fragnum     == hqmproc_enqctrl_fragnum_in;
                         hqmproc_enqctrl_enqnum      == hqmproc_enqctrl_enqnum_in;
                         hqmproc_enqctrl_enqnum_1    == hqmproc_enqctrl_enqnum_1_in;
                         hqmproc_enqctrl_hold_waitnum == hqmproc_enqctrl_hold_waitnum_in;

                         hqmproc_cq_dep_chk_adj      == hqmproc_cq_dep_chk_adj_in;

                         hqmproc_qid_sel_mode        == hqmproc_qid_sel_mode_in;
                         hqmproc_qid_gen_prob        == hqmproc_qid_gen_prob_in;
                         hqmproc_qtype_sel_mode      == hqmproc_qtype_sel_mode_in;
                         hqmproc_qpri_sel_mode       == hqmproc_qpri_sel_mode_in;
                         hqmproc_lockid_sel_mode     == hqmproc_lockid_sel_mode_in;

                         hqmproc_acomp_ctrl          == hqmproc_acomp_ctrl_in; 

                         hqmproc_frag_ctrl           == hqmproc_frag_ctrl_in; 
                         hqmproc_frag_replay_ctrl    == hqmproc_frag_replay_ctrl_in; 
                         hqmproc_frag_num_min        == hqmproc_frag_num_min_in;
                         hqmproc_frag_num_max        == hqmproc_frag_num_max_in; 
                         hqmproc_frag_t_ctrl         == hqmproc_frag_t_ctrl_in; 

                         hqmproc_frag_new_ctrl       == hqmproc_frag_new_ctrl_in; 
                         hqmproc_frag_new_prob       == hqmproc_frag_new_prob_in; 

                         hqmproc_renq_qid_sel_mode   == hqmproc_renq_qid_sel_mode_in;
                         hqmproc_renq_qtype_sel_mode == hqmproc_renq_qtype_sel_mode_in;
                         hqmproc_renq_qpri_sel_mode  == hqmproc_renq_qpri_sel_mode_in;
                         hqmproc_renq_lockid_sel_mode== hqmproc_renq_lockid_sel_mode_in;
                         hqmproc_nodec_fragnum       == hqmproc_nodec_fragnum_in;
                         hqmproc_rel_qtype           == hqmproc_rel_qtype_in;
                         hqmproc_rel_qid             == hqmproc_rel_qid_in;
               
                         hqmproc_stream_ctrl         == hqmproc_stream_ctrl_in; 
                         hqmproc_strenq_num_min      == hqmproc_strenq_num_min_in;
                         hqmproc_strenq_num_max      == hqmproc_strenq_num_max_in; 
                         hqmproc_rels_ctrl           == hqmproc_rels_ctrl_in; 
                     
                         hqm_lsp_qid_ck_congest      == hqmproc_lsp_qid_ck_congest_in;
                         hqm_lsp_qid_congest         == hqmproc_lsp_qid_congest_in;

                         hqmproc_meas_enable         == hqmproc_meas_enable_in;
                         hqmproc_meas_rand           == hqmproc_meas_rand_in;
                         hqmproc_idsi_ctrl           == hqmproc_idsi_ctrl_in;

                         hqmproc_ingerrinj_ingress_drop == hqmproc_ingerrinj_ingress_drop_in;

                         hqmproc_ingerrinj_excess_tok_rand == hqmproc_ingerrinj_excess_tok_rand_in;
                         hqmproc_ingerrinj_excess_tok_ctrl == hqmproc_ingerrinj_excess_tok_ctrl_in;
                         hqmproc_ingerrinj_excess_tok_rate == hqmproc_ingerrinj_excess_tok_rate_in;
                         hqmproc_ingerrinj_excess_tok_num  == hqmproc_ingerrinj_excess_tok_num_in;

                         hqmproc_ingerrinj_excess_cmp_rand == hqmproc_ingerrinj_excess_cmp_rand_in;
                         hqmproc_ingerrinj_excess_cmp_ctrl == hqmproc_ingerrinj_excess_cmp_ctrl_in;
                         hqmproc_ingerrinj_excess_cmp_rate == hqmproc_ingerrinj_excess_cmp_rate_in;
                         hqmproc_ingerrinj_excess_cmp_num  == hqmproc_ingerrinj_excess_cmp_num_in;


                         hqmproc_ingerrinj_excess_a_cmp_rand == hqmproc_ingerrinj_excess_a_cmp_rand_in;
                         hqmproc_ingerrinj_excess_a_cmp_ctrl == hqmproc_ingerrinj_excess_a_cmp_ctrl_in;
                         hqmproc_ingerrinj_excess_a_cmp_rate == hqmproc_ingerrinj_excess_a_cmp_rate_in;
                         hqmproc_ingerrinj_excess_a_cmp_num  == hqmproc_ingerrinj_excess_a_cmp_num_in;

                         hqmproc_ingerrinj_cmpid_rand == hqmproc_ingerrinj_cmpid_rand_in;
                         hqmproc_ingerrinj_cmpid_ctrl == hqmproc_ingerrinj_cmpid_ctrl_in;
                         hqmproc_ingerrinj_cmpid_rate == hqmproc_ingerrinj_cmpid_rate_in;

                         hqmproc_ingerrinj_cmpdirpp_rand == hqmproc_ingerrinj_cmpdirpp_rand_in;
                         hqmproc_ingerrinj_cmpdirpp_ctrl == hqmproc_ingerrinj_cmpdirpp_ctrl_in;
                         hqmproc_ingerrinj_cmpdirpp_rate == hqmproc_ingerrinj_cmpdirpp_rate_in;

                         hqmproc_ingerrinj_ooc_rand == hqmproc_ingerrinj_ooc_rand_in;
                         hqmproc_ingerrinj_ooc_ctrl == hqmproc_ingerrinj_ooc_ctrl_in;
                         hqmproc_ingerrinj_ooc_rate == hqmproc_ingerrinj_ooc_rate_in;

                         hqmproc_ingerrinj_qidill_rand == hqmproc_ingerrinj_qidill_rand_in;
                         hqmproc_ingerrinj_qidill_ctrl == hqmproc_ingerrinj_qidill_ctrl_in;
                         hqmproc_ingerrinj_qidill_rate == hqmproc_ingerrinj_qidill_rate_in;
                         hqmproc_ingerrinj_qidill_min  == hqmproc_ingerrinj_qidill_min_in;
                         hqmproc_ingerrinj_qidill_max  == hqmproc_ingerrinj_qidill_max_in;

                         hqmproc_ingerrinj_ppill_rand == hqmproc_ingerrinj_ppill_rand_in;
                         hqmproc_ingerrinj_ppill_ctrl == hqmproc_ingerrinj_ppill_ctrl_in;
                         hqmproc_ingerrinj_ppill_rate == hqmproc_ingerrinj_ppill_rate_in;
                         hqmproc_ingerrinj_ppill_min  == hqmproc_ingerrinj_ppill_min_in;
                         hqmproc_ingerrinj_ppill_max  == hqmproc_ingerrinj_ppill_max_in;

                       } ) begin
	  `uvm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
	end 

	if ($value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, vf_num)) begin
	  if (vf_num >= 0) begin
            is_vf   = 1;
	  end else begin
            is_vf   = 0;
	  end 
	end 

	pp_cq_seq.is_vf   = is_vf;
	pp_cq_seq.vf_num  = vf_num;

	$value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, qid);

	qtype_str = qtype.name();
	$value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, qtype_str);
	qtype_str = qtype_str.tolower();

	lock_id = 16'h4001;
	$value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, lock_id);

	 dsi = 16'h0100;
       // $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, dsi);

        //--renq specific control
	renq_qtype_str = renq_qtype.name();
	$value$plusargs({$psprintf("%s_PP%0d_RENQ_QTYPE",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%s"}, renq_qtype_str);
	renq_qtype_str = renq_qtype_str.tolower();

	$value$plusargs({$psprintf("%s_PP%0d_RENQ_QID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, renq_qid);
        renq_qpri=0;
	$value$plusargs({$psprintf("%s_PP%0d_RENQ_PRI",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=%d"}, renq_qpri);
        renq_lockid=0;
	$value$plusargs({$psprintf("%s_PP%0d_RENQ_LOCKID",pp_cq_prefix,pp_cq_seq.pp_cq_num),"=0x%x"}, renq_lockid);


        //----------------------------------
        //--comp return controls
        //----------------------------------
        has_comp_return_delay_mode_in=0;
        $value$plusargs("has_comp_return_delay_mode=%d",has_comp_return_delay_mode_in);
        if($value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay_mode)) begin
             pp_cq_seq.comp_return_delay_mode = comp_return_delay_mode;
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, comp_return_delay_mode), UVM_LOW);
        end else begin
             pp_cq_seq.comp_return_delay_mode = has_comp_return_delay_mode_in;
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE=%0d (setting)", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_comp_return_delay_mode_in), UVM_LOW);
        end 
    
        has_comp_return_delay_qsize=0;
        $value$plusargs("has_comp_return_delay_qsize=%d",has_comp_return_delay_qsize);

        has_comp_return_delay_min=0;
        $value$plusargs("has_comp_return_delay_min=%d",has_comp_return_delay_min);
        has_comp_return_delay_max=0;
        $value$plusargs("has_comp_return_delay_max=%d",has_comp_return_delay_max);
        has_comp_return_delay_num=$urandom_range(has_comp_return_delay_max, has_comp_return_delay_min);
        if($value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay)) begin
             pp_cq_seq.comp_return_delay_q.push_back(comp_return_delay);
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, comp_return_delay), UVM_LOW);
        end else if(has_comp_return_delay_num>0) begin
             pp_cq_seq.comp_return_delay_q.push_back(has_comp_return_delay_num);
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d (setting)", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_comp_return_delay_num), UVM_LOW);
             for(int dind=0; dind<has_comp_return_delay_qsize; dind++) begin
               has_comp_return_delay_num=$urandom_range(has_comp_return_delay_max, has_comp_return_delay_min);
               pp_cq_seq.comp_return_delay_q.push_back(has_comp_return_delay_max);
               pp_cq_seq.comp_return_delay_q.push_back(has_comp_return_delay_min);
               pp_cq_seq.comp_return_delay_q.push_back(has_comp_return_delay_num);
               uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d (setting) - pp_cq_seq.comp_return_delay_q.size=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_comp_return_delay_num, pp_cq_seq.comp_return_delay_q.size()), UVM_LOW);
             end 

        end 
    

        //----------------------------------
        //--a_comp return controls
        //----------------------------------
        has_a_comp_return_delay_mode_in=0;
        $value$plusargs("has_a_comp_return_delay_mode=%d",has_a_comp_return_delay_mode_in);
        if($value$plusargs({$psprintf("%s_PP%0d_A_COMP_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, a_comp_return_delay_mode)) begin
             pp_cq_seq.a_comp_return_delay_mode = a_comp_return_delay_mode;
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, a_comp_return_delay_mode), UVM_LOW);
        end else begin
             pp_cq_seq.a_comp_return_delay_mode = has_a_comp_return_delay_mode_in;
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY_MODE=%0d (setting)", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_a_comp_return_delay_mode_in), UVM_LOW);
        end 
    
        has_a_comp_return_delay_min=0;
        $value$plusargs("has_a_comp_return_delay_min=%d",has_a_comp_return_delay_min);
        has_a_comp_return_delay_max=0;
        $value$plusargs("has_a_comp_return_delay_max=%d",has_a_comp_return_delay_max);
        has_a_comp_return_delay_num=$urandom_range(has_a_comp_return_delay_max, has_a_comp_return_delay_min);

        has_a_comp_return_delay_qsize=0;
        $value$plusargs("has_a_comp_return_delay_qsize=%d",has_a_comp_return_delay_qsize);

        if($value$plusargs({$psprintf("%s_PP%0d_A_COMP_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, a_comp_return_delay)) begin
             pp_cq_seq.a_comp_return_delay_q.push_back(a_comp_return_delay);
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, a_comp_return_delay), UVM_LOW);
        end else if(has_a_comp_return_delay_num>0) begin
             pp_cq_seq.a_comp_return_delay_q.push_back(has_a_comp_return_delay_num);
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY=%0d (setting)", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_a_comp_return_delay_num), UVM_LOW);
             for(int dind=0; dind<has_a_comp_return_delay_qsize; dind++) begin
               has_a_comp_return_delay_num=$urandom_range(has_a_comp_return_delay_max, has_a_comp_return_delay_min);
               pp_cq_seq.a_comp_return_delay_q.push_back(has_a_comp_return_delay_max);
               pp_cq_seq.a_comp_return_delay_q.push_back(has_a_comp_return_delay_min);
               pp_cq_seq.a_comp_return_delay_q.push_back(has_a_comp_return_delay_num);
               uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY=%0d (setting) - pp_cq_seq.a_comp_return_delay_q.size=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_a_comp_return_delay_num, pp_cq_seq.a_comp_return_delay_q.size()), UVM_LOW);
             end 
        end 
    

        //----------------------------------
        //--tok return controls
        //----------------------------------
        has_tok_return_delay_mode_in=0;
        $value$plusargs("has_tok_return_delay_mode=%d",has_tok_return_delay_mode_in);
        if($value$plusargs({$psprintf("%s_PP%0d_TOK_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, tok_return_delay_mode)) begin
             pp_cq_seq.tok_return_delay_mode = tok_return_delay_mode;
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOK_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, tok_return_delay_mode), UVM_LOW);
        end else begin
             pp_cq_seq.tok_return_delay_mode = has_tok_return_delay_mode_in;
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOK_RETURN_DELAY_MODE=%0d (setting)", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_tok_return_delay_mode_in), UVM_LOW);
        end 
    
        has_tok_return_delay_qsize=0;
        $value$plusargs("has_tok_return_delay_qsize=%d",has_tok_return_delay_qsize);

        has_tok_return_delay_min=0;
        $value$plusargs("has_tok_return_delay_min=%d",has_tok_return_delay_min);
        has_tok_return_delay_max=0;
        $value$plusargs("has_tok_return_delay_max=%d",has_tok_return_delay_max);
        has_tok_return_delay_num=$urandom_range(has_tok_return_delay_max, has_tok_return_delay_min);
        if($value$plusargs({$psprintf("%s_PP%0d_TOK_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, tok_return_delay)) begin
             pp_cq_seq.tok_return_delay_q.push_back(tok_return_delay);
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOK_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, tok_return_delay), UVM_LOW);
        end else if(has_tok_return_delay_num>0) begin
             pp_cq_seq.tok_return_delay_q.push_back(has_tok_return_delay_num);
             uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOK_RETURN_DELAY=%0d (setting)", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_tok_return_delay_num), UVM_LOW);
             for(int dind=0; dind<has_tok_return_delay_qsize; dind++) begin
               has_tok_return_delay_num=$urandom_range(has_tok_return_delay_max, has_tok_return_delay_min);
               pp_cq_seq.tok_return_delay_q.push_back(has_tok_return_delay_max);
               pp_cq_seq.tok_return_delay_q.push_back(has_tok_return_delay_min);
               pp_cq_seq.tok_return_delay_q.push_back(has_tok_return_delay_num);
               uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY=%0d (setting) - pp_cq_seq.tok_return_delay_q.size=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, has_a_comp_return_delay_num, pp_cq_seq.tok_return_delay_q.size()), UVM_LOW);
             end 

        end 

    

        //----------------------------------
        //----------------------------------
	case (qtype_str)
	  "qdir": qtype = QDIR;
	  "quno": qtype = QUNO;
	  "qatm": qtype = QATM;
	  "qord": qtype = QORD;
	endcase

	case (renq_qtype_str)
	  "qdir": renq_qtype = QDIR;
	  "quno": renq_qtype = QUNO;
	  "qatm": renq_qtype = QATM;
	  "qord": renq_qtype = QORD;
	endcase

	for (int i = 0 ; i < queue_list_size ; i++) begin
          //---------------------------
          //-- num_hcw settings
          //---------------------------
	  //num_hcw_gen = has_num_hcw_gen;
	  //$value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);
	  //pp_cq_seq.queue_list[i].num_hcw                   = (enq_flow_in) ? num_hcw_gen : 0;

          if(hqmproc_enqctrl_sel_mode_in == 5) begin
             //---------------------------
             //-- when hqmproc_enqctrl_sel_mode=5, it's doing unexpected CIAL.int_occ test, ENQ num has to be cq_threshold, and BAT has to be cq_threshold
             //---------------------------
             if (is_ldb) begin
                num_hcw_gen = has_num_hcw_gen * i_hqm_cfg.ldb_pp_cq_cfg[pp_cq_seq.pp_cq_num].cq_depth_intr_thresh;
             end else begin
                num_hcw_gen = has_num_hcw_gen * i_hqm_cfg.dir_pp_cq_cfg[pp_cq_seq.pp_cq_num].cq_depth_intr_thresh;
             end 
	     $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);
	     pp_cq_seq.queue_list[i].num_hcw                   = (enq_flow_in) ? num_hcw_gen : 0;
          end else begin
	     num_hcw_gen = has_num_hcw_gen;
	     $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, num_hcw_gen);
	     pp_cq_seq.queue_list[i].num_hcw                   = (enq_flow_in) ? num_hcw_gen : 0;

          end 

          illegal_num_hcw_gen=0;
	  $value$plusargs({$psprintf("%s_PP%0d_Q%0d_ILLEGAL_NUM_HCW",pp_cq_prefix,pp_cq_seq.pp_cq_num,i),"=%d"}, illegal_num_hcw_gen);
	  pp_cq_seq.queue_list[i].illegal_num_hcw           = (enq_flow_in) ? illegal_num_hcw_gen : 0;

          uvm_report_info(get_full_name(), $psprintf("Starting PP/CQ processing: %s_PP%0d_NUM_HCW=%0d hqmproc_enqctrl_sel_mode_in=%0d has_num_hcw_gen=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, num_hcw_gen, hqmproc_enqctrl_sel_mode_in, has_num_hcw_gen), UVM_LOW);
          uvm_report_info(get_full_name(), $psprintf("Starting PP/CQ processing: %s_PP%0d_ILLEGAL_NUM_HCW=%0d illegal_hcw_prob=%0d, illegal_hcw_burst_len=%0d, illegal_hcw_type=%0s (setting)", pp_cq_prefix, pp_cq_seq.pp_cq_num, illegal_num_hcw_gen, illegal_hcw_prob, illegal_hcw_burst_len, illegal_hcw_type), UVM_LOW);


	  //if (qtype == QORD) begin
          //  pp_cq_seq.queue_list[i].qid                       = (i == 0) ? qid : renq_qid;
          //  pp_cq_seq.queue_list[i].qtype                     = (i == 0) ? qtype : renq_qtype;
          //  pp_cq_seq.queue_list[i].comp_flow                 = (i == 0) ? 0 : 1;
          //  pp_cq_seq.queue_list[i].cq_token_return_flow      = cq_tok_flow_in;
	  //end else begin
            pp_cq_seq.queue_list[i].qid                       = qid; 
            pp_cq_seq.queue_list[i].qtype                     = qtype;
            pp_cq_seq.renq_qid                                = renq_qid; 
            pp_cq_seq.renq_qtype                              = renq_qtype;
            pp_cq_seq.renq_qpri                               = renq_qpri;
            pp_cq_seq.renq_lockid                             = renq_lockid;
            pp_cq_seq.queue_list[i].comp_flow                 = comp_flow_in;
            pp_cq_seq.queue_list[i].cq_token_return_flow      = cq_tok_flow_in;
	  //end 

          if(hqmproc_ingerrinj_ooc_ctrl_in > 0)
             pp_cq_seq.queue_list[i].illegal_credit_prob       = (i == 0) ?  hqmproc_ingerrinj_ooc_rate_in : 0;
          else 
             pp_cq_seq.queue_list[i].illegal_credit_prob       = 0;

	  pp_cq_seq.queue_list[i].qpri_weight[0]            = hcw_qpri_weight0;
	  pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_min_in; //hcw_delay_in * queue_list_size;
	  pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max_in; //hcw_delay_in * queue_list_size;
	  pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
	  pp_cq_seq.queue_list[i].lock_id                   = lock_id;
	  pp_cq_seq.queue_list[i].illegal_hcw_burst_len     = (i == 0) ? illegal_hcw_burst_len : 0;
	  pp_cq_seq.queue_list[i].illegal_hcw_prob          = (i == 0) ? illegal_hcw_prob : 0;

          //if ($test$plusargs("HQMPROC_HCW_QE_DIST_PRI")) begin
              uvm_report_info(get_full_name(), $psprintf("Starting PP/CQ processing: QE priority dist_prob:: hcw_qpri_weight0=%0d hcw_qpri_weight1=%0d hcw_qpri_weight2=%0d hcw_qpri_weight3=%0d hcw_qpri_weight4=%0d hcw_qpri_weight5=%0d hcw_qpri_weight6=%0d hcw_qpri_weight7=%0d", hcw_qpri_weight0, hcw_qpri_weight1, hcw_qpri_weight2, hcw_qpri_weight3, hcw_qpri_weight4, hcw_qpri_weight5, hcw_qpri_weight6, hcw_qpri_weight7), UVM_LOW);
              pp_cq_seq.queue_list[i].qpri_weight[0] = hcw_qpri_weight0;
              pp_cq_seq.queue_list[i].qpri_weight[1] = hcw_qpri_weight1;
              pp_cq_seq.queue_list[i].qpri_weight[2] = hcw_qpri_weight2;
              pp_cq_seq.queue_list[i].qpri_weight[3] = hcw_qpri_weight3;
              pp_cq_seq.queue_list[i].qpri_weight[4] = hcw_qpri_weight4;
              pp_cq_seq.queue_list[i].qpri_weight[5] = hcw_qpri_weight5;
              pp_cq_seq.queue_list[i].qpri_weight[6] = hcw_qpri_weight6;
              pp_cq_seq.queue_list[i].qpri_weight[7] = hcw_qpri_weight7;
          //end 

	  if (pp_cq_seq.queue_list[i].illegal_hcw_prob > 0) begin
            pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::RAND_ILLEGAL;
	  end else if (pp_cq_seq.queue_list[i].illegal_hcw_burst_len > 0) begin
            pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::BURST_ILLEGAL;
	  end else begin
            pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::NO_ILLEGAL;
	  end 

	  pp_cq_seq.queue_list[i].illegal_hcw_type_q.push_back(illegal_hcw_type);
	end 

	finish_item(pp_cq_seq);
    	
    end //if(pp_cq_enable
    	
  endtask:start_pp_cq_hqmprocseq

//-----------------------------------
//-- hqmproc_trf_eot_check
//-----------------------------------
virtual task hqmproc_trf_eot_check();
   int total_enq_count, total_tok_count, total_cmp_count, total_sch_count;  

   int tot_rtn_ldb_tok_num, tot_rtn_dir_tok_num, tot_rtn_ldb_cmp_num, tot_rtn_tok_num;
   int tot_enq_atm_num, tot_enq_uno_num, tot_enq_ord_num, tot_enq_dir_num, tot_enq_ldb_num, tot_enq_num;
   int tot_sch_atm_num, tot_sch_uno_num, tot_sch_ord_num, tot_sch_dir_num, tot_sch_ldb_num, tot_sch_num;
   int tot_arm_num, tot_int_num;
   int enq_ldb_num[hqm_pkg::NUM_LDB_CQ], enq_dir_num[hqm_pkg::NUM_DIR_CQ];
   int dir_int_count[hqm_pkg::NUM_DIR_CQ], dir_cq_thres[hqm_pkg::NUM_DIR_CQ];
   int ldb_int_count[hqm_pkg::NUM_LDB_CQ], ldb_cq_thres[hqm_pkg::NUM_LDB_CQ];
 
    for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
        dir_int_count[cq] = i_hqm_cfg.i_hqm_pp_cq_status.dir_int_count[cq]; 
        enq_dir_num[cq]   = i_hqm_cfg.i_hqm_pp_cq_status.enq_dir_num[cq]; 
        dir_cq_thres[cq]  = i_hqm_cfg.dir_pp_cq_cfg[cq].cq_depth_intr_thresh;
        if(enq_dir_num[cq]>0) begin
           uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
           if($test$plusargs("HQM_CIAL_INT_ARM_CK_none") && !$test$plusargs("has_agitate_on")) begin
               //-- unexpected cial.intr_occ tests can't run with agitations
               if(dir_int_count[cq] == 0) 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d=0 dir_cq_thres[%0d]=%0d match with +HQM_CIAL_INT_ARM_CK_none", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
               else 
                  uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d>0 dir_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_none", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);

           end else if($test$plusargs("HQM_CIAL_INT_ARM_CK_1")) begin
               if( (enq_dir_num[cq] / (dir_cq_thres[cq]+1)) == dir_int_count[cq]) begin
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d match", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
               end else begin 
                  if(has_cqirq_mask_enable ==1  && (cq >= hqmproc_cqirqmask_dirppnum_min && cq <hqmproc_cqirqmask_dirppnum_max) ) begin
                     uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_1 when has_cqirq_mask_enable=1", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
                  end else begin
                     uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_1", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
                  end 
               end 
           end else if($test$plusargs("HQM_CIAL_INT_ARM_CK_2")) begin
               //-- expect twice number of intr
               if( (enq_dir_num[cq] / (dir_cq_thres[cq]+1)) * 2 == dir_int_count[cq]) 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d two times match", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
               else 
                  uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d not two times match +HQM_CIAL_INT_ARM_CK_2", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
           end else if($test$plusargs("HQM_CIAL_INT_ARM_CK_3")) begin
               //--+HQM_CIAL_INT_ARM_CK_3 enq number N-1, the last cq.intr is cq.timer
               if( ((enq_dir_num[cq]+1) / (dir_cq_thres[cq]+1)) == dir_int_count[cq]) 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d match", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
               else 
                  uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_dir_num[%0d]=%0d dir_int_count[%0d]=%0d dir_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_3", cq, enq_dir_num[cq], cq, dir_int_count[cq], cq, dir_cq_thres[cq]), UVM_LOW);
           end 
        end 
    end 

    for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
        ldb_int_count[cq] = i_hqm_cfg.i_hqm_pp_cq_status.ldb_int_count[cq]; 
        enq_ldb_num[cq]   = i_hqm_cfg.i_hqm_pp_cq_status.enq_ldb_num[cq+128]; 
        ldb_cq_thres[cq]  = i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_depth_intr_thresh;
        if(enq_ldb_num[cq]>0) begin
           uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
           if($test$plusargs("HQM_CIAL_INT_ARM_CK_none") && !$test$plusargs("has_agitate_on")) begin
               //-- unexpected cial.intr_occ tests can't run with agitations
               if(ldb_int_count[cq] == 0) 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d=0 ldb_cq_thres[%0d]=%0d match +HQM_CIAL_INT_ARM_CK_none", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
               else 
                  uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d>0 ldb_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_none", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);

           end else if($test$plusargs("HQM_CIAL_INT_ARM_CK_1")) begin
               if( (enq_ldb_num[cq] / (ldb_cq_thres[cq]+1)) == ldb_int_count[cq]) begin 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d match +HQM_CIAL_INT_ARM_CK_1", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
               end else begin 
                  if(has_cqirq_mask_enable ==1  && (cq >= hqmproc_cqirqmask_ldbppnum_min && cq <hqmproc_cqirqmask_ldbppnum_max) ) begin
                     uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_1 when has_cqirq_mask_enable=1 ", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
                  end else begin
                     uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_1", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
                  end 
               end 
           end else if($test$plusargs("HQM_CIAL_INT_ARM_CK_2")) begin
               //-- expect twice number of intr
               if( (enq_ldb_num[cq] / (ldb_cq_thres[cq]+1)) * 2 == ldb_int_count[cq]) 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d two times match +HQM_CIAL_INT_ARM_CK_2", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
               else 
                  uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d not two times match +HQM_CIAL_INT_ARM_CK_2", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
           end else if($test$plusargs("HQM_CIAL_INT_ARM_CK_3")) begin
               //--+HQM_CIAL_INT_ARM_CK_3 enq number N-1, the last cq.intr is cq.timer
               if( ((enq_ldb_num[cq]+1) / (ldb_cq_thres[cq]+1)) == ldb_int_count[cq]) 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d match +HQM_CIAL_INT_ARM_CK_3", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
               else 
                  uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d not match +HQM_CIAL_INT_ARM_CK_3", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
           end else if($test$plusargs("HQM_CIAL_INT_ARM_CK_4")) begin
               if(ldb_int_count[cq] > 0) 
                  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d int_count > zero, +HQM_CIAL_INT_ARM_CK_4", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
               else
                  uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL:: enq_ldb_num[%0d]=%0d ldb_int_count[%0d]=%0d ldb_cq_thres[%0d]=%0d int_count is zero, +HQM_CIAL_INT_ARM_CK_4", cq, enq_ldb_num[cq], cq, ldb_int_count[cq], cq, ldb_cq_thres[cq]), UVM_LOW);
           end 
        end 
    end 

    total_enq_count = i_hqm_cfg.i_hqm_pp_cq_status.total_enq_count; 
    total_tok_count = i_hqm_cfg.i_hqm_pp_cq_status.total_tok_count; 
    total_cmp_count = i_hqm_cfg.i_hqm_pp_cq_status.total_cmp_count; 
    total_sch_count = i_hqm_cfg.i_hqm_pp_cq_status.total_sch_count; 

    tot_enq_ldb_num = i_hqm_cfg.i_hqm_pp_cq_status.tot_enq_ldb_num; 
    tot_enq_dir_num = i_hqm_cfg.i_hqm_pp_cq_status.tot_enq_dir_num; 
    tot_sch_ldb_num = i_hqm_cfg.i_hqm_pp_cq_status.tot_sch_ldb_num; 
    tot_sch_dir_num = i_hqm_cfg.i_hqm_pp_cq_status.tot_sch_dir_num; 

    tot_arm_num     = i_hqm_cfg.i_hqm_pp_cq_status.tot_arm_num;
    tot_int_num     = i_hqm_cfg.i_hqm_pp_cq_status.tot_int_num;

    //----------------------------------------------
    if(tot_enq_ldb_num != tot_sch_ldb_num) begin
        uvm_report_warning("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_ldb_num=%0d tot_sch_ldb_num=%0d not match", tot_enq_ldb_num, tot_sch_ldb_num), UVM_LOW);
    end 
    if(tot_enq_dir_num != tot_sch_dir_num) begin
        uvm_report_warning("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_dir_num=%0d tot_sch_dir_num=%0d not match", tot_enq_dir_num, tot_sch_dir_num), UVM_LOW);
    end 

    if(total_enq_count != total_sch_count) begin
        uvm_report_warning("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_enq_count=%0d total_sch_count=%0d not match", total_enq_count, total_sch_count), UVM_LOW);
    end 
    if(total_tok_count != total_sch_count) begin
        uvm_report_warning("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_tok_count=%0d total_sch_count=%0d not match", total_tok_count, total_sch_count), UVM_LOW);
    end 
    if(total_cmp_count != tot_sch_ldb_num) begin
        uvm_report_warning("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_cmp_count=%0d tot_sch_ldb_num=%0d not match", total_cmp_count, tot_sch_ldb_num), UVM_LOW);
    end 

    //----------------------------------------------
    if($test$plusargs("HQM_CIAL_INT_ARM_CK_0")) begin 
       if(tot_int_num == tot_arm_num) 
          uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL::tot_arm_num=%0d tot_int_num=%0d matched", tot_arm_num, tot_int_num), UVM_LOW);
       else 
          uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL::tot_arm_num=%0d tot_int_num=%0d mismatched +HQM_CIAL_INT_ARM_CK_0", tot_arm_num, tot_int_num), UVM_LOW);

       if(total_enq_count == tot_arm_num) 
          uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL::tot_arm_num=%0d total_enq_count=%0d matched", tot_arm_num, total_enq_count), UVM_LOW);
       else 
          uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTCIAL::tot_arm_num=%0d total_enq_count=%0d mismatched +HQM_CIAL_INT_ARM_CK_0", tot_arm_num, total_enq_count), UVM_LOW);
    end 

endtask: hqmproc_trf_eot_check


//-----------------------------------
//-- hqmproc_cqirq_mask_unmask_task
//-- call task cfg_chp_cqirq_mask_unmask_task(int loop, int is_ldb, int cq_int_mask, int cq_int_interactive, int wait_num, int cq_num_min, int cq_num_max);
//-----------------------------------
virtual task hqmproc_cqirq_mask_unmask_task(int is_ldb, int cq_num); 

//    for(int ploop=0; ploop<cqirq_mask_unmask_loop; ploop++) begin   
//         if(has_cqirq_mask_enable==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
//             `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_mask_unmask_task_S0: Start mask flow_%0d round", ploop),UVM_LOW)	
//              if(ploop>0) wait_idle(has_cqirq_mask_waitnum);
//             `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_mask_unmask_task_S1: start is_ldb=%0d CQ[%0d] mask flow_%0d round",is_ldb,  cq_num, ploop),UVM_LOW)    
//              cfg_chp_cqirq_mask_unmask_task(cqirq_mask_unmask_loop, is_ldb, 1, 1, has_cqirq_mask_loopwaitnum, cq_num, cq_num+1); //CQ IRQ Mask setting 
//             `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_mask_unmask_task_S2: done is_ldb=%0d CQ[%0d] mask flow_%0d round",is_ldb,  cq_num, ploop),UVM_LOW)
//         end 
//
//         if(has_cqirq_unmask_enable==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
//             `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_mask_unmask_task_S0: Start unmask flow_%0d round", ploop),UVM_LOW)	
//              wait_idle(has_cqirq_mask_waitnum);
//             `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_mask_unmask_task_S1: start is_ldb=%0d CQ[%0d] unmask flow_%0d round",is_ldb,  cq_num, ploop),UVM_LOW)    
//              cfg_chp_cqirq_mask_unmask_task(cqirq_mask_unmask_loop, is_ldb, 0, 1, has_cqirq_mask_loopwaitnum, cq_num, cq_num+1); //CQ IRQ UnMask setting 
//             `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_mask_unmask_task_S2: done is_ldb=%0d CQ[%0d] unmask flow_%0d round",is_ldb,  cq_num, ploop),UVM_LOW)
//         end 
//    end //--for(ploop		           
endtask:hqmproc_cqirq_mask_unmask_task 

    		   
		   

                      

		   		   
//-----------------------------------
//-- hqmproc_cqirq_maskunmask_parallel_tasks
//-- call task cfg_chp_cqirq_mask_unmask_task(int loop, int is_ldb, int cq_int_mask, int cq_int_interactive, int wait_num, int cq_num_min, int cq_num_max);
//-----------------------------------
`ifdef IP_TYP_TE
virtual task hqmproc_cqirq_maskunmask_parallel_tasks(int is_ldb, int cq_num);
    int  cq_num;
    bit  cq_int_mask_val;
    
    for(int ploop=0; ploop<cqirq_mask_unmask_loop; ploop++) begin 
    
       uvm_report_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_0__is_ldb=%0d cq_num=%0d ploop=%0d in %0d when hqm_cfg.hqmproc_trfctrl=%0d", is_ldb, cq_num, ploop, cqirq_mask_unmask_loop,i_hqm_cfg.hqmproc_trfctrl), UVM_MEDIUM);
             

       if(has_cqirq_mask_paral_ena==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
          if(ploop==0) begin
                `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_1__is_ldb=%0d cq_num=%0d:: Mask_flow skip cfg_chp_cqirq_mask_unmask_task round=%0d", is_ldb, cq_num,ploop),UVM_LOW)    
                 wait_idle(has_cqirq_mask_waitnum*5);
          end else begin
                `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_1__is_ldb=%0d cq_num=%0d:: Mask_flow wait cfg_chp_cqirq_mask_unmask_task round=%0d", is_ldb, cq_num,ploop),UVM_LOW)    
              
                 wait_idle(has_cqirq_mask_waitnum);
                `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_2__is_ldb=%0d cq_num=%0d:: Mask_flow start cfg_chp_cqirq_mask_unmask_task round=%0d", is_ldb, cq_num,ploop),UVM_LOW)    
                 cfg_chp_cqirq_mask_unmask_task(1, is_ldb, 1, 1, has_cqirq_mask_loopwaitnum, cq_num, cq_num+1); //CQ IRQ Mask setting
          end 
         `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_3__is_ldb=%0d cq_num=%0d:: Mask_flow Done cfg_chp_cqirq_mask_unmask_task round=%0d", is_ldb, cq_num,ploop),UVM_LOW)
       end else begin
          if(i_hqm_cfg.hqmproc_trfctrl==2) break;
       end 

       if(has_cqirq_unmask_paral_ena==1 && i_hqm_cfg.hqmproc_trfctrl!=2) begin
          `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_4__is_ldb=%0d cq_num=%0d:: Unmask_flow wait cfg_chp_cqirq_mask_unmask_task round=%0d", is_ldb, cq_num,ploop),UVM_LOW)    
           wait_idle(has_cqirq_mask_waitnum);
          `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_5__is_ldb=%0d cq_num=%0d:: Unmask_flow start cfg_chp_cqirq_mask_unmask_task round=%0d", is_ldb, cq_num,ploop),UVM_LOW)    
           cfg_chp_cqirq_mask_unmask_task(1, is_ldb, 0, 1, has_cqirq_mask_loopwaitnum, cq_num, cq_num+1); //CQ IRQ UnMask setting
           
          `uvm_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_6__is_ldb=%0d cq_num=%0d:: Unmask_flow done cfg_chp_cqirq_mask_unmask_task round=%0d", is_ldb, cq_num,ploop),UVM_LOW) 
       end else begin
          if(i_hqm_cfg.hqmproc_trfctrl==2) break;
       end        
       uvm_report_info("HCW_ENQTRF_HCW_SEQ",$psprintf("hqmproc_cqirq_maskunmask_parallel_tasks_7__is_ldb=%0d cq_num=%0d ploop=%0d in %0d done when hqm_cfg.hqmproc_trfctrl=%0d", is_ldb, cq_num, ploop, cqirq_mask_unmask_loop,i_hqm_cfg.hqmproc_trfctrl), UVM_MEDIUM);
    end //--for(ploop
endtask: hqmproc_cqirq_maskunmask_parallel_tasks
`endif


`ifndef IP_TYP_TE
//-------------------------
// wait_idle
//------------------------- 
virtual task wait_idle(int wait_cycles);
      for(int i=0; i<wait_cycles; i++) @(slu_tb_env::sys_clk_r);
endtask:wait_idle 
`endif

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
 `ifdef IP_TYP_TE
`include "hqmproc_tb_vasrst_tasks.svh"
`include "hqmproc_tb_cfg_init_nseq4.svh"
`include "hqmproc_tb_intr_tasks.svh"
`endif

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
			      		

endclass
