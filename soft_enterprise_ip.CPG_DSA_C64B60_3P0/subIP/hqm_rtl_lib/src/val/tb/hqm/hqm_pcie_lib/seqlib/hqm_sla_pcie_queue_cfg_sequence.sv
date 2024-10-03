`ifndef HQM_SLA_PCIE_Q_CFG_SEQUENCE_
`define HQM_SLA_PCIE_Q_CFG_SEQUENCE_

`include "hqm_pcie_common_defines.sv"

class hqm_sla_pcie_queue_cfg_sequence extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_queue_cfg_sequence,sla_sequencer)

  rand logic [$clog2(`HQM_LDB_QUEUES)-1:0]  qid  ;
  rand logic [$clog2(`HQM_LDB_POOLS)-1:0]  pool ;
  rand logic [$clog2(`HQM_NUM_VAS)-1:0]  vas_id ;

  rand logic [31:0] ord_qid_sn_map_val;
  rand logic [31:0] aqed_active_limit_val;
  rand logic [31:0] ldb_inflight_limit_val;                          
  rand logic [31:0] aqed_freelist_base_val;
  rand logic [31:0] aqed_freelist_limit_val;
  rand logic [31:0] aqed_freelist_push_ptr_val;
  rand logic [31:0] aqed_freelist_pop_ptr_val;
  rand logic [31:0] ldb_qid_v_val;
  rand logic [31:0] ldb_qid_cfg_v_val;
  rand logic [31:0] ldb_pool_enabled_val;
  rand logic [31:0] ldb_pool_credit_count_val;
  rand logic [31:0] ldb_pool_credit_limit;
  rand logic [31:0] qed_freelist_limit_val;
  rand logic [31:0] qed_freelist_base_val;
  rand logic [31:0] qed_freelist_push_ptr_val;
  rand logic [31:0] qed_freelist_pop_ptr_val;
  rand logic [31:0] vas_gen_val;
  rand logic [31:0] ldb_vasqid_v_val;


	///CREDIT QUANTA and LIMIT//
  rand logic [31:0] dir_qid_v_val;
  rand logic [31:0] dir_vasqid_v_val;
  rand logic [31:0] dir_pool_enabled_val;
  rand logic [31:0] dir_pool_credit_count_val;
  rand logic [31:0] dir_pool_credit_limit;

//No such thing for dir Qs  rand logic [31:0] dir_inflight_limit_val;                          
//No such thing for dir Qs    rand logic [31:0] dir_qid_cfg_v_val;

  rand logic [31:0] dir_pp_dir_min_credit_quanta_val;
  rand logic [31:0] dir_pp_ldb_min_credit_quanta_val;
  rand logic [31:0] dir_dir_pp2pool_val;
  rand logic [31:0] dir_ldb_pp2pool_val;
  rand logic [31:0] dir_pp_dir_credit_count_val;
  rand logic [31:0] dir_pp_dir_credit_hwm_val;
  rand logic [31:0] dir_pp_dir_credit_lwm_val;
  rand logic [31:0] dir_pp_ldb_credit_count_val;
  rand logic [31:0] dir_pp_ldb_credit_hwm_val;
  rand logic [31:0] dir_pp_ldb_credit_lwm_val;
  rand logic [31:0] dir_pp_v_val;
  rand logic [31:0] dir_pp_addr_l_val;
  rand logic [31:0] dir_pp_addr_u_val;
  rand logic		pf_owns_pp_val;
  rand logic [3:0]	vf_no_owns_pp_val;
  rand logic [31:0] dir_pp2dirpool_val;
  rand logic [31:0] dir_pp2ldbpool_val;
  rand logic [31:0] dir_pp2vas_val;
  rand logic [31:0] dir_cq_token_depth_select_val;
  rand logic [31:0] cq_dir_token_depth_select_dsi_val;
  rand logic [31:0] cq_dir_disable_val;
  rand logic [31:0] dir_cq_int_depth_thrsh_val;
  rand logic [31:0] cfg_dir_cq_int_enb_val;
  rand logic [31:0] dir_cq_timer_threshold_val;
  rand logic [31:0] dir_cq_addr_l_val;
  rand logic [31:0] dir_cq_addr_u_val;
  rand logic		pf_owns_cq_val;
  rand logic [3:0]	vf_no_owns_cq_val;
  rand logic [1:0]  dir_cq_isr_en_val;
  rand logic [3:0]  dir_cq_isr_vf_idx_val;
  rand logic [5:0]  dir_cq_isr_vector_val;

  
//  rand logic [$clog2(`HQM_TOTAL_LDB_Q_PRI)-1:0]  pri  ;
//  rand string type ;

  constraint soft_qid_pri_type_c	{
	soft qid	  == 0;
	soft pool	  == 0;
	soft vas_id	  == 0;

	soft  ord_qid_sn_map_val		  == 0;
	soft  aqed_active_limit_val		  == 32'h_20;
	soft  ldb_inflight_limit_val	  == 32'h_0a;                          
	soft  aqed_freelist_base_val	  == 32'h_00;
	soft  aqed_freelist_limit_val	  == 32'h_1f;
	soft  aqed_freelist_push_ptr_val  == {1'b1,10'h_0};
	soft  aqed_freelist_pop_ptr_val	  == {1'b1,10'h_0};
	soft  ldb_qid_v_val				  == 32'h_1;
	soft  ldb_qid_cfg_v_val			  == 32'h_0;
	soft  ldb_pool_enabled_val		  == 32'h_1;
	soft  ldb_pool_credit_count_val	  == 32'h_400;
	soft  ldb_pool_credit_limit		  == 32'h_400;
	soft  qed_freelist_limit_val	  == 32'h_1ff;
	soft  qed_freelist_base_val		  == 32'h_0;
	soft  qed_freelist_push_ptr_val	  == {1'b1,15'h_0};
	soft  qed_freelist_pop_ptr_val	  == {1'b0,15'h_0};
	soft  vas_gen_val				  == 32'h_0;
	soft  ldb_vasqid_v_val			  == 32'h_0;

	soft  dir_qid_v_val				  == 32'h_1;
	soft  dir_vasqid_v_val			  == 32'h_1;
	soft  dir_pool_enabled_val		  == 32'h_1;
	soft  dir_pool_credit_count_val	  == 32'h_3fc;
	soft  dir_pool_credit_limit		  == 32'h_400;

	//No such thing for dir Qs  soft  dir_inflight_limit_val	  == 32'h_0a;                          
	//No such thing for dir Qs  soft  dir_qid_cfg_v_val			  == 32'h_0;

	///CREDIT QUANTA and LIMIT//
	soft dir_pp_dir_min_credit_quanta_val	== 32'h_100;
	soft dir_pp_ldb_min_credit_quanta_val	== 32'h_100;
	soft dir_dir_pp2pool_val				== 32'h_0;
	soft dir_ldb_pp2pool_val				== 32'h_0;
	soft dir_pp_dir_credit_count_val		== 32'h_4;
	soft dir_pp_dir_credit_hwm_val			== 32'h_200;
	soft dir_pp_dir_credit_lwm_val			== 32'h_100;
	soft dir_pp_ldb_credit_count_val		== 32'h_200;
	soft dir_pp_ldb_credit_hwm_val			== 32'h_200;
	soft dir_pp_ldb_credit_lwm_val			== 32'h_80;
	soft dir_pp_v_val						== 32'h_1;
	soft dir_pp_addr_l_val					== 32'h_8000_0000;
	soft dir_pp_addr_u_val					== 32'h_0000_0000;
	soft pf_owns_cq_val						== 1'b_1;
	soft vf_no_owns_cq_val					== 4'h_0;
	soft dir_pp2dirpool_val					== 32'h_0;
	soft dir_pp2ldbpool_val					== 32'h_0;
	soft dir_pp2vas_val						== 32'h_0;
	soft dir_cq_token_depth_select_val		== 32'h_8;
	soft cq_dir_token_depth_select_dsi_val	== 32'h_8;
	soft cq_dir_disable_val					== 32'h_0;
	soft dir_cq_int_depth_thrsh_val			== 32'h_200;
	soft cfg_dir_cq_int_enb_val				== 32'h_0;
	soft dir_cq_timer_threshold_val			== 32'h_0;
	soft dir_cq_addr_l_val		== 32'h_8020_0000;
	soft dir_cq_addr_u_val		== 32'h_0;
	soft pf_owns_pp_val			== 1'b_1;
	soft vf_no_owns_pp_val		== 4'h_0;
	soft dir_cq_isr_en_val		== 2'h_0;
	soft dir_cq_isr_vf_idx_val	== 4'h_0;
	soft dir_cq_isr_vector_val	== 6'h_0;

  }

  function new(string name = "hqm_sla_pcie_queue_cfg_sequence");
    super.new(name);
  endfunction

  virtual task body();
	logic [63:0] loc_addr;
	`ovm_info(get_name(), $sformatf("Starting QUEUE config seq"),OVM_LOW)
	//Credit hist pipe update//
	credit_hist_pipe_regs.CFG_ORD_QID_SN_MAP[qid].write(status,ord_qid_sn_map_val,primary_id,this);
     

	//List pipe update//
	list_sel_pipe_regs.CFG_QID_AQED_ACTIVE_LIMIT[qid].write(status,aqed_active_limit_val,primary_id,this);
     
	list_sel_pipe_regs.CFG_QID_LDB_INFLIGHT_LIMIT[qid].write(status,ldb_inflight_limit_val,primary_id,this);
     
	//list_sel_pipe_regs.CFG_QID_DIR_INFLIGHT_LIMIT[qid].write(status,dir_inflight_limit_val,primary_id,this);

	//AQED pipe update//
	aqed_pipe_regs.CFG_AQED_FREELIST_BASE[qid].write(status,aqed_freelist_base_val,primary_id,this);
     
	aqed_pipe_regs.CFG_AQED_FREELIST_LIMIT[qid].write(status,aqed_freelist_limit_val,primary_id,this);
     
	aqed_pipe_regs.CFG_AQED_FREELIST_PUSH_PTR[qid].write(status,aqed_freelist_push_ptr_val,primary_id,this);
     
	aqed_pipe_regs.CFG_AQED_FREELIST_POP_PTR[qid].write(status,aqed_freelist_pop_ptr_val,primary_id,this);

	//HQM_SYSTEM_CSR LDB QID_V, _CFG SN and FID//
	hqm_system_csr_regs.LDB_QID_V[qid].write(status,ldb_qid_v_val,primary_id,this);
	hqm_system_csr_regs.LDB_QID_CFG_V[qid].write(status,ldb_qid_cfg_v_val,primary_id,this);
     
	//HQM_SYSTEM_CSR DIR QID_V, _CFG SN and FID//
	hqm_system_csr_regs.DIR_QID_V[qid].write(status,dir_qid_v_val,primary_id,this);
//	hqm_system_csr_regs.DIR_QID_CFG_V[qid].write(status,dir_qid_cfg_v_val,primary_id,this);
     

	//Credit updates//
	hqm_system_csr_regs.LDB_POOL_ENABLED[pool].write(status,ldb_pool_enabled_val,primary_id,this);
	hqm_system_csr_regs.DIR_POOL_ENABLED[pool].write(status,dir_pool_enabled_val,primary_id,this);
     
	credit_hist_pipe_regs.CFG_LDB_POOL_CREDIT_COUNT[qid].write(status,ldb_pool_credit_count_val,primary_id,this);
     
	credit_hist_pipe_regs.CFG_LDB_POOL_CREDIT_LIMIT[qid].write(status,ldb_pool_credit_limit,primary_id,this);
     
	credit_hist_pipe_regs.CFG_QED_FREELIST_LIMIT[qid].write(status,qed_freelist_limit_val,primary_id,this);
     
	credit_hist_pipe_regs.CFG_QED_FREELIST_BASE[qid].write(status,qed_freelist_base_val,primary_id,this);
     
	credit_hist_pipe_regs.CFG_QED_FREELIST_PUSH_PTR[qid].write(status,qed_freelist_push_ptr_val,primary_id,this);
     
	credit_hist_pipe_regs.CFG_QED_FREELIST_POP_PTR[qid].write(status,qed_freelist_pop_ptr_val,primary_id,this);
     

     
	credit_hist_pipe_regs.CFG_DIR_POOL_CREDIT_COUNT[qid].write(status,dir_pool_credit_count_val,primary_id,this);
     
	credit_hist_pipe_regs.CFG_DIR_POOL_CREDIT_LIMIT[qid].write(status,dir_pool_credit_limit,primary_id,this);

	//VAS ID CFG//
//32//	
	hqm_system_csr_regs.VAS_GEN[vas_id].write(status,vas_gen_val,primary_id,this);
//4096//    
	hqm_system_csr_regs.LDB_VASQID_V[vas_id].write(status,ldb_vasqid_v_val,primary_id,this);

	//foreach(hqm_system_csr_regs.LDB_VASQID_V[i])
	  hqm_system_csr_regs.LDB_VASQID_V[qid].write(status,qid,primary_id,this);

	hqm_system_csr_regs.DIR_VASQID_V[vas_id].write(status,dir_vasqid_v_val,primary_id,this);
  
	//foreach(hqm_system_csr_regs.LDB_VASCQID_V[i])
	//  hqm_system_csr_regs.LDB_VASCQID_V[i].write(status,0,primary_id,this);


	///CREDIT QUANTA and LIMIT//
	credit_hist_pipe_regs.CFG_DIR_PP_DIR_MIN_CREDIT_QUANTA[qid].write(status,dir_pp_dir_min_credit_quanta_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_PP_LDB_MIN_CREDIT_QUANTA[qid].write(status,dir_pp_ldb_min_credit_quanta_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_DIR_PP2POOL[qid].write(status,dir_dir_pp2pool_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_LDB_PP2POOL[qid].write(status,dir_ldb_pp2pool_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_PP_DIR_CREDIT_COUNT[qid].write(status,dir_pp_dir_credit_count_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_PP_DIR_CREDIT_HWM[qid].write(status,dir_pp_dir_credit_hwm_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_PP_DIR_CREDIT_LWM[qid].write(status,dir_pp_dir_credit_lwm_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_PP_LDB_CREDIT_COUNT[qid].write(status,dir_pp_ldb_credit_count_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_PP_LDB_CREDIT_HWM[qid].write(status,dir_pp_ldb_credit_hwm_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_PP_LDB_CREDIT_LWM[qid].write(status,dir_pp_ldb_credit_lwm_val,primary_id,this);

	hqm_system_csr_regs.DIR_PP_V[qid].write(status,dir_pp_v_val,primary_id,this);

	hqm_system_csr_regs.DIR_PP_ADDR_L[qid].write(status,dir_pp_addr_l_val,primary_id,this);

	hqm_system_csr_regs.DIR_PP_ADDR_U[qid].write(status,dir_pp_addr_u_val,primary_id,this);

	hqm_system_csr_regs.DIR_PP2VF_PF[qid].write(status,{pf_owns_pp_val,vf_no_owns_pp_val},primary_id,this);

	hqm_system_csr_regs.DIR_PP2DIRPOOL[qid].write(status,dir_pp2dirpool_val,primary_id,this);

	hqm_system_csr_regs.DIR_PP2LDBPOOL[qid].write(status,dir_pp2ldbpool_val,primary_id,this);

	hqm_system_csr_regs.DIR_PP2VAS[qid].write(status,dir_pp2vas_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_CQ_TOKEN_DEPTH_SELECT[qid].write(status,dir_cq_token_depth_select_val,primary_id,this);

	list_sel_pipe_regs.CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI[qid].write(status,cq_dir_token_depth_select_dsi_val,primary_id,this);

	list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[qid].write(status,cq_dir_disable_val,primary_id,this);
	list_sel_pipe_regs.CFG_CQ_DIR_DISABLE[qid].read(status,rd_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_CQ_INT_DEPTH_THRSH[qid].write(status,dir_cq_int_depth_thrsh_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_CQ_INT_ENB[qid].write(status,cfg_dir_cq_int_enb_val,primary_id,this);

	credit_hist_pipe_regs.CFG_DIR_CQ_TIMER_THRESHOLD[qid].write(status,dir_cq_timer_threshold_val,primary_id,this);

	hqm_system_csr_regs.DIR_CQ_ADDR_L[qid].write(status,dir_cq_addr_l_val,primary_id,this);

	hqm_system_csr_regs.DIR_CQ_ADDR_U[qid].write(status,dir_cq_addr_u_val,primary_id,this);

	hqm_system_csr_regs.DIR_CQ2VF_PF[qid].write(status,{pf_owns_cq_val,vf_no_owns_cq_val},primary_id,this);

	hqm_system_csr_regs.DIR_CQ_ISR[qid].write(status,{dir_cq_isr_en_val,dir_cq_isr_vf_idx_val,dir_cq_isr_vector_val},primary_id,this);
	hqm_system_csr_regs.DIR_CQ_ISR[qid].read(status,rd_val,primary_id,this);


  endtask

endclass

`endif
