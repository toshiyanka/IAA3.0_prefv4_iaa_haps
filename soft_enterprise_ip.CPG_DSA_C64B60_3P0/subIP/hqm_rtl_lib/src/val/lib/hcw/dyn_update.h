#ifndef VAS_RESET_H_
#define VAS_RESET_H_
#include <stdio.h>
#include <string>
#include <stdint.h>
#include <iostream>
#include <assert.h>
#define NUM_CQ_QIDIX 8
#define NUM_VAS 64
#define NUM_DM_VAS 32
#define NUM_LDB_PP 64
#define NUM_DIR_PP 128
#define NUM_LDB_POOL 64
#define NUM_POOL 64
#define NUM_DIR_POOL 64
#define NUM_LDB_CQ 64
#define NUM_DIR_CQ 128
#define NUM_LDB_QID 128
#define NUM_DIR_QID 128
#define MAX_CREDIT_CHECK_LOOPS  (16*1024 * 14)
#define MAX_SVAS_CHECK_LOOPS (512 * 1024 * (800/30))
#define MAX_DM_CQ_CHECK_LOOPS (32*64*1024 * (800/30))
#define MAX_DM_QID_CHECK_LOOPS (32*64*1024 * (800/30))
#define MAX_CQ_EMPTY_CHECK_LOOPS ( 1024 * (800/2))
#define MAX_CQ_INFLIGHT_CHECK_LOOPS ( 1024 * (800/2))
#define MAX_CQ_COMP_CHECK_LOOPS ( 1024 * (800/2))
#define MAX_QID_CHECK_LOOPS (128 * 64*1024)
#define NUM_REORDER_GROUPS 4
#define MAX_SN_PER_REORDER_GROUP 1024
#define MAX_SN_SLOTS_PER_REORDER_GROUP 32
uint32_t *CSR_PF_BAR ;
enum qe_e {ATM,UNO,ORD,DIR};
enum resource_e { CQ_LDB_TYPE, CQ_DIR_TYPE, QID_LDB_TYPE, QID_DIR_TYPE, POOL_LDB_PORT_TYPE, POOL_DIR_PORT_TYPE };
struct cq_qidixv_t {
		uint32_t *w;
};
struct reorder_group_t {
		bool	v;
		uint8_t	  group_number;
		uint8_t	  group_mode;
		uint8_t	  *qid;		
};
struct dir_qid_t {
		bool	  v;
		uint8_t	  vas;
		bool	  is_vf;
		uint8_t	  vf;
		bool	  is_hw_dsi;
		bool	  is_chained;
		bool	  is_monitored;
		uint8_t	  qid;
};
struct cq_qid_map_t {
		bool	  *v;
		uint8_t	  *priority;
		uint8_t	  *qid;
};
struct cq_t  {
		bool	  v;
		uint8_t	  cq_id;
		bool	  is_pf;
		uint8_t	  vf;
		bool	  is_ldb;
		bool	  is_hw_dsi;
		bool	  keep_pp_pf;
		bool	  is_chained;
		bool	  ignore_token_depth;
		bool	  disable_wb_opt;
		bool	  enable_sequence_checking;
		uint64_t  base_address;
		uint8_t	  cq_depth_select;
		uint16_t  cq_inflight_limit;
		bool	  enable_irq_depth_trigger;
		uint16_t  service_depth_threshold;
		bool	  enable_irq_timer_trigger;
		uint8_t	  service_timer_threshold;
		bool	  enable_irq_watchdog_trigger;
};
struct qid_t {
		uint8_t	  qid;
		bool	  v;
		qe_e	  type;
		bool	  is_hw_dsi;
		bool	  is_chained;
		bool	  is_monitored;
		bool	  is_pf;
		uint8_t	  vf;
		uint8_t	  vqid;
		uint8_t	  vas;
		uint16_t  in_flight_limit;
		uint16_t  aqos_limit;
		uint16_t  fid_limit;
		uint16_t  hid_mask;
		uint8_t	  sn_group;
		uint8_t	  sn_slot;
};
struct pp_t  {
		uint8_t	  pp_id;
		uint8_t	  vpp_id;
		bool	  v;
		bool	  is_ldb;
		bool	  is_hw_dsi;
		bool	  is_pf;
		uint8_t	  vf;
		uint8_t	  pool;
		uint8_t	  vas;
		uint64_t  credit_push_ptr_base_address;
		uint16_t  dir_credit_lwm;
		uint16_t  ldb_credit_lwm;
		uint16_t  dir_credit_quanta;
		uint16_t  ldb_credit_quanta;
		uint16_t  dir_credits;
		uint16_t  ldb_credits;
};
struct pool_t {
		uint8_t	  pool_id;
		bool	  v;
		uint8_t	  vas;
		pp_t	  **ldb_pp;
		pp_t	  **dir_pp;
		uint16_t  ldb_credits;
		uint16_t  dir_credits;
};
struct vas_t {	
		uint8_t	  vas_id;  
		bool	  v;
		qid_t	  **ldb_qid;
		qid_t	  **dir_qid;
		pool_t	  **pool;
};

reorder_group_t	  *reorder_info;
qid_t	  *ldb_qid_info;
cq_qid_map_t	  *ldb_cq_qid_map;
vas_t		  *vas ;
pool_t		  *ldb_pool;
pool_t		  *dir_pool;
qid_t		  *ldb_qid;
qid_t		  *dir_qid;
pp_t		  *ldb_pp;
pp_t		  *dir_pp;
cq_t		  *ldb_cq;
cq_t		  *dir_cq;

class vas_reset_class 
{
private:
    
public:
    vas_reset_class  ();
    ~vas_reset_class ();
};

#endif
