`ifndef HQM_CFG_TYPES__SV
`define HQM_CFG_TYPES__SV


//--AY_HQMV30_ATS_SUPPORT
  //--------------------------------------------------------------------------------------------------------
  // parameter 
  //--------------------------------------------------------------------------------------------------------
parameter  int HQM_IOMMU_MAX_LINEAR_ADDRESS_WIDTH = 57;          // Maximum LA Width that the IOMMU will support in its datapaths
parameter  int HQM_IOMMU_MAX_GUEST_ADDRESS_WIDTH  = 57;          // Maximum GPA Width that the IOMMU will advertise that it can support 
parameter  int HQM_IOMMU_MAX_HOST_ADDRESS_WIDTH   = 52;          // Maximum HPA Width that the IOMMU will support in its datapaths

parameter HQM_IOMMU_HAW = HQM_IOMMU_MAX_HOST_ADDRESS_WIDTH;
parameter HQM_IOMMU_GAW = HQM_IOMMU_MAX_GUEST_ADDRESS_WIDTH;
parameter HQM_IOMMU_LAW = HQM_IOMMU_MAX_LINEAR_ADDRESS_WIDTH;


  //--------------------------------------------------------------------------------------------------------
  // typedefs
  //--------------------------------------------------------------------------------------------------------

typedef enum {
  HQM_CFG_CMD_DONE,
  HQM_CFG_CMD_DONE_NO_CFG_SEQ,
  HQM_CFG_CMD_NOT_DONE
} hqm_command_handler_status_t;

typedef enum {
  HQM_CFG_WRITE,
  HQM_CFG_CWRITE,
  HQM_CFG_BWRITE,
  HQM_CFG_WRITE_ERR,
  HQM_CFG_OWRITE,
  HQM_CFG_OWRITE_ERR,
  HQM_CFG_READ,
  HQM_CFG_BREAD,
  HQM_CFG_READ_ERR,
  HQM_CFG_OREAD,
  HQM_CFG_OREAD_ERR,
  HQM_CFG_POLL,
  HQM_CFG_IDLE,
  HQM_CFG_TEST_DONE,
  HQM_RESETPREP,
  HQM_FORCEPWRGATEPOK,
  HQM_SYSRST_FLR,
  HQM_WARM_RST,
  HQM_PKT_ENQ,
  HQM_SYS_INIT,
  HQM_PF_INIT,
  HQM_VF_INIT,
  HQM_POOL_INIT,
  HQM_RUNTST_GO,
  HQM_CFG_HCW_ENQ,
  HQM_CFG_PRIM_HCW_ENQ,
  HQM_CFG_HCWS_ENQ,
  HQM_CFG_MSIX_ALARM_WAIT,
  HQM_CFG_POLL_SCH
} hqm_cfg_reg_ops_t;

typedef enum {
  TYPE,
  TARGET,
  LABEL,
  OPTIONS
} hqm_cfg_command_state_t;

typedef enum {
  HQM_CFG_LDB,
  HQM_CFG_DIR,
  HQM_CFG_VAS,
  HQM_CFG_VF,
  HQM_CFG_VDEV,
  HQM_CFG_MSIX_CQ,
  HQM_CFG_MSIX_ALARM,
  HQM_CFG_WR_REG,
  HQM_CFG_CWR_REG,
  HQM_CFG_BWR_REG,
  HQM_CFG_WRE_REG,
  HQM_CFG_OWR_REG,
  HQM_CFG_OWRE_REG,
  HQM_CFG_RD_REG,
  HQM_CFG_RDE_REG,
  HQM_CFG_ORD_REG,
  HQM_CFG_ORDE_REG,
  HQM_CFG_BRD_REG,
  HQM_CFG_POLL_REG,
  HQM_CFG_IDLE_REG,
  HQM_CFG_ACCESS_PATH,
  HQM_CFG_PUSH_ACCESS_PATH,
  HQM_CFG_POP_ACCESS_PATH,
  HQM_CFG_FUNC_PF_REG,
  HQM_CFG_CSR_BAR_REG,
  HQM_CFG_FUNC_VF_REG,
  HQM_CFG_TEST_DONE_REG,
  HQM_ASSERT,
  HQM_FORCE,
  HQM_RELEASE,
  HQM_MEM_READ,
  HQM_MEM_WRITE,
  HQM_SAI,
  HQM_CFG_BEGIN,
  HQM_CFG_END,
  HQM_HCW_ENQ,
  HQM_HCWS_ENQ,
  HQM_CFG_VAIABLE,
  HQM_SYSRST,
  HQM_REG_RESET,
  HQM_MSIX_ALARM_WAIT,
  HQM_RUNTEST,
  HQM_CFG_POLL_SCH_REG,
  HQM_PAD_FIRST_WRITE_LDB,
  HQM_PAD_FIRST_WRITE_DIR,
  HQM_PAD_WRITE_DIR,
  HQM_PAD_WRITE_LDB,
  HQM_EARLY_DIR_INT
} hqm_cfg_command_type_t;

typedef string hqm_cfg_command_target_t;

  typedef enum {
    SEQ,
    NON_SEQ,
    CFG_IN_PROGRESS
  } cfg_state_t;
    

  typedef enum bit [3:0] {
    DEPTH_4     = 4'h0,
    DEPTH_8     = 4'h1,
    DEPTH_16    = 4'h2,
    DEPTH_32    = 4'h3,
    DEPTH_64    = 4'h4,
    DEPTH_128   = 4'h5,
    DEPTH_256   = 4'h6,
    DEPTH_512   = 4'h7,
    DEPTH_1024  = 4'h8,
    DEPTH_2048  = 4'h9,
    DEPTH_4096  = 4'ha
  } cq_depth_t;

  typedef enum {
    HQM_PF_MODE,
    HQM_SRIOV_MODE,
    HQM_SCIOV_MODE
  } hqm_iov_mode_t;

  typedef bit [(hqm_pkg::QID_ARCH_WIDTH-1):0]   qid_t;

  typedef bit [(hqm_pkg::CREDITS_WIDTH-1):0]    qed_index_t;
  typedef bit [hqm_pkg::CREDITS_WIDTH:0]        credit_cnt_t;

  typedef struct {
    bit         enq_hcw_q_not_empty;
  } sb_exp_errors_t;

  typedef struct {
    bit         enable;
    bit [63:0]  addr;
    bit [31:0]  data;
    bit         is_ldb;
    int         cq;
  } msi_msix_t;

  typedef struct {
    bit         enable;
    bit [63:0]  addr;
    bit [31:0]  data;
    bit [31:0]  ctrl;
    bit         is_ldb;
    int         cq;
  } ims_prog_t;

  typedef struct {
    bit         enable;
    bit [63:0]  addr;
    bit [31:0]  data;
    bit [31:0]  ctrl;
    bit [7:0]   ims_idx;
  } ims_t;

  typedef struct {
     bit                 qidv;
     qid_t               qid;
     bit [2:0]           pri;
  } cq_qidix_t;

  typedef struct {
     bit [1:0]          en_code;
     bit [3:0]          vf;
     bit [5:0]          vector;
  } cq_isr_t;

  typedef struct {
     bit                keep_pf_ppid;
  } dir_cq_fmt_t;

  typedef struct {
     bit                ill_hcw_cmd;
     bit                ill_hcw_cmd_dir_pp;
     bit                ill_qid; 
     bit                dis_qid; 
     bit                ill_ldbqid; 
     bit                ill_pp; 
     bit                remove_ord_pp;
     bit                unexp_comp;
     bit                ill_comp;
     bit                excess_frag;
     bit                excess_tok;
     bit                unexp_rels;
     bit                unexp_rels_qid;
     bit                drop;
     bit                ooc; 
   } pp_exp_errors_t;

  typedef struct {
     // PP specific fields
     bit                pp_provisioned;
     bit                pp_enable;
     bit [4:0]          vas;
     pp_exp_errors_t    exp_errors;

     // CQ specific fields
     bit                cq_provisioned;
     bit                cq_enable;
     bit                cq_pcq;
     cq_depth_t         cq_depth;
     bit [10:0]         cq_token_count;
     credit_cnt_t       cq_ldb_inflight_limit;
     bit                cq_ldb_inflight_limit_set;
     bit [11:0]         cq_ldb_inflight_thresh; 
     bit                cq_cmpck_ena;
     bit                cq_hl_exp_mode;
     bit [12:0]         hist_list_base;
     bit [12:0]         hist_list_limit;
     bit                cq_depth_intr_ena;
     bit [11:0]         cq_depth_intr_thresh; 
     bit                cq_timer_intr_ena;
     bit [13:0]         cq_timer_intr_thresh;
     bit                cq_cwdt_intr_ena;
     bit [7:0]          cq_cwdt_intr_count;
     dir_cq_fmt_t       dir_cq_fmt;
     cq_isr_t           cq_isr;
     cq_qidix_t         qidix[8];
     bit [63:0]         cq_gpa;       //--HQMV30_ATS: this is virtual address
     bit [63:0]         cq_hpa;       //--HQMV30_ATS: this is physical address
     bit [15:0]         cq_bdf;       //--HQMV30_ATS: 
     HqmAtsPkg::PageSize_t      cq_pagesize;  //--HQMV30_ATS: 
     HqmTxnID_t         cq_txn_id;              //--HQMV30_ATS: {tag[9:0], req_id[15:0]}
     HqmTxnID_t         cq_atsinvreq_txn_id;    //--HQMV30_ATS: {tag[9:0], req_id[15:0]}
     HqmPcieCplStatus_t cq_ats_resp_status; //--HQMV30_ATS: 
     int                cq_ats_req_issued;
     int                cq_ats_resp_returned;
     int                cq_ats_resp_errinj; //--ats response errinj types: 1: r=0/w=0; 2: TBD; 3: data parity error; 4: EP=1; 5: completion status CA/UR/CRS); 
     int                cq_ats_resp_errinj_st; //--ats response errinj status (0: errinj not done; 1: errinj has been issued by HqmIosfMRdCb => pp_cq_base_seq cq_buffer_monitor loop can be terminated by this state to avoid sequence hung)
     int                cq_ats_inv_ctrl;
     int                cq_ats_page_rebuild;
     int                cq_atsinvreq_issued;
     int                cq_atsinvresp_returned;
     int                cq_ats_entry_delete;
     int                wu_limit;
     int                wu_limit_tolerance;
     bit                cq_int_mask;
     bit                cq_irq_pending;

     int                cq_trfctrl;           //-- support VASRESET
     int                cq_int_mask_opt;      //-- 1: start to control pp_cq_hqmproc_seq flow
     int                cq_int_mask_ena;      //-- 1: enable to program cq's mask/unmask
     int                cq_int_mask_run;      //-- 1: cq_int_mask[cq] is reprogrammed, cfgflow set this bit to 1 to allow rearm ; 0: after rearm is done, clear this bit
     int                cq_int_mask_check;    //-- after cq_int_mask[cq] is reprogrammed, set this bit 1 to allow seq check if intr is generated (not expect intr)
     int                cq_int_mask_wait;     //-- when mask=1, seq wait for # cycles before check intr (expect not to see intr); during the waiting, cfg_seq can't change to unmask
     int                cq_irq_pending_check; //-- 1: check pending bit
     int                cq_int_intr_state;    //-- cfg/trf interactive method; 1: seq check intr; 0: wait

     // Common values
     bit                is_pf;
     int                vf;
     int                vpp;
     int                vdev;
     bit [22:0]         pasid;
     bit [1:0]          at;

     // Testbench values
     bit [11:0]         cq_wbcount;
     bit [11:0]         cq_count;
     bit                cq_gen;
     cq_depth_t         cq_token_depth;
     credit_cnt_t       cq_ldb_inflight_count;
     int                cq_totnum;
     int                cq_wb_pad;
     int                disable_wb_opt;
     int                ro;

     // max_cacheline: cacheline count and max number support
     int                cl_check;
     int                cl_rob;
     int                cl_cnt;
     int                cl_max;
     bit [3:0]          cl_addr;

     bit [14:0]         palb_on_thrsh;
     bit [14:0]         palb_off_thrsh;
  } pp_cq_cfg_t;

  typedef struct {
     bit [1:0]          max_bin;
     bit [1:0]          min_bin;
  } qid_clamp_t;

  typedef struct {
    bit [7:0]           not_empty;
    bit [7:0]           ord_not_empty;
    bit [7:0]           remove_ord_q;
    bit [7:0]           ord_out_of_order;
    bit [7:0]           sch_out_of_order;
    bit [7:0]           unexp_atm_comp;
  } qid_exp_errors_t;

  typedef struct {
     bit                provisioned;
     bit                enable;
     bit                qid_its;
     credit_cnt_t       qid_ldb_inflight_count;
     credit_cnt_t       qid_ldb_inflight_limit;
     credit_cnt_t       uno_ord_enq_hcw_rpt_thresh;
     credit_cnt_t       uno_ord_inflight_limit;
     credit_cnt_t       atq_enq_hcw_rpt_thresh;
     credit_cnt_t       atq_inflight_limit;
     credit_cnt_t       dir_enq_hcw_rpt_thresh;
     bit [13:0]         atm_qid_depth_thresh;
     bit [13:0]         nalb_qid_depth_thresh;
     bit [12:0]         dir_qid_depth_thresh;
     bit [10:0]         aqed_freelist_base;
     bit [10:0]         aqed_freelist_limit;
     bit [2:0]          ord_mode;
     bit [4:0]          ord_slot;
     bit [1:0]          ord_grp;
     bit [11:0]         ord_sn;
     bit                ao_cfg_v;
     bit                fid_cfg_v;
     bit                sn_cfg_v;
     int                vqid;
     qid_clamp_t        qid_rlst_clamp;
     qid_exp_errors_t   exp_errors;
     bit [12:0]         fid_limit;
     bit [7:0]          pp;   //--V2_TB only applicable to dirqid
     bit [2:0]          qid_comp_code;
  } qid_cfg_t;

  typedef struct {
     bit                provisioned;
     bit                enable;
     bit [127:0]        ldb_qid_v;
     bit [127:0]        dir_qid_v;
     credit_cnt_t       credit_cnt;
     credit_cnt_t       credit_num;
  } vas_cfg_t;

  typedef struct {
     bit                provisioned;
     bit                enable;
     bit                vpp_v;
     int                pp;
  } vpp_cfg_t;

  typedef struct {
     bit                provisioned;
     bit                enable;
     bit                vqid_v;
     int                qid;
  } vqid_cfg_t;

  typedef struct {
     bit                provisioned;
     bit                enable;
     vpp_cfg_t          ldb_vpp_cfg[hqm_pkg::NUM_LDB_PP];
     vpp_cfg_t          dir_vpp_cfg[hqm_pkg::NUM_DIR_PP];
     vqid_cfg_t         ldb_vqid_cfg[hqm_pkg::NUM_LDB_QID];
     vqid_cfg_t         dir_vqid_cfg[hqm_pkg::NUM_DIR_QID];
     bit                msi_enabled;
     bit [2:0]          msi_multi_msg_en;
     bit [63:0]         msi_addr;
     bit [15:0]         msi_data;
     msi_msix_t         msi_cfg[32];
  } vf_cfg_t;

  typedef struct {
     bit                provisioned;
     bit                enable;
     int                ldb_cq_xlate_qid[hqm_pkg::NUM_LDB_QID]; // if set, translate LDB QIDs on egress
     vqid_cfg_t         ldb_vqid_cfg[hqm_pkg::NUM_LDB_QID];
     vqid_cfg_t         dir_vqid_cfg[hqm_pkg::NUM_DIR_QID];
  } vdev_cfg_t;

  typedef struct {
     bit                dir_cq_timer_on;
     bit                ldb_cq_timer_on;
     bit [7:0]          dir_cq_timer_intrv;
     bit [7:0]          ldb_cq_timer_intrv;
     bit                dir_cwdt_enb;
     bit [27:0]         dir_cwdt_intrv;
     bit [7:0]          dir_cwdt_thresh;
     bit [127:0]        dir_cwdt_disable;
     bit                ldb_cwdt_enb;
     bit [27:0]         ldb_cwdt_intrv;
     bit [7:0]          ldb_cwdt_thresh;
     bit [63:0]         ldb_cwdt_disable;
     int                cwdt_received_cnt;
     int                cwdt_count_num;
  } cialcwdt_cfg_t;

  typedef enum {
    NONE,
    FIXED_VAL_TYPE,
    WILD_CARD_TYPE,
    LIST_TYPE,
    STRING_TYPE,
    RANGE_TYPE
  } opt_randmization_type_t;

  typedef struct {
     longint def_int_vals[];
     string  def_str_vals[];
     opt_randmization_type_t val_type;
 } rand_int_type_t;

 typedef enum bit {
     DIR = 1'b0,
     LDB = 1'b1
 } e_port_type;
`endif
