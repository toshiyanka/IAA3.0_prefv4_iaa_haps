`include "hqm_map_ral_env.svh"

class hqm_ral_env extends hqm_map_ral_env;
  `uvm_component_utils(hqm_ral_env)
  
  int              has_ral_bdf_program;
  bit [7:0]        has_ral_override_program;

  function new( string n="hqm_ral_env", uvm_component p = null, string hdl_path = "");
    super.new(n,p,hdl_path);
  endfunction

  function void end_of_elaboration();
    sla_ral_reg         reglist[$];
    sla_ral_field       regfields[$];
    sla_ral_field       field_q[$];
    bit [7:0]           hqm_bus;
    bit [7:0]           func_base;
    logic               hqm_is_reg_ep_arg;
    int                 fid_val,fid_val1;   

    super.end_of_elaboration();

    func_base = 8'h00; // RCIPE/EP Base function number

    if ($test$plusargs("hqm_ral_rand_bus_id")) begin
      hqm_bus = $urandom_range(255,0);
    end else begin
      hqm_bus = 8'h00;
      $value$plusargs("hqm_ral_bus_id=%d",hqm_bus);
    end
    `uvm_info(get_full_name(),$psprintf("HQM_TB hqm_ral_env - Bus ID 0x%02x Func Base 0x%02x",hqm_bus,func_base),OVM_LOW)

    //-- program set_bdf or not
    get_config_int("hqm_ral_bdf_program", has_ral_bdf_program);
    `uvm_info(get_full_name(),$psprintf("HQM_TB hqm_ral_env - has_ral_bdf_program=%0d", has_ral_bdf_program),OVM_LOW)
    $value$plusargs("HQM_RAL_SET_BDF=%d",has_ral_bdf_program);
    `uvm_info(get_full_name(),$psprintf("HQM_TB hqm_ral_env - has_ral_bdf_program=%0d (2nd by +HQM_RAL_SET_BDF)", has_ral_bdf_program),OVM_LOW)

    //-- program override_program or not
    //--has_ral_override_program[0]=1 : turn on set_path
    get_config_int("hqm_ral_override_program", has_ral_override_program);
    `uvm_info(get_full_name(),$psprintf("HQM_TB hqm_ral_env - has_ral_override_program=%0d", has_ral_override_program),OVM_LOW)
    $value$plusargs("HQM_RAL_OVERRIDE=%d",has_ral_override_program);
    `uvm_info(get_full_name(),$psprintf("HQM_TB hqm_ral_env - has_ral_override_program=%0d (2nd setting) (1: turn on set_path)", has_ral_override_program),OVM_LOW)

    //----------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
////    if(has_ral_override_program[0])  
////      `include "hqm_ral_env_valrtlsignal.svh"

    //--------------------
////    if(has_ral_override_program[0])  begin
////       foreach (hqm_system_csr.HQM_DIR_PP2VDEV[i]) begin
////         hqm_system_csr.HQM_DIR_PP2VDEV[i].VDEV.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_csr_wrap.i_hqm_system_csr.HQM_DIR_PP2VDEV[%0d].VDEV",i)});
////         hqm_system_csr.HQM_DIR_PP2VDEV[i].VDEV.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_system_csr.HQM_LDB_PP2VDEV[i]) begin
////         hqm_system_csr.HQM_LDB_PP2VDEV[i].VDEV.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_csr_wrap.i_hqm_system_csr.HQM_LDB_PP2VDEV[%0d].VDEV",i)});
////         hqm_system_csr.HQM_LDB_PP2VDEV[i].VDEV.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_system_csr.DIR_QID_V[i]) begin
////         hqm_system_csr.DIR_QID_V[i].QID_V.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_ingress.lut_dir_qid_v_mem[%0d][%0d]",i/32,i%32)});
////         hqm_system_csr.DIR_QID_V[i].QID_V.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_system_csr.LDB_QID_V[i]) begin
////         hqm_system_csr.LDB_QID_V[i].QID_V.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_ingress.lut_ldb_qid_v_mem[%0d][%0d]",i/16,i%16)});
////         hqm_system_csr.LDB_QID_V[i].QID_V.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_system_csr.DIR_QID_ITS[i]) begin
////         hqm_system_csr.DIR_QID_ITS[i].QID_ITS.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_ingress.lut_dir_qid_its_mem[%0d][%0d]",i/32,i%32)});
////         hqm_system_csr.DIR_QID_ITS[i].QID_ITS.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_system_csr.LDB_QID_ITS[i]) begin
////         hqm_system_csr.LDB_QID_ITS[i].QID_ITS.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_ingress.lut_ldb_qid_its_mem[%0d][%0d]",i/16,i%16)});
////         hqm_system_csr.LDB_QID_ITS[i].QID_ITS.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_system_csr.LDB_PP_V[i]) begin
////         hqm_system_csr.LDB_PP_V[i].PP_V.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_ingress.lut_ldb_pp_v_mem[%0d][%0d]",i/32,i%32)});
////         hqm_system_csr.LDB_PP_V[i].PP_V.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_system_csr.LDB_QID_CFG_V[i]) begin
////         hqm_system_csr.LDB_QID_CFG_V[i].SN_CFG_V.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_ingress.lut_ldb_qid_cfg_v_mem[%0d][%0d]",i/16,2 * (i%16))});
////         hqm_system_csr.LDB_QID_CFG_V[i].SN_CFG_V.set_logical_path("HQMID");
////   
////         hqm_system_csr.LDB_QID_CFG_V[i].FID_CFG_V.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_ingress.lut_ldb_qid_cfg_v_mem[%0d][%0d]",i/16,(2 * (i%16)) + 1)});
////         hqm_system_csr.LDB_QID_CFG_V[i].FID_CFG_V.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_msix_mem.VECTOR_CTRL[i]) begin
////         hqm_msix_mem.VECTOR_CTRL[i].VEC_MASK.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.msix_tbl_mask_q[%0d][%0d]",i/8,i%8)});
////         hqm_msix_mem.VECTOR_CTRL[i].VEC_MASK.set_logical_path("HQMID");
////       end
////   
////       foreach (hqm_msix_mem.HQM_MSIX_PBA[i]) begin
////         if (i == 2) begin
////           hqm_msix_mem.HQM_MSIX_PBA[i].PENDING.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.msix_pba_q[%0d:%0d]",(i*32),i*32)});
////           hqm_msix_mem.HQM_MSIX_PBA[i].PENDING.set_logical_path("HQMID");
////         end else begin
////           hqm_msix_mem.HQM_MSIX_PBA[i].PENDING.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_alarm.msix_pba_q[%0d:%0d]",(i*32)+31,i*32)});
////           hqm_msix_mem.HQM_MSIX_PBA[i].PENDING.set_logical_path("HQMID");
////         end
////       end
////   
////       foreach (reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0[i]) begin
////         reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0[i].SN_ACTIVE.set_paths({$psprintf("i_hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[0].i_hqm_aw_sn_order.pipe_health_sn_state_f[%0d:%0d]",(i*32)+31,i*32)});
////         reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0[i].SN_ACTIVE.set_logical_path("HQMID");
////       end
////   
////       foreach (reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1[i]) begin
////         reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1[i].SN_ACTIVE.set_paths({$psprintf("i_hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.FOR_HQM_SN_GRP[1].i_hqm_aw_sn_order.pipe_health_sn_state_f[%0d:%0d]",(i*32)+31,i*32)});
////         reorder_pipe.CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1[i].SN_ACTIVE.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_DIR_CQ_WD_ENB[i]) begin
////         credit_hist_pipe.CFG_DIR_CQ_WD_ENB[i].WD_ENABLE.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_dir_cq_wd_enb.internal_f[%0d]",i)});
////         credit_hist_pipe.CFG_DIR_CQ_WD_ENB[i].WD_ENABLE.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_LDB_CQ_WD_ENB[i]) begin
////         credit_hist_pipe.CFG_LDB_CQ_WD_ENB[i].WD_ENABLE.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_ldb_cq_wd_enb.internal_f[%0d]",i)});
////         credit_hist_pipe.CFG_LDB_CQ_WD_ENB[i].WD_ENABLE.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_DIR_CQ2VAS[i]) begin
////         credit_hist_pipe.CFG_DIR_CQ2VAS[i].CQ2VAS.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_dir_cq2vas.internal_f[%0d:%0d]",(6*i)+4,6*i)});
////         credit_hist_pipe.CFG_DIR_CQ2VAS[i].CQ2VAS.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_LDB_CQ2VAS[i]) begin
////         credit_hist_pipe.CFG_LDB_CQ2VAS[i].CQ2VAS.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_ldb_cq2vas.internal_f[%0d:%0d]",(6*i)+4,6*i)});
////         credit_hist_pipe.CFG_LDB_CQ2VAS[i].CQ2VAS.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_DIR_CQ_IRQ_PENDING[i]) begin
////         credit_hist_pipe.CFG_DIR_CQ_IRQ_PENDING[i].IRQ_PENDING.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_dir_cq_irq_pending.internal_f[%0d]",i)});
////         credit_hist_pipe.CFG_DIR_CQ_IRQ_PENDING[i].IRQ_PENDING.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_DIR_CQ_INT_MASK[i]) begin
////         credit_hist_pipe.CFG_DIR_CQ_INT_MASK[i].INT_MASK.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_dir_cq_int_mask.internal_f[%0d]",i)});
////         credit_hist_pipe.CFG_DIR_CQ_INT_MASK[i].INT_MASK.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_DIR_CQ_INT_ENB[i]) begin
////         credit_hist_pipe.CFG_DIR_CQ_INT_ENB[i].EN_TIM.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_dir_cq_int_enb.internal_f[%0d]",(2*i))});
////         credit_hist_pipe.CFG_DIR_CQ_INT_ENB[i].EN_TIM.set_logical_path("HQMID");
////         credit_hist_pipe.CFG_DIR_CQ_INT_ENB[i].EN_DEPTH.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_dir_cq_int_enb.internal_f[%0d]",(2*i)+1)});
////         credit_hist_pipe.CFG_DIR_CQ_INT_ENB[i].EN_DEPTH.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_LDB_CQ_IRQ_PENDING[i]) begin
////         credit_hist_pipe.CFG_LDB_CQ_IRQ_PENDING[i].IRQ_PENDING.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_ldb_cq_irq_pending.internal_f[%0d]",i)});
////         credit_hist_pipe.CFG_LDB_CQ_IRQ_PENDING[i].IRQ_PENDING.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_LDB_CQ_INT_MASK[i]) begin
////         credit_hist_pipe.CFG_LDB_CQ_INT_MASK[i].INT_MASK.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_ldb_cq_int_mask.internal_f[%0d]",i)});
////         credit_hist_pipe.CFG_LDB_CQ_INT_MASK[i].INT_MASK.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_LDB_CQ_INT_ENB[i]) begin
////         credit_hist_pipe.CFG_LDB_CQ_INT_ENB[i].EN_TIM.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_ldb_cq_int_enb.internal_f[%0d]",(2*i))});
////         credit_hist_pipe.CFG_LDB_CQ_INT_ENB[i].EN_TIM.set_logical_path("HQMID");
////         credit_hist_pipe.CFG_LDB_CQ_INT_ENB[i].EN_DEPTH.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_ldb_cq_int_enb.internal_f[%0d]",(2*i)+1)});
////         credit_hist_pipe.CFG_LDB_CQ_INT_ENB[i].EN_DEPTH.set_logical_path("HQMID");
////       end
////   
////       foreach (list_sel_pipe.CFG_CQ_DIR_DISABLE[i]) begin
////         list_sel_pipe.CFG_CQ_DIR_DISABLE[i].DISABLED.set_paths({$psprintf("i_hqm_list_sel_pipe_core.i_hqm_lsp_pipe_register_pfcsr.i_hqm_lsp_target_cfg_cq_dir_disable.internal_f[%0d]",i)});
////         list_sel_pipe.CFG_CQ_DIR_DISABLE[i].DISABLED.set_logical_path("HQMID");
////       end
////   
////       foreach (list_sel_pipe.CFG_CQ_LDB_DISABLE[i]) begin
////         list_sel_pipe.CFG_CQ_LDB_DISABLE[i].DISABLED.set_paths({$psprintf("i_hqm_list_sel_pipe_core.i_hqm_lsp_pipe_register_pfcsr.i_hqm_lsp_target_cfg_cq_ldb_disable.internal_f[%0d]",i)});
////         list_sel_pipe.CFG_CQ_LDB_DISABLE[i].DISABLED.set_logical_path("HQMID");
////       end
////   
////       foreach (aqed_pipe.CFG_AQED_QID_HID_WIDTH[i]) begin
////         aqed_pipe.CFG_AQED_QID_HID_WIDTH[i].COMPRESS_CODE.set_paths({$psprintf("i_hqm_aqed_pipe_core.i_hqm_aqed_pipe_register_pfcsr.i_hqm_aqed_target_cfg_aqed_qid_hid_width.internal_f[%0d:%0d]",(i*3)+2,i*3)});
////         aqed_pipe.CFG_AQED_QID_HID_WIDTH[i].COMPRESS_CODE.set_logical_path("HQMID");
////       end
////   
////       foreach (credit_hist_pipe.CFG_VAS_CREDIT_COUNT[i]) begin
////         credit_hist_pipe.CFG_VAS_CREDIT_COUNT[i].COUNT.set_paths({$psprintf("i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_register_pfcsr.i_hqm_chp_target_cfg_vas_credit_count.internal_f[%0d:%0d]",(i * 17) + 14,(i * 17))});
////         credit_hist_pipe.CFG_VAS_CREDIT_COUNT[i].COUNT.set_logical_path("HQMID");
////       end
////   
////       //--------------------
////   
////       foreach (hqm_system_csr.DIR_CQ_FMT[i]) begin
////         hqm_system_csr.DIR_CQ_FMT[i].KEEP_PF_PPID.set_paths({$psprintf("i_hqm_system_core.i_hqm_system_egress.lut_dir_cq_fmt_mem[%0d][%0d]",i/32,i%32)});
////         hqm_system_csr.DIR_CQ_FMT[i].KEEP_PF_PPID.set_logical_path("HQMID");
////       end
////   
////    end //if(has_ral_override_program  

  endfunction



  virtual function slu_ral_addr_t get_addr_val(slu_ral_access_path_t access_path, sla_ral_reg r);
    `uvm_error(get_full_name(),"Should not be calling this routine")
  endfunction

  virtual function string get_log2phy_path(string logic_path, string filename, string unique_filename);

    `uvm_info(get_name(), $sformatf("logic_path %s  filename %s  unique %s ",logic_path, filename, unique_filename),OVM_HIGH);

    `uvm_fatal(get_name(), "Unexpected call to unimplemented get_log2phy_path() - testbench should define based on ral_type setting in slu_tb_env top level environment")

    return "Logical path not found";

  endfunction : get_log2phy_path

`ifdef IP_TYP_TE
  `include "hqm_ral_env_tasks.svh"
`endif //`ifdef IP_TYP_TE

endclass
