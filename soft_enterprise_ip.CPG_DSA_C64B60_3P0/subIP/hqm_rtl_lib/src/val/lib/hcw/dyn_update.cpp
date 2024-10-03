#include <string>
#include <stdint.h>
#include <iostream>
#include "dyn_update.h"
vas_reset_class::vas_reset_class ( ) 
{ std::cout << "vas_reset_class firing up\n";fflush(NULL); 
  int i, j;

  reorder_info = (new reorder_group_t[NUM_REORDER_GROUPS]); 
  for (i=0; i<NUM_REORDER_GROUPS; i++) {
    reorder_info[i].group_number = i; 
    reorder_info[i].group_mode =  0;
    reorder_info[i].qid = (new uint8_t[MAX_SN_SLOTS_PER_REORDER_GROUP]);
    for (j=0; j <MAX_SN_SLOTS_PER_REORDER_GROUP; j++) {
      reorder_info[i].qid[j] = 0;
    }
  }

  ldb_qid_info = (new qid_t[NUM_LDB_QID]);
  for (i = 0; i < NUM_LDB_QID; i++) { ldb_qid_info[i].v = false; } 

  ldb_cq = (new cq_t[NUM_LDB_PP]);
  for (i = 0; i < NUM_LDB_PP; i++) { ldb_cq[i].v = false; } 
  dir_cq = (new cq_t[NUM_DIR_PP]);
  for (i = 0; i < NUM_DIR_PP; i++) { dir_cq[i].v = false; } 

  ldb_cq_qid_map = (new cq_qid_map_t[NUM_LDB_PP] );
  for (i = 0; i < NUM_LDB_PP; i++ ) {
    ldb_cq_qid_map[i].v   = (new bool[NUM_CQ_QIDIX] );
    for (j = 0; j < NUM_CQ_QIDIX; j++ ) { ldb_cq_qid_map[i].v[j] = false; }
    ldb_cq_qid_map[i].qid = (new uint8_t[NUM_CQ_QIDIX] );
  };

  vas     = (new vas_t[NUM_VAS]);
  for (i = 0; i < NUM_VAS; i++) {
    vas[i].vas_id = i; 
    vas[i].v = false;
    vas[i].ldb_qid = (new (qid_t*[NUM_LDB_QID]));
    vas[i].dir_qid = (new (qid_t*[NUM_DIR_QID]));
    vas[i].pool	   = (new (pool_t*[NUM_POOL]));
  }

  ldb_pool= (new pool_t [NUM_LDB_POOL]);
  for (i = 0; i < NUM_LDB_POOL; i++) {
    ldb_pool[i].pool_id = i;
    ldb_pool[i].v = false;
    ldb_pool[i].ldb_credits = 0;
    ldb_pool[i].dir_credits = 0;
    ldb_pool[i].vas = 0;
    ldb_pool[i].ldb_pp = (new (pp_t*[NUM_LDB_PP]));
    ldb_pool[i].dir_pp = (new (pp_t*[NUM_DIR_PP]));
  }

  dir_pool = (new pool_t [NUM_DIR_POOL]);
  for (i = 0; i < NUM_LDB_POOL; i++) {
    dir_pool[i].pool_id = i;
    dir_pool[i].v = false;
    dir_pool[i].ldb_credits = 0;
    dir_pool[i].dir_credits = 0;
    dir_pool[i].vas = 0;
    dir_pool[i].ldb_pp = (new (pp_t*[NUM_LDB_PP]));
    dir_pool[i].dir_pp = (new (pp_t*[NUM_DIR_PP]));
  }

  ldb_qid = (new qid_t[NUM_LDB_QID]);
  dir_qid = (new qid_t[NUM_DIR_QID]);
  ldb_pp  = (new pp_t [NUM_LDB_PP ]);
  dir_pp  = (new pp_t [NUM_LDB_PP ]);
  ldb_cq  = (new cq_t [NUM_LDB_CQ ]);
  dir_cq  = (new cq_t [NUM_LDB_CQ ]);
}
vas_reset_class::~vas_reset_class () { fflush(NULL); std::cout << "vas_reset_class deconstructing\n";fflush(NULL); }
//==========================================================================================================================//
  uint16_t ldb_qid_enqueue_count (uint8_t qid ) {
    uint16_t count = 0; /*
    count = CSR_PF_BAR[cfg_qid_ldb_enqueue_count][qid]; */
    return (count);
  }
//==========================================================================================================================//
  uint16_t dir_qid_replay_count (uint8_t qid ) {
    uint16_t count = 0; /*
    count = CSR_PF_BAR[cfg_qid_dir_replay_count][qid]; */
    return (count);
  }
//==========================================================================================================================//
  uint16_t ldb_qid_replay_count (uint8_t qid ) {
    uint16_t count = 0; /*
    count = CSR_PF_BAR[cfg_qid_ldb_replay_count][qid]; */
    return (count);
  }
//==========================================================================================================================//
  uint16_t ldb_qid_atq_enqueue_count (uint8_t qid ) {
    uint16_t count = 0; /*
    count = CSR_PF_BAR[cfg_qid_atq_enqueue_count][qid]; */
    return (count);
  }
//==========================================================================================================================//
  uint16_t ldb_qid_atm_enqueue_count (uint8_t qid ) {
    uint16_t count = 0; /*
    count = CSR_PF_BAR[cfg_qid_aqed_active_count][qid]; */
    return (count);
  }
//==========================================================================================================================//
  uint16_t ldb_qid_in_flight_count (uint8_t qid ) {
    uint16_t count = 0; /*
    count = CSR_PF_BAR[cfg_ldb_pool_credit_count][qid]; */
    return (count);
  }
//===========================================================================================================================//
bool master_resource_reset_in_progress ( ) {/*
  return (CSR_PF_BAR[cfg_diagnostic_reset_status] >> 31 );
*/}
//===========================================================================================================================//
bool qed_freelist_full ( uint8_t vas_id ) {/*

  return ((CSR_PF_BAR[cfg_qed_freelist_pop_ptr] ^ CSR_PF_BAR[cfg_qed_freelist_push_ptr]) == 0X10000 ); 

*/}
//===========================================================================================================================//
bool dqed_freelist_full ( uint8_t vas_id ) {/*

  return ((CSR_PF_BAR[cfg_dqed_freelist_pop_ptr] ^ CSR_PF_BAR[cfg_dqed_freelist_push_ptr]) == 0X1000 ); 

*/}
//===========================================================================================================================//
bool dvas_busy ( uint8_t vas_id ) {/*

  return ((CSR_PF_BAR[cfg_ing_dvas_busy_r] >> vas_id) & 1);

*/}
//===========================================================================================================================//
bool svas_busy ( uint8_t vas_id ) {/*

  return ((CSR_PF_BAR[cfg_ing_svas_busy_r] >> vas_id) & 1);

*/}
//==========================================================================================================================//
bool cq_is_empty ( uint8_t cq ) {/*
    return (CSR_PF_BAR[cfg_cq_dir_token_count][cqid] == 0);
    */
} 
//==========================================================================================================================//
bool cq_is_empty ( cq_t *cq ) {
  if (cq->is_ldb) {/*
    return (CSR_PF_BAR[cfg_cq_ldb_token_count][cq->cq_id] == 0);
  */}
  else {/*
    return (CSR_PF_BAR[cfg_cq_dir_token_count][cq->cq_id] == 0);
  */}
}
//==========================================================================================================================//
bool cq_if_complete ( cq_t *cq ) {
    if (cq->is_ldb) {/*
      return (CSR_PF_BAR[cfg_cq_ldb_inflight_count][cq->cq_id] == 0);*/
    } else {	//DIR doesn
      return (true);
    }
}
//===========================================================================================================================//
bool set_vf_reset_in_progress ( uint8_t vf_id ) {/*

    CSR_PF_BAR[pf_vf_reset_in_progress_r] = CSR_PF_BAR[pf_vf_reset_in_progress_r] | (1 << vf_id);
*/
  return(false);
}
//===========================================================================================================================//
bool clr_vf_reset_in_progress ( uint8_t vf_id ) {/*

    CSR_PF_BAR[pf_vf_reset_in_progress_r] = CSR_PF_BAR[pf_vf_reset_in_progress_r] & ~(1 << vf_id);
*/
  return(false);
}
//===========================================================================================================================//
uint8_t get_dm_cq_for_vas ( uint8_t vas ) {
  return (vas + 64);
}
//===========================================================================================================================//
bool disable_cq_interrupts ( cq_t *cq ) {
//  Disable IRQs. Pending interrupts are not blocked and will occur.
  if (cq->is_ldb) {/*
    CSR_PF_BAR[cfg_ldb_cq_int_enb][cq->cq_id].en_depth = 0;
    CSR_PF_BAR[cfg_ldb_cq_int_enb][cq->cq_id].en_tim   = 0;
    CSR_PF_BAR[cfg_ldb_wd_enb_interval][cq->cq_id].enb = 0;
  */} else {/*
    CSR_PF_BAR[cfg_dir_cq_int_enb][cq->cq_id].en_depth = 0;
    CSR_PF_BAR[cfg_dir_cq_int_enb][cq->cq_id].en_tim   = 0;
    CSR_PF_BAR[cfg_dir_wd_enb_interval][cq->cq_id].enb = 0;
  */}  
  return (false) ;
} 
//===========================================================================================================================//
bool enable_cq_interrupts ( cq_t *cq ) {
//  Disable IRQs. Pending interrupts are not blocked and will occur.
  if (cq->is_ldb) {/*
    CSR_PF_BAR[cfg_ldb_cq_int_enb][cq->cq_id].en_depth =  cq->enable_irq_depth_trigger;
    CSR_PF_BAR[cfg_ldb_cq_int_enb][cq->cq_id].en_tim   =  cq->enable_irq_timer_trigger;
    CSR_PF_BAR[cfg_ldb_wd_enb_interval][cq->cq_id].enb =  cq->enable_irq_watchdog_trigger;
  */} else {/*
    CSR_PF_BAR[cfg_dir_cq_int_enb][cq->cq_id].en_depth =  cq->enable_irq_depth_trigger;
    CSR_PF_BAR[cfg_dir_cq_int_enb][cq->cq_id].en_tim   =  cq->enable_irq_timer_trigger;
    CSR_PF_BAR[cfg_dir_wd_enb_interval][cq->cq_id].enb =  cq->enable_irq_watchdog_trigger;
  */}  
  return (false) ;
} 
//===========================================================================================================================//
bool disable_pool ( bool is_ldb, uint8_t pool ) {
  if (is_ldb) {/*
    CSR_PF_BAR[ldb_pool_enabled_r][pool].pool_enabled = 0;
  */}
  else {/*
    CSR_PF_BAR[dir_pool_enabled_r][pool].pool_enabled = 0;
  */}
  return(false);
}
//===========================================================================================================================//
bool enable_pool ( bool is_ldb, uint8_t pool ) {
  if (is_ldb) {/*
    CSR_PF_BAR[ldb_pool_enabled_r][pool].pool_enabled = 1;
  */}
  else {/*
    CSR_PF_BAR[dir_pool_enabled_r][pool].pool_enabled = 1;
  */}
  return(false);
}
//===========================================================================================================================//
bool disable_dvas ( uint8_t dvas ) {/*

    CSR_PF_BAR[cfg_ing_dvas_drop_r] =  CSR_PF_BAR[cfg_ing_dvas_drop_r] | (1 << dvas );
*/
  return (false);
}
//===========================================================================================================================//
bool enable_dvas ( uint8_t dvas ) {/*

    CSR_PF_BAR[cfg_ing_dvas_drop_r] =  CSR_PF_BAR[cfg_ing_dvas_drop_r] & ~(1 << dvas );
*/
  return (false);
}
//==========================================================================================================================//
bool disable_qid_vas_write (qid_t *q ) {
  int i, j;
  bool is_ldb = (q->type == ATM || q->type == UNO || q->type == DIR );
  for (i = 0; i < NUM_VAS; i++) {
    if (is_ldb) {
      /*
      CSR_PF_BAR[ldb_vasqid_v_r + (i*NUM_LDB_QID + q->qid)*4 ].vasqid_v  = 0;
      CSR_PF_BAR[ldb_vascqid_v_r+ (i*NUM_LDB_QID + q->qid)*4 ].vascqid_v = 0;
      */
    } else {
      /*
      CSR_PF_BAR[dir_vasqid_v_r + (i*NUM_LDB_QID + q->qid)*4 ].vasqid_v  = 0;
      CSR_PF_BAR[dir_vascqid_v_r+ (i*NUM_LDB_QID + q->qid)*4 ].vascqid_v = 0;
      */
    }
  }
  return(true);
} 
//==========================================================================================================================//
bool enable_qid_vas_write (qid_t *q ) {
  int i, j;
  bool is_ldb = (q->type == ATM || q->type == UNO || q->type == DIR );
  for (i = 0; i < NUM_VAS; i++) {
    if (is_ldb) {
      /*
      CSR_PF_BAR[ldb_vasqid_v_r + (i*NUM_LDB_QID + q->qid)*4 ].vasqid_v  = 1;
      CSR_PF_BAR[ldb_vascqid_v_r+ (i*NUM_LDB_QID + q->qid)*4 ].vascqid_v = 1;
      */
    } else {
      /*
      CSR_PF_BAR[dir_vasqid_v_r + (i*NUM_LDB_QID + q->qid)*4 ].vasqid_v  = 1;
      CSR_PF_BAR[dir_vascqid_v_r+ (i*NUM_LDB_QID + q->qid)*4 ].vascqid_v = 1;
      */
    }
  }
  return(true);
} 
//==========================================================================================================================//
bool disable_qid (qid_t *q) {
  if (!q->is_pf) {/*
    CSR_PF_BAR[vf_ldb_vqid_vld[q->vf][vqid]]  = false;
    */
  } else {/*
    CSR_PF_BAR[pf_ldb_qid_vld[q->qid]]	      = false;
    */
  }
  return(false);
}
//==========================================================================================================================//
bool enable_qid (qid_t *q) {
  if (!q->is_pf) {/*
    CSR_PF_BAR[vf_ldb_vqid_vld[q->vf][vqid]]  = true;
    */
  } else {/*
    CSR_PF_BAR[pf_ldb_qid_vld[q->qid]]	      = true;
    */
  }
  return(false);
}
//===========================================================================================================================//
bool disable_cq_token_check ( cq_t *cq ) {
  if (cq->is_ldb) {/*
    CSR_PF_BAR[cfg_cq_ldb_token_depth_select_dsi][cq->cq_id]  |=  0x10;
  */}
  else {/*
    CSR_PF_BAR[cfg_cq_dir_token_depth_select_dsi][cq->cq_id]  |=  0x10;
  */}
  return(false);
}
//===========================================================================================================================//
bool disable_cq ( cq_t *cq ) {
  if (cq->is_ldb) {/*
    CSR_PF_BAR[cfg_cq_dir_disable][cq].disabled = 1;
  */}
  else {/*
    CSR_PF_BAR[cfg_cq_dir_disable][cq].disabled = 1;
  */}
  return(false);
}
//==========================================================================================================================//
bool enable_cq (cq_t *cq ) {
  if (cq->is_ldb) {/*
    CSR_PF_BAR[cfg_cq_ldb_disable][cq].disabled = 0;
  */}
  else {/*
    CSR_PF_BAR[cfg_cq_dir_disable][cq].disabled = 0;
  */}
  return (false);
}
//===========================================================================================================================//
bool disable_pp ( pp_t *pp) {
  if (pp->is_ldb) {
    if (!pp-> is_pf) {/*
      CSR_PF_BAR[vf_ldb_vpp_v][pp->vf][pp->vpp_id].vpp_v = 0;*/
    }/*
    CSR_PF_BAR[ldb_pp_v[pp->pp_id]] = 0;
  */}
  else {
    if (!pp-> is_pf) {/*
      CSR_PF_BAR[vf_dir_vpp_v][pp->vf][pp->vpp_id].vpp_v = 0;*/
    }/*
    CSR_PF_BAR[dir_pp_vld[pp->pp_id]]	= 0;*/
    }
  return(false);
}
//===========================================================================================================================//
bool enable_pp ( pp_t *pp) {
  if (pp->is_ldb) {
    if (!pp-> is_pf) {/*
      CSR_PF_BAR[vf_ldb_vpp_v][pp->vf][pp->vpp_id].vpp_v = 1;*/
    }/*
    CSR_PF_BAR[ldb_pp_v[pp->pp_id]] = 1;
  */}
  else {
    if (!pp-> is_pf) {/*
      CSR_PF_BAR[vf_dir_vpp_v][pp->vf][pp->vpp_id].vpp_v = 1;*/
    }/*
    CSR_PF_BAR[dir_pp_vld[pp->pp_id]]	= 1;*/
    }
  return(false);
}
//===========================================================================================================================//
bool disable_pp_credit_update ( pp_t *pp ) {
  if (pp->is_ldb) {/*
    CSR_PF_BAR[cfg_ldb_pp_credit_request_state_r][pp->pp_id].no_pp_credit_update = 1; 
  */}
  else {/*
    CSR_PF_BAR[cfg_dir_pp_credit_request_state_r][pp->pp_id].no_pp_credit_update = 1;
  */}
 return (false);
}
//===========================================================================================================================//
bool enable_pp_credit_update ( pp_t *pp ) {
  if (pp->is_ldb) {/*
    CSR_PF_BAR[cfg_ldb_pp_credit_request_state_r][pp->pp_id].no_pp_credit_update = 0; 
  */}
  else {/*
    CSR_PF_BAR[cfg_dir_pp_credit_request_state_r][pp->pp_id].no_pp_credit_update = 0;
  */}
 return (false);
}
//===========================================================================================================================/
bool enable_vas_qid ( qid_t *q ) {
  bool is_ldb = (q->type == ATM || q->type == UNO || q->type == DIR );
  if (is_ldb) {/*
    CSR_PF_BAR[ldb_vasqid_v_r][q->vas][q->qid].vasqid_v = 1;
  */}
  else {/*
    CSR_PF_BAR[dir_vasqid_v_r][q->vas][q->qid].vasqid_v = 1;
  */}
  return (false) ;
}
//===========================================================================================================================/
bool disable_vas_qid ( qid_t *q ) {
  bool is_ldb = (q->type == ATM || q->type == UNO || q->type == DIR );
  if (is_ldb) {/*
    CSR_PF_BAR[ldb_vasqid_v_r][q->vas][q->qid].vasqid_v = 0;
  */}
  else {/*
    CSR_PF_BAR[dir_vasqid_v_r][q->vas][q->qid].vasqid_v = 0;
  */}
  return (false) ;
}
//===========================================================================================================================/
bool disable_vas_cqid ( qid_t *q) {
  bool is_ldb = (q->type == ATM || q->type == UNO || q->type == DIR );
  if (is_ldb) {/*
    CSR_PF_BAR[ldb_vascqid_v_r][q->vas][q->qid].vascqid_v = 0;
  */}
  else {/*
    CSR_PF_BAR[ldb_vascqid_v_r][q->vass][q->qid].vascqid_v = 0;
  */}
  return (false) ;
}
//===========================================================================================================================/
uint8_t dir_cq_tok_count ( uint8_t cq ) {/*

  return (CSR_PF_BAR[cfg_cq_dir_token_count_r][cq]);

*/}
//===========================================================================================================================/
uint8_t dir_qid_enqueue_count ( uint8_t qid ) {/*

  return (CSR_PF_BAR[cfg_qid_dir_enqueue_count][qid]);

*/}
//===========================================================================================================================//
bool hw_resource_reset ( resource_e resource_type, uint8_t resource_id ) {/*

  CSR_PF_BAR[cfg_reset_vf_start].vf_reset_type  = resource_type;
  CSR_PF_BAR[cfg_reset_vf_start].vf_reset_id    = resource_id;
  CSR_PF_BAR[cfg_reset_vf_start].vf_reset_start = 1;

*/
  return(false);
}
//===========================================================================================================================//
bool set_pp_info (pp_t *pp ) {

  if (pp->is_ldb) {/*
    CSR_PF_BAR[dir_pp2pa_1[pp->pp_id]]	= (pp->credit_push_ptr_base_address + 64) >> 32;
    CSR_PF_BAR[dir_pp2pa_0[pp->pp_id]]	= (pp->credit_push_ptr_base_address + 64) & 0x00000000FFFFFFFF;
    CSR_PF_BAR[ldb_pp2pa_1[pp->pp_id]]	= (pp->credit_push_ptr_base_address ) >> 32;
    CSR_PF_BAR[ldb_pp2pa_0[pp->pp_id]]	= (pp->credit_push_ptr_base_address ) & 0x00000000FFFFFFFF;
    CSR_PF_BAR[ldb_pp2vf_pf[pp->pp_id]]	= {pp->is_pf, pp->vf};
    CSR_PF_BAR[ldb_pp2vpp[pp->pp_id]]	= pp->vpp_id;
    CSR_PF_BAR[vf_ldb_vpp2pp[pp->vpp_id]]	= pp->pp_id;
    CSR_PF_BAR[ldb_pp2dirpool[pp->pp_id]]	= pp->pool;
    CSR_PF_BAR[ldb_pp2ldbpool[pp->pp_id]]	= pp->pool
    CSR_PF_BAR[ldb_pp2vas[pp->pp_id]]	= pp->vas;
  } else {/*
    CSR_PF_BAR[dir_pp2vf_pf_dm[pp->pp_id]]	= {pp->is_hw_dsi, pp->is_pf, pp->vf};
    CSR_PF_BAR[dir_pp2vpp[pp->pp_id]]	= pp->vpp_id;
    CSR_PF_BAR[vf_dir_vpp2pp[pp->vpp_id]]	= pp->pp_id;
    CSR_PF_BAR[dir_pp2vas[pp->pp_id]	= pp->vas;
    CSR_PF_BAR[dir_pp2dirpool[pp->pp_id]]	= pp->pool;
    CSR_PF_BAR[dir_pp2ldbpool[pp->pp_id]]	= pp->pool;
    */
  }
}  
//==========================================================================================================================//
bool set_cq_info (cq_t *cq ) {

  if (cq->is_ldb) {/*
    CSR_PF_BAR[ldb_cq_addr_l_r][cq->cq_id]		  = cq->base_address & 0x00000000FFFFFFFF;
    CSR_PF_BAR[ldb_cq_addr_h_r][cq->cq_id]		  = cq->base_address >> 32;
    CSR_PF_BAR[cfg_ldb_cq_token_depth_select][cq->cq_id]  = cq->cq_depth_select;   //CHP
    CSR_PF_BAR[cfg_cq_ldb_token_depth_select][cq->cq_id]  = {cq->ignore_token_depth, cq->cq_depth_select;}  //LSP
    CSR_PF_BAR[cfg_cq_ldb_inflight_limit][cq->cq_id]	  = cq->cq_inflight_limit; //LSP
    CSR_PF_BAR[cfg_cmp_sn_chk_enbl][cq->cq_id]		  = cq->enable_sequence_checking;
    CSR_PF_BAR[ldb_cq2vf_pf[cq->cq_id]]			  = {cq->is_pf, cq->vf};
    CSR_PF_BAR[cfg_ldb_cq_int_depth_thrsh]]		  = cq->service_depth_threshold;
    CSR_PF_BAR[cfg_ldb_cq_timer_threshold]]		  = cq->service_timer_threshold;
  */}
  else {/*
    CSR_PF_BAR[dir_cq_addr_l_r][cq->cq_id]		  = cq->base_address & 0x00000000FFFFFFFF;
    CSR_PF_BAR[dir_cq_addr_h_r][cq->cq_id]		  = cq->base_address >> 32;
    CSR_PF_BAR[cfg_dir_cq_token_depth_select_dsi][cq->cq_id]  = cq->cq_depth_select; //CHP
    CSR_PF_BAR[cfg_cq_dir_token_depth_select_dsi][cq->cq_id]  = {cq->disable_wb_opt,cq->ignore_token_depth, cq->cq_depth_selecti}; //LSP
    CSR_PF_BAR[dir_cq_dsi_fmt[cq->cq_id]]		      = {cq->is_hw_dsi, cq->keep_pp_pf, cq->is_chained};
    CSR_PF_BAR[dir_cq2vf_pf[cq->cq_id]]			      = {cq->is_pf, cq->vf};
    CSR_PF_BAR[cfg_dir_cq_int_depth_thrsh]]		      = cq->service_depth_threshold;
    CSR_PF_BAR[cfg_dir_cq_timer_threshold]]		      = cq->service_timer_threshold;
  */}
}
//==========================================================================================================================//
bool set_cq_qid_info ( uint8_t cq_id, cq_qid_map_t *cq_qid_info ) {
  int i, j;
  uint8_t bit, wrd;
  uint8_t *p = cq_qid_info[cq_id].priority;
  bool	  *v = cq_qid_info[cq_id].v;
  uint8_t *qid = cq_qid_info[cq_id].qid;
  uint8_t  vs = 0;
  uint32_t ps = 0;

  for (i = NUM_CQ_QIDIX-1; i >=0;  i-- ) {
    vs  = vs << 1 | v[i] & 1;
    ps  = ps << 3 | p[i] & 7; /*
    CSR_PF_BAR[cfg_cq2priov][cq_id].prio = ps;
    CSR_PF_BAR[cfg_cq2priov][cq_id].v    = vs;  */
    bit = (cq_id % 4 ) * 8 + i;
    wrd = (cq_id / 4 );
    if (v[i]) {/*
      CSR_PF_BAR[cfg_qid_ldb_qid2cqidix + wrd*4 ][qid[cq_id]] |=  (1 << bit) ; //LSP
      CSR_PF_BAR[cfg_qid_ldb_qid2cqidix2+ wrd*4 ][qid[cq_id]] |=  (1 << bit) ; //LSP
      CSR_PF_BAR[cfg_qid_ldb_qid2cqidix + wrd*4 ][qid[cq_id]] |=  (1 << bit) ; //ATM
      */
    } else {/*
      CSR_PF_BAR[cfg_qid_ldb_qid2cqidix + wrd*4 ][qid[cq_id]] &= ~(1 << bit) ; //LSP
      CSR_PF_BAR[cfg_qid_ldb_qid2cqidix2+ wrd*4 ][qid[cq_id]] &= ~(1 << bit) ; //LSP
      CSR_PF_BAR[cfg_qid_ldb_qid2cqidix + wrd*4 ][qid[cq_id]] &= ~(1 << bit) ; //ATM  */
    }
  }
  return (false) ;
}
//==========================================================================================================================//
bool set_pp_credit_info ( pp_t *pp) {
  if (pp->is_ldb) {/*
    CSR_PF_BAR[cfg_ldb_pp_dir_credit_hwm]		= pp->dir_credit_lwm;
    CSR_PF_BAR[cfg_ldb_pp_dir_credit_lwm]		= pp->dir_credit_hwm;
    CSR_PF_BAR[cfg_ldb_pp_ldb_credit_hwm]		= pp->ldb_credit_hwm;
    CSR_PF_BAR[cfg_ldb_pp_ldb_credit_lwm]		= pp->lwb_credit_lwm;
    CSR_PF_BAR[cfg_ldb_pp_dir_min_credit_quanta]	= pp->dir_credit_quanta;
    CSR_PF_BAR[cfg_ldb_pp_ldb_min_credit_quanta]	= pp->ldb_credit_quanta; */
  } else { /*
    CSR_PF_BAR[cfg_dir_pp_dir_credit_hwm]		= pp->dir_credit_lwm;
    CSR_PF_BAR[cfg_dir_pp_dir_credit_lwm]		= pp->dir_credit_hwm;
    CSR_PF_BAR[cfg_dir_pp_ldb_credit_hwm]		= pp->ldb_credit_hwm;
    CSR_PF_BAR[cfg_dir_pp_ldb_credit_lwm]		= pp->lwb_credit_lwm;
    CSR_PF_BAR[cfg_dir_pp_dir_min_credit_quanta]	= pp->dir_credit_quanta;
    CSR_PF_BAR[cfg_dir_pp_ldb_min_credit_quanta]	= pp->ldb_credit_quanta; */

  return (false);
  }
}
//==========================================================================================================================//
bool set_pool_info ( pool_t *pool_info ) {
  int i, j, k;
  int32_t ldb_credits_provisioned = 0;
  int32_t dir_credits_provisioned = 0;
  uint16_t ldb_credits_requested = 0;
  uint16_t dir_credits_requested = 0;
  /*The freelist configurations DEFINE the available credits for the pool
  ldb_credits_provisioned = (CSR_PF_BAR[cfg_ldb_pool_credit_limit][pool_id] - CSR_PF_BAR[cfg_qed_freelist_base] [pool_id]) + 1;
  dir_credits_provisioned = (CSR_PF_BAR[cfg_dir_pool_credit_limit][pool_id] - CSR_PF_BAR[cfg_dqed_freelist_base][pool_id]) + 1; */

  for (i = 0; i < NUM_LDB_PP; i++) {
    if ( pool_info->v && pool_info->ldb_pp[i]->v) {
      ldb_credits_requested +=  pool_info->ldb_pp[i]->ldb_credits;
      dir_credits_requested +=  pool_info->ldb_pp[i]->dir_credits;
    }
  }
  for (i = 0; i < NUM_DIR_PP; i++) {
    if ( pool_info->v && pool_info->dir_pp[i]->v ) {
      ldb_credits_requested +=  pool_info->dir_pp[i]->ldb_credits;
      dir_credits_requested +=  pool_info->dir_pp[i]->dir_credits;
    }
  }
  ldb_credits_requested += pool_info->ldb_credits;
  dir_credits_requested += pool_info->dir_credits;

  //Check for illegal reconfiguration request
  if   ((ldb_credits_provisioned < ldb_credits_requested )/*
     || (ldb_credits_provisioned < CSR_PF_BAR[cfg_ldb_pool_credit_limit][pool_id])
        (dir_credits_provisioned < dir_credits_requested
     || (dir_credits_provisioned < CSR_PF_BAR[cfg_dir_pool_credit_limit][pool_id])*/ ) {
      return(true); //Illegal reconfiguration request
      }
  
  for (i = 0; i < NUM_LDB_PP; i++) {
    if ( pool_info->v && pool_info->ldb_pp[i]->v) {/*
      CSR_PF_BAR[cfg_ldb_pp_dir_credit_count][pool_info->pool_id] = pool_info->ldb_pp[i].dir_credits;
      CSR_PF_BAR[cfg_ldb_pp_ldb_credit_count][pool_info->pool_id] = pool_info->ldb_pp[i].ldb_credits;*/
    }
  }/*
  CSR_PF_BAR[cfg_ldb_pool_credit_count][pool_id] = pool_info->ldb_credits;*/

  for (i = 0; i < NUM_DIR_PP; i++) {
    if ( pool_info->v && pool_info->dir_pp[i]) {/*
      CSR_PF_BAR[cfg_dir_pp_dir_credit_count][pool_info->pool_id] = pool_info->dir_pp[i].dir_credits;
      CSR_PF_BAR[cfg_dir_pp_ldb_credit_count][pool_info->pool_id] = pool_info->dir_pp[i].ldb_credits;*/
    }
  }/*
  CSR_PF_BAR[cfg_dir_pool_credit_count][pool_id] = pool_info->dir_credits;*/
  
  return (false);
}
//==========================================================================================================================//
bool setup_latency_smon(uint8_t qid) {
  //configure SMON
  return (false);
}
//==========================================================================================================================//
bool set_dir_qid_info ( qid_t *q ) {
  /*
  CSR_BAR_PF[dir_qid2dvas[q->qid]]		= q->vas; */
  if (q->is_monitored) {
    setup_latency_smon(q->qid);
  }
  if (!q->is_pf) {/*
    CSR_BAR_PF[vf_meas_lat_enb[q->vf]]		= q->is_monitored;
    CSR_BAR_PF[vf_dir_vqid2qid[q->vf][q->vqid]]	= q->qid;
    CSR_BAR_PF[vf_dir_vqid_chain[q->vf][q->vqid]]	= q->is_chained;   
  } else {/*
    CSR_BAR_PF[hqm_system_pf_meas_latency]		= q->is_monitored;
    CSR_BAR_PF[pf_dir_qid_chain]			= q->is_chain;*/
  }
  return (false);
}
//==========================================================================================================================//
bool set_ldb_qid_info (qid_t *q ) {

  if (q->is_monitored) {
    setup_latency_smon(q->qid);
  }

  switch (q->type) {
    case ATM:/*
      CSR_PF_BAR[cfg_qid_aqed_active_limit][q->qid].limit	= q->aqos_limit;
      CSR_PF_BAR[cfg_qid_ldb_inflight_limit][q->qid].limit	= q->in_flight_limit;
      CSR_PF_BAR[cfg_aqed_qid_fid_limit][q->qid].qid_fid_limit	= q->fid_limit ;
      CSR_PF_BAR[cfg_aqed_qid_hid_width[q->qid]			= q->hid_mask;
      CSR_PF_BAR[ldb_qid_cfg_v_r][q->qid].fid_cfg = 1;
      CSR_PF_BAR[ldb_qid_cfg_v_r][q->qid].sn_cfg = 0;*/
      break;
    case ORD:
      /*CANNOT CHANGE THE SHAPE OF A GROUP- the MODE CANNOT BE CHANGED. A QID MAY ONLY BE REPOSITIONED IN A PRE-CONFIGURED GROUP
      CSR_PF_BAR[cfg_qid2grpslt][q->qid].group		    = q->sn_group;
      CSR_PF_BAR[cfg_qid2grpslt][q->qid].slot		    = q->sn_slot;
      CSR_PF_BAR[cfg_ord_qid_sn_map].slot		    = q->sn_slot;
      CSR_PF_BAR[cfg_ord_qid_sn_map].slot		    = q->sn_group;
      CSR_PF_BAR[cfg_qid_ldb_inflight_limit][q->qid].limit  = q->in_flight_limit;
      CSR_PF_BAR[ldb_qid_cfg_v_r][q->qid].fid_cfg = 0;
      CSR_PF_BAR[ldb_qid_cfg_v_r][q->qid].fid_cfg = 1;*/
      break;
    case UNO:/*
      CSR_PF_BAR[cfg_qid_ldb_inflight_limit][q->qid].limit = q->in_flight_limit;
      CSR_PF_BAR[ldb_qid_cfg_v_r][q->qid].fid_cfg = 0;
      CSR_PF_BAR[ldb_qid_cfg_v_r][q->qid].sn_cfg = 0;*/
      break;
    default: return (true);
  }
  /*
  CSR_PF_BAR[ldb_vascqid_vld[q->vas][q->qid]    = q->is_chained;
  CSR_PF_BAR[ldb_cqid2vcqid[q->qid]]		= q->vqid;
  CSR_PF_BAR[ldb_qid_cfg_vld]			= {q->type==ATM, q->type==ORD};
  */
  if (!q->is_pf) {/*
    CSR_PF_BAR[vf_meas_lat_enb[q->vf]] = true;
    CSR_PF_BAR[vf_ldb_vqid2qid[q->vf]  [q->vqid]]  = q->qid;
    CSR_PF_BAR[vf_ldb_vcqid2cqid[q->vf][q->vqid]]  = q->qid;
    */
  } else {/*
    CSR_PF_BAR[hqm_system_pf_meas_latency[q->qid]]  = q->is_monitored;
    CSR_PF_BAR[vf_ldb_qid2vqid[q->qid]]		    = q->vqid;
    */
  }
  return(false);
}
//==========================================================================================================================//
bool dyn_reconfig_cq ( cq_t *cq ) {
  int i;
  //If this CQ is the ONLY schedule target for a QID, the QID must be disabled first to flush credits from qed/dqed
  if (cq->is_ldb) { //LDB CQ
    if ( cq->v ) {
      disable_cq_interrupts ( cq  );
      disable_cq ( cq );
      for (i = 0; i < MAX_CQ_EMPTY_CHECK_LOOPS; i++ ) {
	if (cq_is_empty ( cq )) { goto LDB_CQ_EMPTY; }
      }
      return (true); //CQ failed to go empty
LDB_CQ_EMPTY: 
      for (i = 0; i < MAX_CQ_INFLIGHT_CHECK_LOOPS; i++ ) {
	if (cq_if_complete ( cq )) {goto CQ_INFLIGHT_COMPLETE; }
      } 
      return(true); //CQ Inflights failed to completed
CQ_INFLIGHT_COMPLETE: 
      set_cq_info ( cq ) ;
      enable_cq_interrupts ( cq );
      enable_cq ( cq );
    }
  } else if ( cq->v ) {	  //DIR CQ
    if (cq->is_hw_dsi) {  //DM Port
      for (i = 0; i < MAX_SVAS_CHECK_LOOPS; i++ ) {
	if (!svas_busy ( cq->cq_id & 0x1F )) { goto SVAS_IDLE; }
      }
      return(true);	  //SVAS failed to idle
    }
SVAS_IDLE:
    disable_cq_interrupts ( cq );
    disable_cq ( cq );
    for (i = 0; i < MAX_CQ_EMPTY_CHECK_LOOPS; i++ ) {
      if (cq_is_empty ( cq )) { goto DIR_CQ_EMPTY; }
    }
     return (true);   //CQ failed to go empty
DIR_CQ_EMPTY: 
      set_cq_info ( cq ) ;
      enable_cq_interrupts ( cq );
      enable_cq ( cq );
    }  else {
      return (true);  //Operation for invalid CQ attempted
    }
  return (false) ;
}
//==========================================================================================================================//
bool dyn_reconfig_cq_qid_mapping ( cq_t *cq, cq_qid_map_t *cq_qid_map ) {
  int i;
  cq_qid_map_t cq_qid_info = cq_qid_map[cq->cq_id];
  if (cq_qid_info.v) {
      disable_cq_interrupts ( cq );
      disable_cq ( cq );
      for (i = 0; i < MAX_CQ_EMPTY_CHECK_LOOPS; i++ ) {
	if (cq_is_empty ( cq )) { goto LDB_CQ_EMPTY; }
      }
      return (true); //CQ failed to go empty
LDB_CQ_EMPTY: 
      for (i = 0; i < MAX_CQ_INFLIGHT_CHECK_LOOPS; i++ ) {
	if (cq_if_complete ( cq )) {goto CQ_INFLIGHT_COMPLETE; }
      } 
      return(true); //CQ Inflights failed to completed
CQ_INFLIGHT_COMPLETE: 
      set_cq_qid_info (cq->cq_id, cq_qid_map ) ;
      enable_cq_interrupts ( cq );
      enable_cq (cq);
    } else {
    return (true);
  }
  return (false) ;
}
//==========================================================================================================================//
bool dyn_reconfig_pp ( pp_t * pp) {
  disable_pp  ( pp );
  disable_pp_credit_update ( pp );
  set_pp_credit_info ( pp );
  return (false) ;
}
//==========================================================================================================================//
bool dyn_reconfig_pool ( uint8_t vf_id, pool_t *pool ) {
  int i, j, k;
 
  //Assumption : PF Flushes QEs from QED
  for (i = 0; i < NUM_LDB_PP; i++ ) {
    if (pool->v && pool->ldb_pp[i]->v) {
      disable_pp  ( pool->ldb_pp[i] );
      disable_pp_credit_update ( pool->ldb_pp[i] );
    }
  }
  //Assumption : PF Flushes QEs from DQED  
  for (i = 0; i < NUM_DIR_PP; i++ ) {
    if (pool->v && pool->dir_pp[i]->v) {
      disable_pp  ( pool->dir_pp[i] );
      disable_pp_credit_update ( pool->dir_pp[i] );
    }
  }
  for (k = 0; k < MAX_CREDIT_CHECK_LOOPS; k++ ) {   //All QEs enq by VAS that could sched different VAS (via DM only) must 
    if ( qed_freelist_full ( pool->pool_id )) {	    //  return credits to VAS pool to avoid bogus post-reset VAS credit updates.
      goto LDB_CREDITS_BACK;			    //	  All non-DM QE (same VAS) will be erased by the HW resource reset sequence
    }						    //	    Since PP source of QEs will be in same VAS & cleaned by hw_resource_reset
  }
  return(true);	  //LDB Credits did not return     
LDB_CREDITS_BACK:

  for (k = 0; k < MAX_CREDIT_CHECK_LOOPS; k++ ) {   //All QEs enq by VAS that could sched different VAS (via DM only) must 
    if ( dqed_freelist_full ( pool->pool_id )) {    //  return credits to VAS pool to avoid bogus post-reset VAS credit updates.
      goto DIR_CREDITS_BACK;			    //	  All non-DM QE (same VAS) will be erased by the HW resource reset sequence
    }						    //	    Since PP source of QEs will be in same VAS & cleaned by hw_resource_reset
  }
  return(true);	  //DIR Credits do not return	  
DIR_CREDITS_BACK:
  set_pool_info ( pool );
  for (i = 0; i < NUM_LDB_PP; i++ ) {
    if (pool->v && pool->ldb_pp[i]->v) {
      enable_pp  ( pool->ldb_pp[i] );
      enable_pp_credit_update ( pool->ldb_pp[i] );
    }
  }
  for (i = 0; i < NUM_DIR_PP; i++ ) {
    if (pool->v && pool->dir_pp[i]->v) {
      enable_pp  ( pool->dir_pp[i] );
      enable_pp_credit_update ( pool->dir_pp[i] );
    }
  }
  return (false) ;
}
//==========================================================================================================================//
bool dyn_reconfig_qid ( qid_t *q ) {

  //PF has already shut down the VAS no new enqueues to this qid are expected
  int k; 
  bool is_ldb = (q->type == ATM || q->type == UNO || q->type == DIR );
  disable_vas_qid  ( q );
  disable_vas_cqid ( q );
  if (is_ldb) {
    for (k = 0; k < MAX_QID_CHECK_LOOPS; k++) { 
      if(
	(ldb_qid_in_flight_count    (q->qid) == 0 ) &&
	(ldb_qid_replay_count	    (q->qid) == 0 ) &&
	(ldb_qid_atq_enqueue_count  (q->qid) == 0 ) &&
	(ldb_qid_atm_enqueue_count  (q->qid) == 0 ) &&
	(ldb_qid_enqueue_count	    (q->qid) == 0 )) { 
	disable_qid ( q );
	disable_qid_vas_write ( q );
	goto LDB_QID_QUIESCED;
      }
    }
    return (true);  //Failed to quiesce
LDB_QID_QUIESCED: 
      set_ldb_qid_info  ( q );
      return (false) ;
  } else {
    for (k = 0; k < MAX_QID_CHECK_LOOPS; k++) {
      if(
	(cq_is_empty		    (q->qid) == 0 ) &&
	(dir_qid_enqueue_count	    (q->qid) == 0 )) {
	disable_qid ( q );
	disable_qid_vas_write ( q );
	goto DIR_QID_QUIESCED;
      }
    }
    return (true);  //Failed to quiesce
DIR_QID_QUIESCED:
      set_dir_qid_info  ( q );
      enable_qid ( q );
      enable_qid_vas_write ( q );
    return(false);
  }
}
//==========================================================================================================================//
int main () {}
