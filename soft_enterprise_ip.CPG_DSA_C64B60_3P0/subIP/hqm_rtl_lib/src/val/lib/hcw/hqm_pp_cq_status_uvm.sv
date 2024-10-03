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
// File   : hqm_pp_cq_status.sv
//
// Description : hcw sb  
//
// -----------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------- 
//-----------------------------------------------------------------------------------------------------
//-- hqm_pp_cq_status 
//----------------------------------------------------------------------------------------------------- 
//----------------------------------------------------------------------------------------------------- 

class hqm_pp_cq_status extends uvm_object;

  `uvm_object_utils_begin(hqm_pp_cq_status)
  `uvm_object_utils_end

  typedef struct {
    int         enq_cnt;
    int         sch_cnt;
    mailbox     cq_int;
    int         mon_enq_cnt;
    int         mon_sch_cnt;
    mailbox     tokens_avail;
    int         wu_scheduled;
    bit         cq_init_done;
    bit         cq_gen;
    int         cq_index;
    int         cq_buffer_size;
    int         cq_buffer_rdptr;
    bit         force_seq_stop;
    int         exp_excess_tok;
    hcw_transaction ldbtrf_q[$];    
    
    hcw_transaction st_sch_dirtrf_q[$];
    hcw_transaction st_sch_ldbtrf_q[$];    
    int             st_sch_cnt;
    int             st_sch_ckcurrcnt;
    int             st_enqtrf_tocnt;    
    int             st_enqtrf_cnt;
    int             st_enqtrfidle_cnt;
    int             st_enq_cnt;
    int             st_comp_cnt;
    int             st_tok_cnt;
    int             st_comp_num;
    int             st_tok_num;  
    int             st_regenenq_cnt;  
    int             st_regenenqldb_cnt; 
    int             st_regenenqdir_cnt;           
    int             st_sch_16B_cnt;
    int             st_sch_32B_cnt;
    int             st_sch_48B_cnt;
    int             st_sch_64B_cnt;
    int             st_replay_cnt_ena;
    int             st_inflight_thres_ena;
    int             st_inflight_thres;
    int             st_inflight_limit;
    semaphore       st_access_sm ;  
  } pp_cq_status_t;

  typedef struct {
    mailbox     msi_int[32];
    mailbox     pf_to_vf_int;
  } vf_status_t;

  typedef struct {
    mailbox     credits_avail;
    int         credits_count;
  } vas_status_t;

  pp_cq_status_t        dir_pp_cq_status[hqm_pkg::NUM_DIR_PP];
  pp_cq_status_t        ldb_pp_cq_status[hqm_pkg::NUM_LDB_PP];

  mailbox               compressed_msix_cq_int;

  mailbox               msix_int[hqm_system_pkg::HQM_SYSTEM_NUM_MSIX];

  vf_status_t           vf_status[hqm_pkg::NUM_VF];

  vas_status_t          vas_status[hqm_pkg::NUM_VAS];

  int                   seq_list[string];
  int                   pause_bg_cfg_req;
  int                   pause_bg_cfg_ack;

  int                   st_nodec_fid_cnt[2048];
  int                   st_dircq_sch_16B_cnt;
  int                   st_dircq_sch_32B_cnt;
  int                   st_dircq_sch_48B_cnt;
  int                   st_dircq_sch_64B_cnt;
  int                   st_ldbcq_sch_16B_cnt;
  int                   st_ldbcq_sch_32B_cnt;
  int                   st_ldbcq_sch_48B_cnt;
  int                   st_ldbcq_sch_64B_cnt;

  int                   enq_atm_count[bit [7:0]][hqm_pkg::NUM_LDB_QID];
  int                   enq_uno_count[bit [7:0]][hqm_pkg::NUM_LDB_QID];
  int                   enq_ord_count[bit [7:0]][hqm_pkg::NUM_LDB_QID];
  int                   enq_dir_count[bit [7:0]][hqm_pkg::NUM_DIR_QID];
  int                   enq_nodec_count[hqm_pkg::NUM_LDB_QID];
  int                   total_enq_count;
  int                   total_tok_count;
  int                   total_cmp_count;

  int                   dir_arm_count[hqm_pkg::NUM_DIR_CQ];
  int                   ldb_arm_count[hqm_pkg::NUM_LDB_CQ];
  int                   dir_int_count[hqm_pkg::NUM_DIR_CQ];
  int                   ldb_int_count[hqm_pkg::NUM_LDB_CQ];

  int                   rtn_dir_tok_count[hqm_pkg::NUM_DIR_CQ];
  int                   rtn_ldb_tok_count[hqm_pkg::NUM_LDB_CQ];
  int                   rtn_ldb_cmp_count[hqm_pkg::NUM_LDB_CQ];

  int                   sch_atm_count[hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID];
  int                   sch_uno_count[hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID];
  int                   sch_ord_count[hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID];
  int                   sch_dir_count[hqm_pkg::NUM_DIR_CQ][hqm_pkg::NUM_DIR_QID];
  int                   total_sch_count;
  int                   total_sch_err_count;
  int                   replay_oldersn_enq_cnt;

  int tot_ldb_int_num, tot_dir_int_num, tot_int_num;
  int tot_ldb_arm_num, tot_dir_arm_num, tot_arm_num;
  int tot_rtn_ldb_tok_num, tot_rtn_dir_tok_num, tot_rtn_ldb_cmp_num, tot_rtn_tok_num;
  int tot_enq_atm_num, tot_enq_uno_num, tot_enq_ord_num, tot_enq_dir_num, tot_enq_ldb_num, tot_enq_num;
  int tot_sch_atm_num, tot_sch_uno_num, tot_sch_ord_num, tot_sch_dir_num, tot_sch_ldb_num, tot_sch_num;
  int enq_ldb_num[256], enq_dir_num[256];
  int sch_ldb_num[hqm_pkg::NUM_LDB_CQ], sch_dir_num[hqm_pkg::NUM_DIR_CQ];
 

  bit                   seq_manage_credits;
  

  extern                function        new(string name = "hqm_pp_cq_status");

  extern        virtual task            pp_cq_state_update(bit is_ldb, int pp_cq, int new_enq_cnt, int new_sch_cnt);

  extern        virtual function void   set_vas_credits(int vas, int new_credits_avail);
  extern        virtual function void   put_vas_credit(int vas);
  extern        virtual function int    vas_credit_avail(int vas);
  extern        virtual task            wait_for_vas_credit(int vas);

  extern        virtual function void   set_cq_tokens(bit is_ldb, int cq, int cq_buffer_size);
  extern        virtual function void   put_cq_tokens(bit is_ldb, int cq, int num_tokens);
  extern        virtual function void   use_cq_token(bit is_ldb, int cq, int cq_index);
  extern        virtual function void   check_cq_token(bit is_ldb, int cq, int cq_index);
  extern        virtual function int    get_cq_tokens_cnt(bit is_ldb, int cq);

  extern        virtual task            put_cq_int(bit is_ldb, int pp_cq, bit [31:0] data);
  extern        virtual function bit    cq_int_received(bit is_ldb, int pp_cq);
  extern        virtual task            wait_for_cq_int(bit is_ldb, int pp_cq);

  extern        virtual task            put_compressed_msix_cq_int(bit [31:0] data);
  extern        virtual function bit    compressed_msix_cq_int_received();
  extern        virtual task            wait_for_compressed_msix_cq_int();

  extern        virtual task            put_msix_int(int msix, bit [31:0] data);
  extern        virtual function bit    msix_int_received(int msix);
  extern        virtual task            wait_for_msix_int(int msix, output bit [31:0] msix_data);

  extern        virtual task            put_msi_int(int vf_num, int msi, bit [15:0] data);
  extern        virtual function bit    msi_int_received(int vf_num, int msi);
  extern        virtual task            wait_for_msi_int(int vf_num, int msi, output bit [15:0] msi_data);

  extern        virtual task            put_pf_to_vf_int(int vf_num, bit [15:0] data);
  extern        virtual function bit    pf_to_vf_int_received(int vf_num);
  extern        virtual task            wait_for_pf_to_vf_int(int vf_num, output bit [15:0] msi_data);

  extern        virtual function void   seq_active(string seq_name);
  extern        virtual function void   seq_inactive(string seq_name);
  extern        virtual function bit    is_seq_active(string seq_name = "");

  extern        virtual task            add_hcw_to_ldb_cq_bkt(int cq_num, int wu_limit, int wu_limit_tolerance, int has_hqmproc_lspblockwu, hcw_transaction hcw_item);
  extern        virtual task            remove_hcw_from_ldb_cq_bkt(int cq_num);
  extern        virtual task            get_curr_ldbcq_sch_num(int cq_num, output int curr_num);

  extern        virtual task            enq_status_upd(hcw_transaction hcw_item);
  extern        virtual task            sch_status_upd(bit is_ldb, int cq_num, int pf_qid, bit is_error, hcw_transaction hcw_item);
  extern        virtual task            report_status_upd();

  extern        virtual task            st_put_sch_bkt(bit is_ldb, int cq_num, hcw_transaction hcw_item);
  extern        virtual task            st_get_sch_bkt(bit is_ldb, int cq_num, int ctrl_val, ref hcw_transaction hcw_item); 
  extern        virtual task            st_check_rtn_num(bit is_ldb, int cq_num, int ctrl_val, output bit has_tok, bit has_compl, int toknum); 
  
  extern        virtual task            st_add_enqtrf_pkt(bit is_ldb, int cq_num);
  extern        virtual task            st_get_enqtrf_cnt(input bit is_ldb, int cq_num, output int cnt_out, int to_cnt);
  extern        virtual task            st_get_enq_pkt(bit is_ldb, int cq_num, hcw_transaction hcw_item); 

  extern        virtual task            st_upd_rtn_bkt(bit is_ldb, int cq_num, int ctrl_val);  
  extern        virtual task            st_upd_regenenq_cnt(bit is_ldb, int cq_num, int ldb_val);  
  extern        virtual task            st_check_remtokcomp_rpt(bit is_ldb, int cq_num, output int toknum, int compnum); 
  extern        virtual task            st_check_count_rpt(bit is_ldb, int cq_num, output int schcnt, int tokcnt, int compcnt);   
  extern        virtual function        st_trfidle_cnt(bit is_ldb, int cq_num);
  extern        virtual function int    get_trfidle_cnt(bit is_ldb, int cq_num);
  extern        virtual function        st_trfidle_clr(bit is_ldb, int cq_num);
  extern        virtual function void   reset();
  extern        virtual function void   force_seq_stop(bit is_ldb, int cq_num);
  extern        virtual function bit    is_force_seq_stop(bit is_ldb, int cq_num);
  extern        virtual function void   clr_force_seq_stop(bit is_ldb, int cq_num);
  extern        virtual function void   force_all_seq_stop();
  extern        virtual function void   clr_force_all_seq_stop();
    extern        virtual function void   set_seq_manage_credits(bit seq_manage = 1'b1);
endclass
 
//------------------------------------------------------------------------------------
//-- new
//------------------------------------------------------------------------------------
function hqm_pp_cq_status::new (string name = "hqm_pp_cq_status");
    super.new(name);

    foreach (dir_pp_cq_status[i]) begin
      dir_pp_cq_status[i].enq_cnt               = 0;
      dir_pp_cq_status[i].sch_cnt               = 0;
      dir_pp_cq_status[i].mon_enq_cnt           = 0;
      dir_pp_cq_status[i].mon_sch_cnt           = 0;
      dir_pp_cq_status[i].cq_int                = new();
      dir_pp_cq_status[i].tokens_avail          = new();
      dir_pp_cq_status[i].wu_scheduled          = 0;
      dir_pp_cq_status[i].force_seq_stop        = 0;
      dir_pp_cq_status[i].cq_index              = 0;
      dir_pp_cq_status[i].cq_init_done          = 0;
      dir_pp_cq_status[i].cq_gen                = 1;
      dir_pp_cq_status[i].cq_buffer_size        = 0;
      dir_pp_cq_status[i].cq_buffer_rdptr       = 0;
      dir_pp_cq_status[i].exp_excess_tok        = 0;
      dir_pp_cq_status[i].ldbtrf_q.delete();
      dir_pp_cq_status[i].st_sch_dirtrf_q.delete();
      dir_pp_cq_status[i].st_sch_ldbtrf_q.delete();
      dir_pp_cq_status[i].st_replay_cnt_ena     = 0;
      dir_pp_cq_status[i].st_sch_cnt            = 0;
      dir_pp_cq_status[i].st_sch_ckcurrcnt      = 0;
      dir_pp_cq_status[i].st_enqtrf_cnt         = 0;
      dir_pp_cq_status[i].st_enqtrfidle_cnt     = 0;
      dir_pp_cq_status[i].st_enqtrf_tocnt       = 0;      
      dir_pp_cq_status[i].st_enq_cnt            = 0;
      dir_pp_cq_status[i].st_comp_cnt           = 0;
      dir_pp_cq_status[i].st_tok_cnt            = 0;
      dir_pp_cq_status[i].st_comp_num           = 0;
      dir_pp_cq_status[i].st_tok_num            = 0;     
      dir_pp_cq_status[i].st_regenenq_cnt       = 0;  
      dir_pp_cq_status[i].st_regenenqldb_cnt    = 0;
      dir_pp_cq_status[i].st_regenenqdir_cnt    = 0;	 
      dir_pp_cq_status[i].st_sch_16B_cnt        = 0;     
      dir_pp_cq_status[i].st_sch_32B_cnt        = 0;     
      dir_pp_cq_status[i].st_sch_48B_cnt        = 0;     
      dir_pp_cq_status[i].st_sch_64B_cnt        = 0;     
      dir_pp_cq_status[i].st_access_sm          = new ( 1 );  
    end 

    foreach (ldb_pp_cq_status[i]) begin
      ldb_pp_cq_status[i].enq_cnt               = 0;
      ldb_pp_cq_status[i].sch_cnt               = 0;
      ldb_pp_cq_status[i].mon_enq_cnt           = 0;
      ldb_pp_cq_status[i].mon_sch_cnt           = 0;
      ldb_pp_cq_status[i].cq_int                = new();
      ldb_pp_cq_status[i].tokens_avail          = new();
      ldb_pp_cq_status[i].wu_scheduled          = 0;
      ldb_pp_cq_status[i].force_seq_stop        = 0;
      ldb_pp_cq_status[i].cq_index              = 0;
      ldb_pp_cq_status[i].cq_init_done          = 0;
      ldb_pp_cq_status[i].cq_gen                = 1;
      ldb_pp_cq_status[i].cq_buffer_size        = 0;
      ldb_pp_cq_status[i].cq_buffer_rdptr       = 0;
      ldb_pp_cq_status[i].exp_excess_tok        = 0;
      ldb_pp_cq_status[i].ldbtrf_q.delete();
      ldb_pp_cq_status[i].st_sch_dirtrf_q.delete();
      ldb_pp_cq_status[i].st_sch_ldbtrf_q.delete();
      ldb_pp_cq_status[i].st_replay_cnt_ena     = 0;
      ldb_pp_cq_status[i].st_sch_cnt            = 0;
      ldb_pp_cq_status[i].st_sch_ckcurrcnt      = 0;
      ldb_pp_cq_status[i].st_enqtrf_cnt         = 0;
      ldb_pp_cq_status[i].st_enqtrfidle_cnt     = 0;
      ldb_pp_cq_status[i].st_enqtrf_tocnt       = 0;      
      ldb_pp_cq_status[i].st_enq_cnt            = 0;
      ldb_pp_cq_status[i].st_comp_cnt           = 0;
      ldb_pp_cq_status[i].st_tok_cnt            = 0;
      ldb_pp_cq_status[i].st_comp_num           = 0;
      ldb_pp_cq_status[i].st_tok_num            = 0; 
      ldb_pp_cq_status[i].st_regenenq_cnt       = 0;  
      ldb_pp_cq_status[i].st_regenenqldb_cnt    = 0;
      ldb_pp_cq_status[i].st_regenenqdir_cnt    = 0;             
      ldb_pp_cq_status[i].st_sch_16B_cnt        = 0;     
      ldb_pp_cq_status[i].st_sch_32B_cnt        = 0;     
      ldb_pp_cq_status[i].st_sch_48B_cnt        = 0;     
      ldb_pp_cq_status[i].st_sch_64B_cnt        = 0;     
      ldb_pp_cq_status[i].st_inflight_thres_ena = 0;
      ldb_pp_cq_status[i].st_inflight_thres     = 0;
      ldb_pp_cq_status[i].st_inflight_limit     = 0;
      ldb_pp_cq_status[i].st_access_sm          = new ( 1 );            
    end 

    compressed_msix_cq_int                      = new();;

    foreach (msix_int[i]) begin
      msix_int[i]                               = new();
    end 

    foreach (vf_status[i]) begin
      for (int j = 0 ; j < 32 ; j++) begin
        vf_status[i].msi_int[j]                 = new();
      end 

      vf_status[i].pf_to_vf_int                 = new();
    end 

    foreach (vas_status[i]) begin
      vas_status[i].credits_avail               = new();
      vas_status[i].credits_count               = 0;
    end 

    foreach (st_nodec_fid_cnt[i]) begin
      st_nodec_fid_cnt[i]                       = 0;
    end 

    st_dircq_sch_16B_cnt=0;
    st_dircq_sch_32B_cnt=0;
    st_dircq_sch_48B_cnt=0;
    st_dircq_sch_64B_cnt=0;
    st_ldbcq_sch_16B_cnt=0;
    st_ldbcq_sch_32B_cnt=0;
    st_ldbcq_sch_48B_cnt=0;
    st_ldbcq_sch_64B_cnt=0;

    tot_rtn_ldb_tok_num=0;
    tot_rtn_dir_tok_num=0; 
    tot_rtn_ldb_cmp_num=0;
    tot_rtn_tok_num=0;

    tot_ldb_int_num=0; 
    tot_dir_int_num=0;
    tot_ldb_arm_num=0; 
    tot_dir_arm_num=0;

    for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
      ldb_arm_count[cq] = 0;
      ldb_int_count[cq] = 0;
      rtn_ldb_tok_count[cq] = 0;
      rtn_ldb_cmp_count[cq] = 0;
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
         enq_atm_count[cq][qid] = 0;
         enq_uno_count[cq][qid] = 0;
         enq_ord_count[cq][qid] = 0;
         sch_atm_count[cq][qid] = 0;
         sch_uno_count[cq][qid] = 0;
         sch_ord_count[cq][qid] = 0;
      end 
    end 
    for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
      dir_arm_count[cq] = 0;
      dir_int_count[cq] = 0;
      rtn_dir_tok_count[cq] = 0;
      for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
         enq_dir_count[cq][qid] = 0;
         sch_dir_count[cq][qid] = 0;
      end 
    end 

    foreach (enq_nodec_count[i]) begin
      enq_nodec_count[i] = 0;
    end 

    seq_manage_credits = 0;
    total_enq_count = 0;
    total_tok_count = 0;
    total_cmp_count = 0;
    total_sch_count = 0;
    total_sch_err_count = 0;
    replay_oldersn_enq_cnt=0;
endfunction

task hqm_pp_cq_status::pp_cq_state_update(bit is_ldb, int pp_cq, int new_enq_cnt, int new_sch_cnt);
  if (is_ldb) begin
    if ((pp_cq >= 0) || (pp_cq < hqm_pkg::NUM_LDB_PP)) begin
      ldb_pp_cq_status[pp_cq].enq_cnt           = new_enq_cnt;
      ldb_pp_cq_status[pp_cq].sch_cnt           = new_sch_cnt;
      `uvm_info("HQM_PP_CQ_STATUS",$psprintf("pp_cq_state_update() %s PP/CQ 0x%0x enq_cnt=%0d sch_cnt=%0d",is_ldb ? "LDB" : "DIR",pp_cq,new_enq_cnt,new_sch_cnt),UVM_LOW)
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("pp_cq_state_update() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end else begin
    if ((pp_cq >= 0) || (pp_cq < hqm_pkg::NUM_DIR_PP)) begin
      dir_pp_cq_status[pp_cq].enq_cnt           = new_enq_cnt;
      dir_pp_cq_status[pp_cq].sch_cnt           = new_sch_cnt;
      `uvm_info("HQM_PP_CQ_STATUS",$psprintf("pp_cq_state_update() %s PP/CQ 0x%0x enq_cnt=%0d sch_cnt=%0d",is_ldb ? "LDB" : "DIR",pp_cq,new_enq_cnt,new_sch_cnt),UVM_LOW)
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("pp_cq_state_update() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end 
endtask : pp_cq_state_update

function void hqm_pp_cq_status::set_vas_credits(int vas, int new_credits_avail);
  if ((vas < 0) || (vas >= hqm_pkg::NUM_VAS)) begin
    `uvm_error("HQM_PP_CQ_STATUS",$psprintf("set_vas_credit() VAS 0x%0x not valid",vas))
  end else begin
    vas_status[vas].credits_avail = new();
    for (int i = 0 ; i < new_credits_avail ; i++) begin
      vas_status[vas].credits_avail.try_put(vas_status[vas].credits_count++);
    end 

    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("set_vas_credits[%0d]::new_credits_avail=%0d",
                         vas, new_credits_avail), UVM_LOW);
  end 
endfunction

function void hqm_pp_cq_status::put_vas_credit(int vas);
  if ((vas < 0) || (vas >= hqm_pkg::NUM_VAS)) begin
    `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_vas_credit() VAS 0x%0x not valid",vas))
  end else begin
    vas_status[vas].credits_avail.try_put(vas_status[vas].credits_count++);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("put_vas_credit[%0d]::curr_credits_avail=%0d",
                         vas, vas_credit_avail(vas)), UVM_LOW);
  end 
endfunction

function int hqm_pp_cq_status::vas_credit_avail(int vas);
  if ((vas < 0) || (vas >= hqm_pkg::NUM_VAS)) begin
    `uvm_error("HQM_PP_CQ_STATUS",$psprintf("vas_credit_avail() VAS 0x%0x not valid",vas))
    vas_credit_avail  = 0;
  end else begin
    vas_credit_avail  = vas_status[vas].credits_avail.num();
    if(vas_credit_avail==0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("vas_credit_avail[%0d]:: OOC occurred", vas), UVM_LOW);
  end 
endfunction

task hqm_pp_cq_status::wait_for_vas_credit(int vas);
  int my_credit;

  if ((vas < 0) || (vas >= hqm_pkg::NUM_VAS)) begin
    `uvm_error("HQM_PP_CQ_STATUS",$psprintf("wait_for_vas_credit() VAS 0x%0x not valid",vas))
  end else begin
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("wait_for_vas_credit[%0d]::credits_avail=%0d",
                         vas, vas_credit_avail(vas)), UVM_LOW);
    vas_status[vas].credits_avail.get(my_credit);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("wait_for_vas_credit[%0d]::now curr_credits_avail=%0d",
                         vas, vas_credit_avail(vas)), UVM_LOW);
  end 
endtask

function void hqm_pp_cq_status::set_cq_tokens(bit is_ldb, int cq, int cq_buffer_size);
  if (is_ldb) begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_LDB_CQ)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("set_cq_tokens() LDB CQ 0x%0x not valid",cq))
      return;
    end else begin
      ldb_pp_cq_status[cq].cq_buffer_size       = cq_buffer_size;
      ldb_pp_cq_status[cq].cq_buffer_rdptr      = 0;
      ldb_pp_cq_status[cq].tokens_avail         = new();
      ldb_pp_cq_status[cq].cq_index             = 0;
      ldb_pp_cq_status[cq].cq_gen               = 1;
      for (int i = 0 ; i < cq_buffer_size ; i++) begin
        ldb_pp_cq_status[cq].tokens_avail.try_put(1);
      end 
    end 
  end else begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_DIR_CQ)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("set_cq_tokens() DIR CQ 0x%0x not valid",cq))
      return;
    end else begin
      dir_pp_cq_status[cq].cq_buffer_size       = cq_buffer_size;
      dir_pp_cq_status[cq].cq_buffer_rdptr      = 0;
      dir_pp_cq_status[cq].tokens_avail         = new();
      dir_pp_cq_status[cq].cq_index             = 0;
      dir_pp_cq_status[cq].cq_gen               = 1;
      for (int i = 0 ; i < cq_buffer_size ; i++) begin
        dir_pp_cq_status[cq].tokens_avail.try_put(1);
      end 
    end 
  end 

  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("%s CQ 0x%0x set_cq_tokens(is_ldb=%0d,cq=%0d,cq_buffer_size=%0d)",
                       is_ldb ? "LDB" : "DIR", cq, is_ldb, cq, cq_buffer_size), UVM_LOW);
endfunction

function void hqm_pp_cq_status::put_cq_tokens(bit is_ldb, int cq, int num_tokens);
  if (is_ldb) begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_LDB_CQ) || (num_tokens < 0)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() LDB CQ 0x%0x num_tokens=%0d not valid",cq,num_tokens))
      return;
    end else begin
      for (int i = 0 ; i < num_tokens ; i++) begin
        `uvm_info("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() LDB CQ 0x%0x about to return tokens=%0d - curr_tokens=%0d",cq,num_tokens,ldb_pp_cq_status[cq].tokens_avail.num()),UVM_LOW)

        if (ldb_pp_cq_status[cq].tokens_avail.num() == ldb_pp_cq_status[cq].cq_buffer_size) begin
          if($test$plusargs("HQM_EXCESS_TOKEN_RETURN_OK") || ldb_pp_cq_status[cq].exp_excess_tok==1) begin
            `uvm_info("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() LDB CQ 0x%0x number of return tokens=%0d overflows max CQ token count by %0d (expected)",cq,num_tokens,num_tokens - i),UVM_LOW)
          end else begin
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() LDB CQ 0x%0x number of return tokens=%0d overflows max CQ token count by %0d",cq,num_tokens,num_tokens - i))
          end 
          return;
        end else begin
          ldb_pp_cq_status[cq].tokens_avail.try_put(1);
          ldb_pp_cq_status[cq].cq_buffer_rdptr = (ldb_pp_cq_status[cq].cq_buffer_rdptr + 1) % ldb_pp_cq_status[cq].cq_buffer_size;
        end 

        `uvm_info("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() LDB CQ 0x%0x number of return tokens=%0d - now tokens=%0d",cq,num_tokens,ldb_pp_cq_status[cq].tokens_avail.num()),UVM_LOW)
      end 
    end 
  end else begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_DIR_CQ) || (num_tokens < 0)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() DIR CQ 0x%0x num_tokens=%0d not valid",cq,num_tokens))
      return;
    end else begin
      for (int i = 0 ; i < num_tokens ; i++) begin
        if (dir_pp_cq_status[cq].tokens_avail.num() == dir_pp_cq_status[cq].cq_buffer_size) begin
          if($test$plusargs("HQM_EXCESS_TOKEN_RETURN_OK") || dir_pp_cq_status[cq].exp_excess_tok==1) begin
            `uvm_info("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() DIR CQ 0x%0x number of return tokens=%0d overflows max CQ token count by %0d (expected)",cq,num_tokens,num_tokens - i),UVM_LOW)
          end else begin
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_tokens() DIR CQ 0x%0x number of return tokens=%0d overflows max CQ token count by %0d",cq,num_tokens,num_tokens - i))
          end 
          return;
        end else begin
          dir_pp_cq_status[cq].tokens_avail.try_put(1);
          dir_pp_cq_status[cq].cq_buffer_rdptr = (dir_pp_cq_status[cq].cq_buffer_rdptr + 1) % dir_pp_cq_status[cq].cq_buffer_size;
        end 
      end 
    end 
  end 

  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("put_cq_tokens(is_ldb=%0d,cq=%0d,num_tokens=%0d)",
                       is_ldb, cq, num_tokens), UVM_MEDIUM);
endfunction

function void hqm_pp_cq_status::check_cq_token(bit is_ldb, int cq, int cq_index);
  int my_token;
  int tokens_used;

  if (is_ldb) begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_LDB_CQ) || (cq_index < 0) || (cq_index >= ldb_pp_cq_status[cq].cq_buffer_size)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x cq_index=%0d not valid",cq,cq_index))
    end else begin
      if (ldb_pp_cq_status[cq].tokens_avail.num() == 0) begin
          if(ldb_pp_cq_status[cq].exp_excess_tok==1) 
            `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x no tokens available for CQ buffer",cq))
          else
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x no tokens available for CQ buffer exp_excess_tok=%0d",cq, ldb_pp_cq_status[cq].exp_excess_tok))
      end else begin
        tokens_used = ldb_pp_cq_status[cq].cq_buffer_size - ldb_pp_cq_status[cq].tokens_avail.num();

        if ((ldb_pp_cq_status[cq].cq_buffer_rdptr + tokens_used - 1) < ldb_pp_cq_status[cq].cq_buffer_size) begin
          if ((cq_index < ldb_pp_cq_status[cq].cq_buffer_rdptr) ||
              (cq_index > (ldb_pp_cq_status[cq].cq_buffer_rdptr + tokens_used - 1))) begin
            `uvm_info("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x cq_index=%0d valid, rdptr=%0d tokens_used=%0d",cq,cq_index,ldb_pp_cq_status[cq].cq_buffer_rdptr,tokens_used),UVM_MEDIUM)
          end else begin
              if(ldb_pp_cq_status[cq].exp_excess_tok==1) 
                `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,ldb_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
              else
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,ldb_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
          end 
        end else begin
          if ((cq_index < ldb_pp_cq_status[cq].cq_buffer_rdptr) &&
              (cq_index > ((ldb_pp_cq_status[cq].cq_buffer_rdptr + tokens_used - 1) % ldb_pp_cq_status[cq].cq_buffer_size))) begin
            `uvm_info("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x cq_index=%0d valid, rdptr=%0d tokens_used=%0d",cq,cq_index,ldb_pp_cq_status[cq].cq_buffer_rdptr,tokens_used),UVM_MEDIUM)
          end else begin
              if(ldb_pp_cq_status[cq].exp_excess_tok==1) 
                `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,ldb_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
              else
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() LDB CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,ldb_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
          end 
        end 
      end 
    end 
  end else begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_DIR_CQ) || (cq_index < 0) || (cq_index >= dir_pp_cq_status[cq].cq_buffer_size)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x cq_index=%0d not valid",cq,cq_index))
    end else begin
      if (dir_pp_cq_status[cq].tokens_avail.num() == 0) begin
          if(dir_pp_cq_status[cq].exp_excess_tok==1) 
            `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x no tokens available for CQ buffer",cq))
          else
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x no tokens available for CQ buffer exp_excess_tok=%0d",cq, dir_pp_cq_status[cq].exp_excess_tok))
      end else begin
        tokens_used = dir_pp_cq_status[cq].cq_buffer_size - dir_pp_cq_status[cq].tokens_avail.num();

        if ((dir_pp_cq_status[cq].cq_buffer_rdptr + tokens_used - 1) < dir_pp_cq_status[cq].cq_buffer_size) begin
          if ((cq_index < dir_pp_cq_status[cq].cq_buffer_rdptr) ||
              (cq_index > (dir_pp_cq_status[cq].cq_buffer_rdptr + tokens_used - 1))) begin
            `uvm_info("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x cq_index=%0d valid, rdptr=%0d tokens_used=%0d",cq,cq_index,dir_pp_cq_status[cq].cq_buffer_rdptr,tokens_used),UVM_MEDIUM)
          end else begin
              if(dir_pp_cq_status[cq].exp_excess_tok==1) 
                `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,dir_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
              else
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,dir_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
          end 
        end else begin
          if ((cq_index < dir_pp_cq_status[cq].cq_buffer_rdptr) &&
              (cq_index > ((dir_pp_cq_status[cq].cq_buffer_rdptr + tokens_used - 1) % dir_pp_cq_status[cq].cq_buffer_size))) begin
            `uvm_info("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x cq_index=%0d valid, rdptr=%0d tokens_used=%0d",cq,cq_index,dir_pp_cq_status[cq].cq_buffer_rdptr,tokens_used),UVM_MEDIUM)
          end else begin
              if(dir_pp_cq_status[cq].exp_excess_tok==1) 
                `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,dir_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
              else
            `uvm_error("HQM_PP_CQ_STATUS",$psprintf("check_cq_token() DIR CQ 0x%0x cq_index=%0d not valid, rdptr=%0d tokens_used=%0d",cq,cq_index,dir_pp_cq_status[cq].cq_buffer_rdptr,tokens_used))
          end 
        end 
      end 
    end 
  end 

  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("check_cq_token(is_ldb=%0d,cq=%0d,cq_index=%0d)", is_ldb, cq, cq_index), UVM_MEDIUM);
endfunction

function void hqm_pp_cq_status::use_cq_token(bit is_ldb, int cq, int cq_index);
  int my_token;

  if (is_ldb) begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_LDB_CQ) || (cq_index < 0)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("use_cq_token() LDB CQ 0x%0x cq_index=%0d not valid",cq,cq_index))
      return;
    end else begin
      if (ldb_pp_cq_status[cq].tokens_avail.num() == 0) begin
        if(ldb_pp_cq_status[cq].exp_excess_tok==1) 
          `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("use_cq_token() LDB CQ 0x%0x cq_index=%0d no tokens available for CQ buffer",cq,cq_index))
        else
          `uvm_error("HQM_PP_CQ_STATUS",$psprintf("use_cq_token() LDB CQ 0x%0x cq_index=%0d no tokens available for CQ buffer exp_excess_tok=%0d",cq,cq_index, ldb_pp_cq_status[cq].exp_excess_tok))
        return;
      end else begin
        check_cq_token(is_ldb, cq, cq_index);
        ldb_pp_cq_status[cq].tokens_avail.try_get(my_token);
        `uvm_info("HQM_PP_CQ_STATUS",$psprintf("use_cq_token() LDB CQ 0x%0x after get one token - curr_tokens=%0d",cq,ldb_pp_cq_status[cq].tokens_avail.num()),UVM_LOW)
      end 
    end 
  end else begin
    if ((cq < 0) || (cq >= hqm_pkg::NUM_DIR_CQ) || (cq_index < 0)) begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("use_cq_token() DIR CQ 0x%0x cq_index=%0d not valid",cq,cq_index))
      return;
    end else begin
      if (dir_pp_cq_status[cq].tokens_avail.num() == 0) begin
        if(dir_pp_cq_status[cq].exp_excess_tok==1) 
          `uvm_warning("HQM_PP_CQ_STATUS",$psprintf("use_cq_token() DIR CQ 0x%0x cq_index=%0d no tokens available for CQ buffer",cq,cq_index))
        else
          `uvm_error("HQM_PP_CQ_STATUS",$psprintf("use_cq_token() DIR CQ 0x%0x cq_index=%0d no tokens available for CQ buffer exp_excess_tok=%0d",cq,cq_index,dir_pp_cq_status[cq].exp_excess_tok))
        return;
      end else begin
        check_cq_token(is_ldb, cq, cq_index);
        dir_pp_cq_status[cq].tokens_avail.try_get(my_token);
      end 
    end 
  end 

  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("use_cq_token(is_ldb=%0d,cq=%0d,cq_index=%0d)", is_ldb, cq, cq_index), UVM_MEDIUM);
endfunction

function int hqm_pp_cq_status::get_cq_tokens_cnt(bit is_ldb, int cq);

    if (is_ldb) begin
        if ((cq < 0) || (cq >= hqm_pkg::NUM_LDB_CQ)) begin
            `uvm_error("HQM_PP_CQ_STATUS", $psprintf("get_cq_tokens_cnt() LDB CQ 0x%0x not valid", cq))
            return 0;
        end else begin
            return ldb_pp_cq_status[cq].tokens_avail.num();
        end 
    end else begin
        if ((cq < 0) || (cq >= hqm_pkg::NUM_DIR_CQ)) begin
            `uvm_error("HQM_PP_CQ_STATUS", $psprintf("get_cq_tokens_cnt() DIR CQ 0x%0x not valid", cq))
        end else begin
            return dir_pp_cq_status[cq].tokens_avail.num();
        end 
    end 

endfunction : get_cq_tokens_cnt

task hqm_pp_cq_status::put_cq_int(bit is_ldb, int pp_cq, bit [31:0] data);
  if (is_ldb) begin
    if ((pp_cq >= 0) && (pp_cq < hqm_pkg::NUM_LDB_CQ)) begin
      if (ldb_pp_cq_status[pp_cq].cq_int.num() > 0) begin
          //added for multiple MSIX CQ test
        if($test$plusargs("MSIX_CQ_check")) begin
          `uvm_info("HQM_PP_CQ_STATUS",$psprintf(" PP/CQ interrupt already pending"),UVM_LOW)
        end else begin 
          `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_int() %s PP/CQ 0x%0x interrupt already pending",is_ldb ? "LDB" : "DIR",pp_cq))
        end 
      end else begin
        ldb_pp_cq_status[pp_cq].cq_int.put(data);
        ldb_int_count[pp_cq] ++; 
        uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("put_cq_int[%0d][%0d]::cq_int.put:data=0x%0x ldb_int_count[%0d]=%0d", is_ldb, pp_cq, data, pp_cq, ldb_int_count[pp_cq]), UVM_MEDIUM);
      end 
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_int() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end else begin
    if ((pp_cq >= 0) && (pp_cq < hqm_pkg::NUM_DIR_CQ)) begin
      if (dir_pp_cq_status[pp_cq].cq_int.num() > 0) begin
          //added for multiple MSIX CQ test
        if($test$plusargs("MSIX_CQ_check")) begin
          `uvm_info("HQM_PP_CQ_STATUS",$psprintf(" PP/CQ interrupt already pending"),UVM_LOW)
        end else begin 
          `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_int() %s PP/CQ 0x%0x interrupt already pending",is_ldb ? "LDB" : "DIR",pp_cq))
        end 
      end else begin
        dir_pp_cq_status[pp_cq].cq_int.put(data);
        dir_int_count[pp_cq] ++; 
        uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("put_cq_int[%0d][%0d]::cq_int.put:data=0x%0x dir_int_count[%0d]=%0d", is_ldb, pp_cq, data, pp_cq, dir_int_count[pp_cq]), UVM_MEDIUM);
      end 
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_cq_int() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end 
endtask : put_cq_int

function bit hqm_pp_cq_status::cq_int_received(bit is_ldb, int pp_cq);
  bit [31:0]    my_cq_int;

  cq_int_received = 0;

  if (is_ldb) begin
    if ((pp_cq >= 0) && (pp_cq < hqm_pkg::NUM_LDB_CQ)) begin
      if (ldb_pp_cq_status[pp_cq].cq_int.num() > 0) begin
        cq_int_received = 1;
        uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("cq_int_received: %s CQ %0d cq_int.num %0d ldb_int_count[%0d]=%0d",is_ldb ? "LDB" : "DIR", pp_cq, ldb_pp_cq_status[pp_cq].cq_int.num(), pp_cq, ldb_int_count[pp_cq] ), UVM_MEDIUM);
      end else begin
        cq_int_received = 0;
      end 
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("cq_int_received() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end else begin
    if ((pp_cq >= 0) && (pp_cq < hqm_pkg::NUM_DIR_CQ)) begin
      if (dir_pp_cq_status[pp_cq].cq_int.num() > 0) begin
        cq_int_received = 1;
        uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("cq_int_received: %s CQ %0d cq_int.num %0d dir_int_count[%0d]=%0d",is_ldb ? "LDB" : "DIR", pp_cq, dir_pp_cq_status[pp_cq].cq_int.num(), pp_cq, dir_int_count[pp_cq]), UVM_MEDIUM);
      end else begin
        cq_int_received = 0;
      end 
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("cq_int_received() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end 
endfunction : cq_int_received

task hqm_pp_cq_status::wait_for_cq_int(bit is_ldb, int pp_cq);
  bit [31:0]    my_cq_int;

  if (is_ldb) begin
    if ((pp_cq >= 0) && (pp_cq < hqm_pkg::NUM_LDB_CQ)) begin
      ldb_pp_cq_status[pp_cq].cq_int.get(my_cq_int);
      uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("wait_for_cq_int[%0d][%0d]::cq_int.get intr cq_int=0x%0x", is_ldb, pp_cq, my_cq_int), UVM_MEDIUM);
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("wait_for_cq_int() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end else begin
    if ((pp_cq >= 0) && (pp_cq < hqm_pkg::NUM_DIR_CQ)) begin
      dir_pp_cq_status[pp_cq].cq_int.get(my_cq_int);
      uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("wait_for_cq_int[%0d][%0d]::cq_int.get intr cq_int=0x%0x", is_ldb, pp_cq, my_cq_int), UVM_MEDIUM);
    end else begin
      `uvm_error("HQM_PP_CQ_STATUS",$psprintf("wait_for_cq_int() %s PP/CQ 0x%0x not valid",is_ldb ? "LDB" : "DIR",pp_cq))
    end 
  end 
endtask : wait_for_cq_int

task hqm_pp_cq_status::put_compressed_msix_cq_int(bit [31:0] data);
  if (compressed_msix_cq_int.num() > 0) begin
    `uvm_error("HQM_PP_CQ_STATUS","put_compressed_msix_cq_int() interrupt already pending")
  end else begin
    compressed_msix_cq_int.put(data);
  end 
endtask : put_compressed_msix_cq_int

function bit hqm_pp_cq_status::compressed_msix_cq_int_received();
  if (compressed_msix_cq_int.num() > 0) begin
    compressed_msix_cq_int_received = 1;
  end else begin
    compressed_msix_cq_int_received = 0;
  end 
endfunction : compressed_msix_cq_int_received

task hqm_pp_cq_status::wait_for_compressed_msix_cq_int();
  bit [31:0]    my_cq_int;

  compressed_msix_cq_int.get(my_cq_int);
endtask : wait_for_compressed_msix_cq_int

task hqm_pp_cq_status::put_msix_int(int msix, bit [31:0] data);
  if (msix_int[msix].num() > 0) begin
    `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_msix_int(.msix(%0d)) interrupt already pending", msix))
  end else begin
    msix_int[msix].put(data);
  end 
endtask : put_msix_int

function bit hqm_pp_cq_status::msix_int_received(int msix);
  if (msix_int[msix].num() > 0) begin
    msix_int_received = 1;
  end else begin
    msix_int_received = 0;
  end 
endfunction : msix_int_received

task hqm_pp_cq_status::wait_for_msix_int(int msix, output bit [31:0] msix_data);
  msix_int[msix].get(msix_data);
endtask : wait_for_msix_int

task hqm_pp_cq_status::put_msi_int(int vf_num, int msi, bit [15:0] data);
  if (vf_status[vf_num].msi_int[msi].num() > 0) begin
    `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_msi_int(.vf_num(%0d), .msi(%0d)) interrupt already pending", vf_num, msi))
  end else begin
    vf_status[vf_num].msi_int[msi].put(data);
  end 
endtask : put_msi_int

function bit hqm_pp_cq_status::msi_int_received(int vf_num, int msi);
  if (vf_status[vf_num].msi_int[msi].num() > 0) begin
    msi_int_received = 1;
  end else begin
    msi_int_received = 0;
  end 
endfunction : msi_int_received

task hqm_pp_cq_status::wait_for_msi_int(int vf_num, int msi, output bit [15:0] msi_data);
  vf_status[vf_num].msi_int[msi].get(msi_data);
endtask : wait_for_msi_int

task hqm_pp_cq_status::put_pf_to_vf_int(int vf_num, bit [15:0] data);
  if (vf_status[vf_num].pf_to_vf_int.num() > 0) begin
    `uvm_error("HQM_PP_CQ_STATUS",$psprintf("put_pf_to_vf_int(.vf_num(%0d)) interrupt already pending", vf_num))
  end else begin
    vf_status[vf_num].pf_to_vf_int.put(data);
  end 
endtask : put_pf_to_vf_int

function bit hqm_pp_cq_status::pf_to_vf_int_received(int vf_num);
  if (vf_status[vf_num].pf_to_vf_int.num() > 0) begin
    pf_to_vf_int_received = 1;
  end else begin
    pf_to_vf_int_received = 0;
  end 
endfunction : pf_to_vf_int_received

task hqm_pp_cq_status::wait_for_pf_to_vf_int(int vf_num, output bit [15:0] msi_data);
  vf_status[vf_num].pf_to_vf_int.get(msi_data);
endtask : wait_for_pf_to_vf_int

function void   hqm_pp_cq_status::seq_active(string seq_name);
  if (seq_list.exists(seq_name)) begin
    seq_list[seq_name]++;
  end else begin
    seq_list[seq_name] = 1;
  end 
endfunction

function void   hqm_pp_cq_status::seq_inactive(string seq_name);
  if (seq_list.exists(seq_name)) begin
    seq_list[seq_name]--;

    if (seq_list[seq_name] <= 0) begin
      seq_list.delete(seq_name);
    end 
  end else begin
    `uvm_error(get_full_name(),$psprintf("seq_inactive(%s) called with sequence name not active",seq_name))
  end 
endfunction

function bit    hqm_pp_cq_status::is_seq_active(string seq_name = "");
  if (seq_name == "") begin
    if (seq_list.num() > 0) begin
      return(1);
    end else begin
      return(0);
    end 
  end else begin
    if (seq_list.exists(seq_name)) begin
      return(1);
    end else begin
      return(0);
    end 
  end 
endfunction
   
//-----------------------------------------
//-- add_hcw_to_ldb_cq_bkt
//-- capture SCHED HCW and put into buckets
//-----------------------------------------
task hqm_pp_cq_status::add_hcw_to_ldb_cq_bkt(int cq_num, int wu_limit, int wu_limit_tolerance, int has_hqmproc_lspblockwu, hcw_transaction hcw_item);
    int weight_val;
    int cq_limit;
    case(hcw_item.wu)
        0: weight_val=1;
        1: weight_val=2;
        2: weight_val=4;
        3: weight_val=8;
    endcase

       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    

       ldb_pp_cq_status[cq_num].ldbtrf_q.push_back(hcw_item);
       ldb_pp_cq_status[cq_num].wu_scheduled = ldb_pp_cq_status[cq_num].wu_scheduled + weight_val;
       ldb_pp_cq_status[cq_num].st_sch_cnt ++;
       ldb_pp_cq_status[cq_num].st_comp_num ++;
       ldb_pp_cq_status[cq_num].st_tok_num ++;
       
       //--cq_ldb_inflight_threshold[cq_num] checking
       //--#cond1/ when reaches CQ inflight_limit
       //--#then cond2/ if number of completions <= cq_ldb_inlfight_threshold[cq]  ::: LSP contonues scheduling
       //--             if number of completions >  cq_ldb_inlfight_threshold[cq]  ::: LSP stops scheduling
       //--#
       //--# note: setting cq_ldb_inlfight_threshold[cq]>=2048 disables this function
       if(ldb_pp_cq_status[cq_num].st_inflight_thres_ena == 1 && $test$plusargs("HQM_LDB_INFLIGHT_THRES_CHECK") && (ldb_pp_cq_status[cq_num].st_inflight_thres < 2048)) begin
          if(rtn_ldb_cmp_count[cq_num] == (ldb_pp_cq_status[cq_num].st_inflight_limit - ldb_pp_cq_status[cq_num].st_inflight_thres + 1)) begin
             uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("add_hcw_to_ldb_cq_bkt_inflightlimitthresh_CQ%0d:: current rtn_ldb_cmp_count=%0d == (cfg.cq_ldb_inflight_limit=%0d - cfg.cq_ldb_inflight_thresh=%0d + 1)", cq_num, rtn_ldb_cmp_count[cq_num], ldb_pp_cq_status[cq_num].st_inflight_limit, ldb_pp_cq_status[cq_num].st_inflight_thres), UVM_LOW);
          end else begin
             uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("add_hcw_to_ldb_cq_bkt_inflightlimitthresh_CQ%0d:: current rtn_ldb_cmp_count=%0d == (cfg.cq_ldb_inflight_limit=%0d - cfg.cq_ldb_inflight_thresh=%0d + 1)", cq_num, rtn_ldb_cmp_count[cq_num], ldb_pp_cq_status[cq_num].st_inflight_limit, ldb_pp_cq_status[cq_num].st_inflight_thres), UVM_LOW);
          end 
          ldb_pp_cq_status[cq_num].st_inflight_thres_ena = 0;
       end 


       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("add_hcw_to_ldb_cq_bkt_inflightlimitthresh_CQ%0d::tbcnt=%0d qid=0x%0x qtype=%0s lockid=0x%0x; st_sch_cnt=%0d cur_tok_cnt=%0d cur_comp_cnt=%0d; rtn_ldb_cmp_count[%0d]=%0d st_inflight_limit=%0d st_inflight_thres=%0d st_inflight_thres_ena=%0d",
                         cq_num, hcw_item.tbcnt, hcw_item.qid, hcw_item.qtype.name(), hcw_item.lockid, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_cnt, cq_num, rtn_ldb_cmp_count[cq_num], ldb_pp_cq_status[cq_num].st_inflight_limit, ldb_pp_cq_status[cq_num].st_inflight_thres, ldb_pp_cq_status[cq_num].st_inflight_thres_ena), UVM_MEDIUM);

       //--WU
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("add_hcw_to_ldb_cq_bkt_wu_CQ[%0d]::tbcnt=%0d qid=0x%0x wu=%0d weight=%0d qtype=%0s lockid=0x%0x, cfg.ldb_pp_cq_cfg[%0d].wu_limit=%0d, current wu_scheduled=%0d cur_sch_cnt=%0d cur_tok_cnt=%0d cur_comp_cnt=%0d; ldbtrf_q.size=%0d has_hqmproc_lspblockwu=%0d; ",
                         cq_num, hcw_item.tbcnt, hcw_item.qid, hcw_item.wu, weight_val, hcw_item.qtype.name(), hcw_item.lockid, cq_num, wu_limit, ldb_pp_cq_status[cq_num].wu_scheduled, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_cnt, ldb_pp_cq_status[cq_num].ldbtrf_q.size(), has_hqmproc_lspblockwu), UVM_DEBUG);

       if(ldb_pp_cq_status[cq_num].wu_scheduled > (wu_limit + wu_limit_tolerance) && !$test$plusargs("HQM_BYPASS_WU_CK") && has_hqmproc_lspblockwu==0) begin 
          uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("add_hcw_to_ldb_cq_bkt_CQ[%0d]:: current wu_scheduled=%0d exceed cfg.ldb_pp_cq_cfg[%0d].wu_limit=%0d + wu_limit_tolerance=%0d", cq_num, ldb_pp_cq_status[cq_num].wu_scheduled, cq_num, wu_limit, wu_limit_tolerance), UVM_LOW);
       end 

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
  
endtask:add_hcw_to_ldb_cq_bkt

//-----------------------------------------
//-- get_curr_ldbcq_sch_num
//-- capture SCHED HCW and put into buckets
//-----------------------------------------
task hqm_pp_cq_status::get_curr_ldbcq_sch_num(int cq_num, output int curr_num);
     curr_num = ldb_pp_cq_status[cq_num].st_sch_cnt; 
     ldb_pp_cq_status[cq_num].st_sch_ckcurrcnt = ldb_pp_cq_status[cq_num].st_sch_cnt; 
endtask:get_curr_ldbcq_sch_num


//-----------------------------------------  
//-- remove_hcw_from_ldb_cq_bkt
//-- remove entry from queue when completion returned
//-- update wu_scheduled
//-----------------------------------------
task hqm_pp_cq_status::remove_hcw_from_ldb_cq_bkt(int cq_num);
  hcw_transaction hcw_item;
  int weight_val;

       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
       
       if(ldb_pp_cq_status[cq_num].ldbtrf_q.size()>0) begin       
          hcw_item = ldb_pp_cq_status[cq_num].ldbtrf_q[0];        
       
          case(hcw_item.wu)
            0: weight_val=1;
            1: weight_val=2;
            2: weight_val=4;
            3: weight_val=8;
          endcase

          ldb_pp_cq_status[cq_num].wu_scheduled = ldb_pp_cq_status[cq_num].wu_scheduled - weight_val;
          ldb_pp_cq_status[cq_num].st_sch_cnt --;
          ldb_pp_cq_status[cq_num].st_comp_num --;
          //ldb_pp_cq_status[cq_num].st_tok_num ++;
          ldb_pp_cq_status[cq_num].ldbtrf_q.delete(0);  

          uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("remove_hcw_from_ldb_cq_bkt_CQ[%0d]::get hcw tbcnt=%0d qid=0x%0x wu=%0d weight=%0d qtype=%0s lockid=0x%0x, current wu_scheduled=%0d cur_sch_cnt=%0d cur_tok_cnt=%0d cur_comp_cnt=%0d; ldbtrf_q.size=%0d ",
                         cq_num, hcw_item.tbcnt, hcw_item.qid, hcw_item.wu, weight_val, hcw_item.qtype.name(), hcw_item.lockid, ldb_pp_cq_status[cq_num].wu_scheduled, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_cnt, ldb_pp_cq_status[cq_num].ldbtrf_q.size()), UVM_MEDIUM);
       end else begin
          uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("remove_hcw_from_ldb_cq_bkt_CQ[%0d]:: current wu_scheduled=%0d cur_sch_cnt=%0d cur_tok_cnt=%0d cur_comp_cnt=%0d; ldbtrf_q.size=%0d is empty",
                         cq_num, ldb_pp_cq_status[cq_num].wu_scheduled, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_cnt, ldb_pp_cq_status[cq_num].ldbtrf_q.size()), UVM_LOW);
       end       
       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
endtask:remove_hcw_from_ldb_cq_bkt


//-----------------------------------------
//-- enq_status_upd
//-- capture ENQ/RTN HCW and update counters
//-----------------------------------------
task hqm_pp_cq_status::enq_status_upd(hcw_transaction hcw_item);

    if(hcw_item.qe_valid) begin 
       if(hcw_item.qtype==QATM)      enq_atm_count[hcw_item.pp_type_pp][hcw_item.pf_qid] ++;
       else if(hcw_item.qtype==QUNO) enq_uno_count[hcw_item.pp_type_pp][hcw_item.pf_qid] ++;
       else if(hcw_item.qtype==QORD) enq_ord_count[hcw_item.pp_type_pp][hcw_item.pf_qid] ++;
       else if(hcw_item.qtype==QDIR) enq_dir_count[hcw_item.pp_type_pp][hcw_item.pf_qid] ++;
       if(hcw_item.qe_orsp) begin
           if(ldb_pp_cq_status[hcw_item.pp_type_pp[5:0]].st_replay_cnt_ena) replay_oldersn_enq_cnt++;
       end 
       total_enq_count ++;
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRKenq_status_upd::total_enq_count=%0d enq_atm_count[%0d][%0d]=%0d enq_uno_count[%0d][%0d]=%0d enq_ord_count[%0d][%0d]=%0d enq_dir_count[%0d][%0d]=%0d; is_frag %0d replay_oldersn_enq_cnt=%0d; hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s",
                total_enq_count, hcw_item.pp_type_pp,hcw_item.pf_qid,enq_atm_count[hcw_item.pp_type_pp][hcw_item.pf_qid],  hcw_item.pp_type_pp,hcw_item.pf_qid,enq_uno_count[hcw_item.pp_type_pp][hcw_item.pf_qid],  hcw_item.pp_type_pp,hcw_item.pf_qid,enq_ord_count[hcw_item.pp_type_pp][hcw_item.pf_qid], hcw_item.pp_type_pp,hcw_item.pf_qid,enq_dir_count[hcw_item.pp_type_pp][hcw_item.pf_qid], hcw_item.qe_orsp, replay_oldersn_enq_cnt, hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name()), UVM_MEDIUM);
    end 

    if(hcw_item.qe_uhl && hcw_item.is_ldb) begin
       total_cmp_count ++;
       rtn_ldb_cmp_count[hcw_item.pp_type_pp[5:0]] ++;
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRKrtn_cmp_status_upd::rtn_ldb_cmp_count[%0d]=%0d", hcw_item.pp_type_pp[5:0],rtn_ldb_cmp_count[hcw_item.pp_type_pp[5:0]]), UVM_DEBUG);
    end 

    if(hcw_item.qe_valid==0 && hcw_item.qe_orsp && hcw_item.qe_uhl==0 && hcw_item.cq_pop) begin
       if(hcw_item.is_ldb) ldb_arm_count[hcw_item.pp_type_pp[5:0]] ++;
       else                dir_arm_count[hcw_item.pp_type_pp] ++;
    end 

    if(hcw_item.qe_valid && hcw_item.cq_pop) begin
       if(hcw_item.is_ldb) rtn_ldb_tok_count[hcw_item.pp_type_pp[5:0]] ++;
       else                rtn_dir_tok_count[hcw_item.pp_type_pp] ++;
       total_tok_count ++;

       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRKrtn_tok_status_upd::pp_type_pp=0x%0x, rtn_ldb_tok_count[%0d]=%0d rtn_dir_tok_count[%0d]=%0d", hcw_item.pp_type_pp, hcw_item.pp_type_pp[5:0], rtn_ldb_tok_count[hcw_item.pp_type_pp[5:0]], hcw_item.pp_type_pp, rtn_dir_tok_count[hcw_item.pp_type_pp]), UVM_DEBUG);
    end else if(hcw_item.qe_valid==0 && hcw_item.qe_orsp==0 && hcw_item.cq_pop) begin
       if(hcw_item.is_ldb) begin
          rtn_ldb_tok_count[hcw_item.pp_type_pp[5:0]] = rtn_ldb_tok_count[hcw_item.pp_type_pp[5:0]] + hcw_item.lockid + 1;
       end else begin
          rtn_dir_tok_count[hcw_item.pp_type_pp]      = rtn_dir_tok_count[hcw_item.pp_type_pp]      + hcw_item.lockid + 1;
       end 

       total_tok_count = total_tok_count + hcw_item.lockid + 1;

       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRKrtn_tok_status_upd_batt::pp_type_pp=0x%0x,lockid=0x%0x rtn_ldb_tok_count[%0d]=%0d rtn_dir_tok_count[%0d]=%0d", hcw_item.pp_type_pp,hcw_item.lockid, hcw_item.pp_type_pp[5:0], rtn_ldb_tok_count[hcw_item.pp_type_pp[5:0]], hcw_item.pp_type_pp, rtn_dir_tok_count[hcw_item.pp_type_pp]), UVM_DEBUG);
    end 
  
endtask:enq_status_upd


//-----------------------------------------
//-- sch_status_upd
//-- capture SCH HCW and update counters
//-----------------------------------------
task hqm_pp_cq_status::sch_status_upd(bit is_ldb, int cq_num, int pf_qid, bit is_error, hcw_transaction hcw_item);
 
    if(is_ldb) begin
       if(hcw_item.qtype==QATM)      sch_atm_count[cq_num][pf_qid] ++;
       else if(hcw_item.qtype==QUNO) sch_uno_count[cq_num][pf_qid] ++;
       else if(hcw_item.qtype==QORD) sch_ord_count[cq_num][pf_qid] ++;
    end else begin
       sch_dir_count[cq_num][pf_qid] ++;
    end 

    total_sch_count ++;
    if(is_error) total_sch_err_count ++;
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRKsch_status_upd::is_ldb=%0d/cq_num=%0d/pf_qid=%0d, total_sch_count=%0d total_sch_err_count=%0d sch_atm_count[%0d][%0d]=%0d sch_uno_count[%0d][%0d]=%0d sch_ord_count[%0d][%0d]=%0d sch_dir_count[%0d][%0d]=%0d; hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s",
                is_ldb, cq_num, pf_qid, total_sch_count, total_sch_err_count, cq_num,pf_qid,sch_atm_count[cq_num][pf_qid],  cq_num,pf_qid,sch_uno_count[cq_num][pf_qid],  cq_num,pf_qid,sch_ord_count[cq_num][pf_qid], cq_num,pf_qid,sch_dir_count[cq_num][pf_qid], hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name()), UVM_DEBUG);
endtask:sch_status_upd

//-----------------------------------------
//-- report_status_upd
//-----------------------------------------
task hqm_pp_cq_status::report_status_upd();
   int rtn_ldb_tok_num[hqm_pkg::NUM_LDB_CQ], rtn_dir_tok_num[hqm_pkg::NUM_DIR_CQ], rtn_ldb_cmp_num[hqm_pkg::NUM_LDB_CQ];
   int enq_atm_num[256], enq_uno_num[256], enq_ord_num[256];
   int sch_atm_num[hqm_pkg::NUM_LDB_CQ], sch_uno_num[hqm_pkg::NUM_LDB_CQ], sch_ord_num[hqm_pkg::NUM_LDB_CQ];

 
    for (int cq = 0 ; cq < 256 ; cq++) begin
       enq_atm_num[cq] = 0; 
       enq_uno_num[cq] = 0; 
       enq_ord_num[cq] = 0; 
       enq_ldb_num[cq] = 0; 
       enq_dir_num[cq] = 0; 
    end 
    for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
       rtn_dir_tok_num[cq] = 0;
       sch_dir_num[cq] = 0;
    end 
    for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
       rtn_ldb_tok_num[cq] = 0;
       rtn_ldb_cmp_num[cq] = 0;
       sch_atm_num[cq] = 0;
       sch_uno_num[cq] = 0;
       sch_ord_num[cq] = 0;
       sch_ldb_num[cq] = 0;
    end 
    
    tot_arm_num=0;
    tot_int_num=0;
    tot_enq_num=0; 
    tot_sch_num=0; 

    //----------
    //-- ENQ
    for (int cq = 0 ; cq < 256 ; cq++) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
         enq_atm_num[cq] = enq_atm_count[cq][qid] + enq_atm_num[cq];
         enq_uno_num[cq] = enq_uno_count[cq][qid] + enq_uno_num[cq];
         enq_ord_num[cq] = enq_ord_count[cq][qid] + enq_ord_num[cq];
      end 

      if(enq_atm_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::enq_atm_num[%0d]=%0d", cq, enq_atm_num[cq]), UVM_MEDIUM);
      if(enq_uno_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::enq_uno_num[%0d]=%0d", cq, enq_uno_num[cq]), UVM_MEDIUM);
      if(enq_ord_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::enq_ord_num[%0d]=%0d", cq, enq_ord_num[cq]), UVM_MEDIUM);
      enq_ldb_num[cq] = enq_atm_num[cq] + enq_uno_num[cq] + enq_ord_num[cq]; 
      if(enq_ldb_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::enq_ldb_num[%0d]=%0d", cq, enq_ldb_num[cq]), UVM_MEDIUM);
      tot_enq_atm_num = tot_enq_atm_num + enq_atm_num[cq];
      tot_enq_uno_num = tot_enq_uno_num + enq_uno_num[cq];
      tot_enq_ord_num = tot_enq_ord_num + enq_ord_num[cq];
    end 

    for (int cq = 0 ; cq < 256 ; cq++) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
         enq_dir_num[cq] = enq_dir_count[cq][qid] + enq_dir_num[cq];
      end 

      if(enq_dir_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::enq_dir_num[%0d]=%0d", cq, enq_dir_num[cq]), UVM_MEDIUM);
      tot_enq_dir_num = tot_enq_dir_num + enq_dir_num[cq];
    end 

    //--RTN and SCH from DIRCQ
    for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
      rtn_dir_tok_num[cq] = rtn_dir_tok_count[cq];
      tot_dir_arm_num = tot_dir_arm_num + dir_arm_count[cq];
      tot_dir_int_num = tot_dir_int_num + dir_int_count[cq];
      for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
         sch_dir_num[cq] = sch_dir_count[cq][qid] + sch_dir_num[cq];
      end 
      if(dir_arm_count[cq]>0)   uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::dir_arm_num[%0d]=%0d", cq, dir_arm_count[cq]), UVM_MEDIUM);
      if(rtn_dir_tok_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::rtn_dir_tok_num[%0d]=%0d", cq, rtn_dir_tok_num[cq]), UVM_MEDIUM);
      if(sch_dir_num[cq]>0)     uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::sch_dir_num[%0d]=%0d", cq, sch_dir_num[cq]), UVM_MEDIUM);
      tot_rtn_dir_tok_num = tot_rtn_dir_tok_num + rtn_dir_tok_num[cq];
      tot_sch_dir_num     = tot_sch_dir_num     + sch_dir_num[cq];
    end 

    //--RTN and SCH from LDBCQ
    for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
      rtn_ldb_tok_num[cq] = rtn_ldb_tok_count[cq];
      rtn_ldb_cmp_num[cq] = rtn_ldb_cmp_count[cq];
      tot_ldb_arm_num = tot_ldb_arm_num + ldb_arm_count[cq];
      tot_ldb_int_num = tot_ldb_int_num + ldb_int_count[cq];

      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
         sch_atm_num[cq] = sch_atm_count[cq][qid] + sch_atm_num[cq];
         sch_uno_num[cq] = sch_uno_count[cq][qid] + sch_uno_num[cq];
         sch_ord_num[cq] = sch_ord_count[cq][qid] + sch_ord_num[cq];
      end 
      if(ldb_arm_count[cq]>0)   uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::ldb_arm_num[%0d]=%0d", cq, ldb_arm_count[cq]), UVM_MEDIUM);
      if(rtn_ldb_tok_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::rtn_ldb_tok_num[%0d]=%0d", cq, rtn_ldb_tok_num[cq]), UVM_MEDIUM);
      if(rtn_ldb_cmp_num[cq]>0) uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::rtn_ldb_cmp_num[%0d]=%0d", cq, rtn_ldb_cmp_num[cq]), UVM_MEDIUM);
      if(sch_atm_num[cq]>0)     uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::sch_atm_num[%0d]=%0d", cq, sch_atm_num[cq]), UVM_MEDIUM);
      if(sch_uno_num[cq]>0)     uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::sch_uno_num[%0d]=%0d", cq, sch_uno_num[cq]), UVM_MEDIUM);
      if(sch_ord_num[cq]>0)     uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::sch_ord_num[%0d]=%0d", cq, sch_ord_num[cq]), UVM_MEDIUM);
      sch_ldb_num[cq] = sch_atm_num[cq] + sch_uno_num[cq] + sch_ord_num[cq]; 
      if(sch_ldb_num[cq]>0)     uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK::sch_ldb_num[%0d]=%0d", cq, sch_ldb_num[cq]), UVM_MEDIUM);
      tot_rtn_ldb_tok_num = tot_rtn_ldb_tok_num + rtn_ldb_tok_num[cq];
      tot_rtn_ldb_cmp_num = tot_rtn_ldb_cmp_num + rtn_ldb_cmp_num[cq];
      tot_sch_atm_num     = tot_sch_atm_num     + sch_atm_num[cq];
      tot_sch_uno_num     = tot_sch_uno_num     + sch_uno_num[cq];
      tot_sch_ord_num     = tot_sch_ord_num     + sch_ord_num[cq];
    end 

    tot_enq_ldb_num = tot_enq_atm_num + tot_enq_uno_num + tot_enq_ord_num;
    tot_sch_ldb_num = tot_sch_atm_num + tot_sch_uno_num + tot_sch_ord_num;
    tot_enq_num     = tot_enq_dir_num + tot_enq_ldb_num;
    tot_sch_num     = tot_sch_dir_num + tot_sch_ldb_num;
    tot_rtn_tok_num = tot_rtn_dir_tok_num + tot_rtn_ldb_tok_num;
    tot_arm_num     = tot_dir_arm_num + tot_ldb_arm_num;
    tot_int_num     = tot_dir_int_num + tot_ldb_int_num;

    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_num=%0d", tot_enq_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_ldb_num=%0d", tot_enq_ldb_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_dir_num=%0d", tot_enq_dir_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_enq_count=%0d", total_enq_count), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_tok_count=%0d", total_tok_count), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_cmp_count=%0d", total_cmp_count), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_arm_count=%0d", tot_arm_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_int_count=%0d", tot_int_num), UVM_LOW);


    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::tot_sch_num=%0d", tot_sch_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::tot_sch_ldb_num=%0d", tot_sch_ldb_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::tot_sch_dir_num=%0d", tot_sch_dir_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::total_sch_count=%0d", total_sch_count), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::total_sch_err_count=%0d", total_sch_err_count), UVM_LOW);

    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_rtn_tok_num=%0d", tot_rtn_tok_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_rtn_ldb_cmp_num=%0d", tot_rtn_ldb_cmp_num), UVM_LOW);

    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOT::"), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOT::"), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_atm_num=%0d", tot_enq_atm_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_uno_num=%0d", tot_enq_uno_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_ord_num=%0d", tot_enq_ord_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_dir_num=%0d", tot_enq_dir_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_rtn_dir_tok_num=%0d", tot_rtn_dir_tok_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_rtn_ldb_tok_num=%0d", tot_rtn_ldb_tok_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_rtn_ldb_cmp_num=%0d", tot_rtn_ldb_cmp_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_dir_arm_num=%0d", tot_dir_arm_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_ldb_arm_num=%0d", tot_ldb_arm_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_dir_int_num=%0d", tot_dir_int_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTRTN::tot_ldb_int_num=%0d", tot_ldb_int_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::tot_sch_atm_num=%0d", tot_sch_atm_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::tot_sch_uno_num=%0d", tot_sch_uno_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::tot_sch_ord_num=%0d", tot_sch_ord_num), UVM_LOW);
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTSCH::tot_sch_dir_num=%0d", tot_sch_dir_num), UVM_LOW);
 

    //----------------------------------------------
//    if(tot_enq_ldb_num != tot_sch_ldb_num) begin
//        uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_ldb_num=%0d tot_sch_ldb_num=%0d not match", tot_enq_ldb_num, tot_sch_ldb_num), UVM_LOW);
//    end 
//    if(tot_enq_dir_num != tot_sch_dir_num) begin
//        uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::tot_enq_dir_num=%0d tot_sch_dir_num=%0d not match", tot_enq_dir_num, tot_sch_dir_num), UVM_LOW);
//    end 
//
//    if(total_tok_count != total_sch_count) begin
//        uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_tok_count=%0d total_sch_count=%0d not match", total_tok_count, total_sch_count), UVM_LOW);
//    end 
//    if(total_cmp_count != tot_sch_ldb_num) begin
//        uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("TRK_TOTENQ::total_cmp_count=%0d tot_sch_ldb_num=%0d not match", total_cmp_count, tot_sch_ldb_num), UVM_LOW);
//    end 
endtask:report_status_upd

//----------------------------------------------------------------------------------
//---------------------------------------------------------------------------------- 
//-----------------------------------------
//-- st_add_enqtrf_pkt (enq trf seq)
//-----------------------------------------
task hqm_pp_cq_status::st_add_enqtrf_pkt(bit is_ldb, int cq_num);
 

    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;  
       ldb_pp_cq_status[cq_num].st_enqtrf_cnt ++; 
       ldb_pp_cq_status[cq_num].st_enqtrf_tocnt = 0;        
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_add_enqtrf_pkt_ldbPP[%0d]::cur_enq_cnt=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_enqtrf_cnt), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
       dir_pp_cq_status[cq_num].st_enqtrf_cnt ++; 
       dir_pp_cq_status[cq_num].st_enqtrf_tocnt = 0;        
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_add_enqtrf_pkt_dirPP[%0d]::cur_enq_cnt=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_enqtrf_cnt), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end 
  
endtask:st_add_enqtrf_pkt

//-----------------------------------------
//-- st_get_enqtrf_cnt (get enqtrf count st_enqtrf_cnt and st_enqtrf_tocnt)
//-----------------------------------------
task hqm_pp_cq_status::st_get_enqtrf_cnt(input bit is_ldb, int cq_num, output int cnt_out, int to_cnt);
 

    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;  
       cnt_out = ldb_pp_cq_status[cq_num].st_enqtrf_cnt; 
       ldb_pp_cq_status[cq_num].st_enqtrf_tocnt ++;    
       to_cnt = ldb_pp_cq_status[cq_num].st_enqtrf_tocnt;         
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_get_enqtrf_cnt_ldbPP[%0d]::cur_enq_cnt=%0d/to_cnt=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_enqtrf_cnt, ldb_pp_cq_status[cq_num].st_enqtrf_tocnt), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
       cnt_out = dir_pp_cq_status[cq_num].st_enqtrf_cnt; 
       dir_pp_cq_status[cq_num].st_enqtrf_tocnt ++;   
       to_cnt = dir_pp_cq_status[cq_num].st_enqtrf_tocnt;            
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_get_enqtrf_cnt_dirPP[%0d]::cur_enq_cnt=%0d/to_cnt=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_enqtrf_cnt, dir_pp_cq_status[cq_num].st_enqtrf_tocnt), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end 
  
endtask:st_get_enqtrf_cnt

 
//-----------------------------------------
//-- st_get_enq_pkt (get from mon: enq pkt been sent to DUT)
//-----------------------------------------
task hqm_pp_cq_status::st_get_enq_pkt(bit is_ldb, int cq_num, hcw_transaction hcw_item);
 

    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;  
       if(hcw_item.qe_valid == 1)
           ldb_pp_cq_status[cq_num].st_enq_cnt ++; 

       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_get_enq_pkt_ldbPP[%0d]::cur_enq_cnt=%0d; put_hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s/reord=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_enq_cnt, hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name(), hcw_item.reord), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
       if(hcw_item.qe_valid == 1)
          dir_pp_cq_status[cq_num].st_enq_cnt ++; 

       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_get_enq_pkt_dirPP[%0d]::cur_enq_cnt=%0d; put_hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s/reord=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_enq_cnt, hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name(), hcw_item.reord), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end 
  
endtask:st_get_enq_pkt



//-----------------------------------------
//-- st_put_sch_bkt
//-- capture SCHED HCW and put into buckets
//-----------------------------------------
task hqm_pp_cq_status::st_put_sch_bkt(bit is_ldb, int cq_num, hcw_transaction hcw_item);
 

    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    

       ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.push_back(hcw_item);
       ldb_pp_cq_status[cq_num].st_sch_cnt ++;
       ldb_pp_cq_status[cq_num].st_comp_num ++;
       ldb_pp_cq_status[cq_num].st_tok_num ++;
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_put_sch_bkt_ldbCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d/cur_comp_cnt=%0d; rtn_ldb_cmp_count[%0d]=%0d; put_hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s/reord=%0d, current st_sch_ldbtrf_q.size=%0d, st_sch_16B_cnt=%0d/32B_cnt=%0d/48B_cnt=%0d/64B_cnt=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_cnt, cq_num, rtn_ldb_cmp_count[cq_num], hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name(), hcw_item.reord, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size(), ldb_pp_cq_status[cq_num].st_sch_16B_cnt, ldb_pp_cq_status[cq_num].st_sch_32B_cnt, ldb_pp_cq_status[cq_num].st_sch_48B_cnt, ldb_pp_cq_status[cq_num].st_sch_64B_cnt), UVM_MEDIUM);

       //rtn_ldb_cmp_count[cq_num];

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
    
       dir_pp_cq_status[cq_num].st_sch_dirtrf_q.push_back(hcw_item);
       dir_pp_cq_status[cq_num].st_sch_cnt ++;
       dir_pp_cq_status[cq_num].st_tok_num ++;
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_put_sch_bkt_dirCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d; put_hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s/reord=%0d, current st_sch_dirtrf_q.size=%0d, st_sch_16B_cnt=%0d/32B_cnt=%0d/48B_cnt=%0d/64B_cnt=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_sch_cnt, dir_pp_cq_status[cq_num].st_tok_num, hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name(), hcw_item.reord, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size(), dir_pp_cq_status[cq_num].st_sch_16B_cnt, dir_pp_cq_status[cq_num].st_sch_32B_cnt, dir_pp_cq_status[cq_num].st_sch_48B_cnt, dir_pp_cq_status[cq_num].st_sch_64B_cnt), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end 
  
endtask:st_put_sch_bkt

 
//-----------------------------------------  
//-- st_get_sch_bkt
//-- remove entry from queue when ctrl_val=0
//-----------------------------------------
task hqm_pp_cq_status::st_get_sch_bkt(bit is_ldb, int cq_num, int ctrl_val, ref hcw_transaction hcw_item);

    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
       
       if(ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size()>0) begin       
          hcw_item = ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q[0];        
       
          if(ctrl_val==0) begin
            ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.delete(0);  
          end 
          uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_get_sch_bkt_ldbCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d/cur_comp_cnt=%0d; get_hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s/reord=%0d, current st_sch_ldbtrf_q.size=%0d, ctrl_val=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_cnt, ldb_pp_cq_status[cq_num].st_comp_cnt, hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name(), hcw_item.reord, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size(), ctrl_val), UVM_MEDIUM);
       end else begin
          uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("st_get_sch_bkt_ldbCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d/cur_comp_cnt=%0d; st_sch_ldbtrf_q.size=%0d is empty",
                         cq_num, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_cnt, ldb_pp_cq_status[cq_num].st_comp_cnt, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size()), UVM_MEDIUM);
       
       end       
       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
    
       if(dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size()>0) begin     
          hcw_item = dir_pp_cq_status[cq_num].st_sch_dirtrf_q[0];  
           
          if(ctrl_val==0) begin
             dir_pp_cq_status[cq_num].st_sch_dirtrf_q.delete(0); 
          end 
          uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_get_sch_bkt_dirCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d; get_hcw::tbcnt=%0d/qid=0x%0x/lockid=0x%0x/qtype=%0s/reord=%0d, current st_sch_dirtrf_q.size=%0d, ctrl_val=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_sch_cnt, dir_pp_cq_status[cq_num].st_tok_cnt, hcw_item.tbcnt, hcw_item.qid, hcw_item.lockid, hcw_item.qtype.name(), hcw_item.reord, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size(), ctrl_val), UVM_MEDIUM);
       end else begin
          uvm_report_error("HQM_PP_CQ_STATUS", $psprintf("st_get_sch_bkt_dirCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d; st_sch_dirtrf_q.size=%0d is empty",
                         cq_num, dir_pp_cq_status[cq_num].st_sch_cnt, dir_pp_cq_status[cq_num].st_tok_cnt, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size()), UVM_MEDIUM);
       
       end 
       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end 
endtask:st_get_sch_bkt


//-----------------------------------------  
//-- st_check_rtn_num
//-- check available tokens/completion
//-----------------------------------------
task hqm_pp_cq_status::st_check_rtn_num(bit is_ldb, int cq_num, int ctrl_val, output bit has_tok, bit has_compl, int toknum); 
    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ; 
           
       if(ldb_pp_cq_status[cq_num].st_tok_num>0) begin 
          has_tok = 1; 
          toknum  = ldb_pp_cq_status[cq_num].st_tok_num;
       end else begin
          has_tok = 0; 
          toknum  = 0;       
       end        	  	
       
       if(ldb_pp_cq_status[cq_num].st_comp_num>0) begin 
          has_compl = 1;  
       end else begin
          has_compl = 0;     
       end 
                
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_check_rtn_num_ldbCQ[%0d]::has_tok=%0d/toknum=%0d/has_compl=%0d/compnum=%0d, current st_sch_ldbtrf_q.size=%0d",
                         cq_num, has_tok, toknum, has_compl, ldb_pp_cq_status[cq_num].st_comp_num, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size()), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       has_compl = 0;     
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
    
       if(dir_pp_cq_status[cq_num].st_tok_num>0) begin 
          has_tok = 1; 
          toknum  = dir_pp_cq_status[cq_num].st_tok_num;
       end else begin
          has_tok = 0; 
          toknum  = 0;       
       end     
       
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_check_sch_bkt_dirCQ[%0d]::has_tok=%0d/toknum=%0d, current st_sch_dirtrf_q.size=%0d",
                         cq_num, has_tok, toknum, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size()), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end 

endtask:st_check_rtn_num


//-----------------------------------------  
//-- st_upd_rtn_bkt
//-- update number of tok/compl once returns
//-----------------------------------------
task hqm_pp_cq_status::st_upd_rtn_bkt(bit is_ldb, int cq_num, int ctrl_val);
 
    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;  
         
       case(ctrl_val) 
         0: begin 
              ldb_pp_cq_status[cq_num].st_tok_cnt ++;
              ldb_pp_cq_status[cq_num].st_tok_num --;	      
            end	
         1: begin 
              ldb_pp_cq_status[cq_num].st_comp_cnt ++;
              ldb_pp_cq_status[cq_num].st_comp_num --;	      
            end	  
         2: begin
              ldb_pp_cq_status[cq_num].st_comp_cnt ++;
              ldb_pp_cq_status[cq_num].st_tok_cnt ++;
              ldb_pp_cq_status[cq_num].st_comp_num --;	
              ldb_pp_cq_status[cq_num].st_tok_num --;	      	      	  
            end	    
         default: begin  	      
            end	 	        	    	 	 
       endcase
              
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_upd_rtn_bkt_ldbCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d/cur_comp_cnt=%0d; remain_tok_num=%0d/comp_num=%0d, current st_sch_ldbtrf_q.size=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_cnt, ldb_pp_cq_status[cq_num].st_comp_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_num, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size()), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
     
        
       dir_pp_cq_status[cq_num].st_tok_cnt ++;
       dir_pp_cq_status[cq_num].st_tok_num --;	       
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_upd_rtn_bkt_dirCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d; remain_tok=%0d, current st_sch_dirtrf_q.size=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_sch_cnt, dir_pp_cq_status[cq_num].st_tok_cnt, dir_pp_cq_status[cq_num].st_tok_num, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size()), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end  
endtask: st_upd_rtn_bkt


//-----------------------------------------  
//-- st_upd_regenenq_cnt
//-- update number of regened enq
//-----------------------------------------
task hqm_pp_cq_status::st_upd_regenenq_cnt(bit is_ldb, int cq_num, int ldb_val);
 
 
    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;  
         
       case(ldb_val)  
         0: begin 
              ldb_pp_cq_status[cq_num].st_regenenq_cnt ++;
              ldb_pp_cq_status[cq_num].st_regenenqdir_cnt ++;	      
            end	      
         default: begin 
              ldb_pp_cq_status[cq_num].st_regenenq_cnt ++;
              ldb_pp_cq_status[cq_num].st_regenenqldb_cnt ++;	   
            end	 	 
       endcase
              
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_upd_regenenq_cnt_ldbCQ[%0d]::st_regenenq_cnt=%0d/st_regenenqdir_cnt=%0d/st_regenenqldb_cnt=%0d; current st_sch_ldbtrf_q.size=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_regenenq_cnt, ldb_pp_cq_status[cq_num].st_regenenqdir_cnt,	ldb_pp_cq_status[cq_num].st_regenenqldb_cnt, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size()), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
        
       case(ldb_val)  
         0: begin 
              dir_pp_cq_status[cq_num].st_regenenq_cnt ++;
              dir_pp_cq_status[cq_num].st_regenenqdir_cnt ++;	      
            end	      
         default: begin 
              dir_pp_cq_status[cq_num].st_regenenq_cnt ++;
              dir_pp_cq_status[cq_num].st_regenenqldb_cnt ++;	   
            end	 	 
       endcase
       	       
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_upd_regenenq_cnt_dirCQ[%0d]::st_regenenq_cnt=%0d/st_regenenqdir_cnt=%0d/st_regenenqldb_cnt=%0d; current st_sch_dirtrf_q.size=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_regenenq_cnt, dir_pp_cq_status[cq_num].st_regenenqdir_cnt, dir_pp_cq_status[cq_num].st_regenenqldb_cnt, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size()), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end  
endtask:st_upd_regenenq_cnt

     
//-----------------------------------------
//-----------------------------------------        
task hqm_pp_cq_status::st_check_count_rpt(bit is_ldb, int cq_num, output int schcnt, int tokcnt, int compcnt);
    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;  
         
       schcnt = ldb_pp_cq_status[cq_num].st_sch_cnt;
       tokcnt = ldb_pp_cq_status[cq_num].st_tok_cnt;   
       compcnt = ldb_pp_cq_status[cq_num].st_comp_cnt;                   
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_check_schcnt_rpt_ldbCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d/cur_comp_cnt=%0d; remain_tok_num=%0d/comp_num=%0d, current st_sch_ldbtrf_q.size=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_cnt, ldb_pp_cq_status[cq_num].st_comp_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_num, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size()), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
     
       schcnt = dir_pp_cq_status[cq_num].st_sch_cnt;
       tokcnt = dir_pp_cq_status[cq_num].st_tok_cnt;   
       compcnt = 0;                 
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_check_schcnt_rpt_dirCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d; remain_tok=%0d, current st_sch_dirtrf_q.size=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_sch_cnt, dir_pp_cq_status[cq_num].st_tok_cnt, dir_pp_cq_status[cq_num].st_tok_num, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size()), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end   
endtask

//-----------------------------------------
//-----------------------------------------        
task hqm_pp_cq_status::st_check_remtokcomp_rpt(bit is_ldb, int cq_num, output int toknum, int compnum);
    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;  
        
       toknum  = ldb_pp_cq_status[cq_num].st_tok_num;   
       compnum = ldb_pp_cq_status[cq_num].st_comp_num;                        
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_check_schcnt_rpt_ldbCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d/cur_comp_cnt=%0d; remain_tok_num=%0d/comp_num=%0d, current st_sch_ldbtrf_q.size=%0d",
                         cq_num, ldb_pp_cq_status[cq_num].st_sch_cnt, ldb_pp_cq_status[cq_num].st_tok_cnt, ldb_pp_cq_status[cq_num].st_comp_cnt, ldb_pp_cq_status[cq_num].st_tok_num, ldb_pp_cq_status[cq_num].st_comp_num, ldb_pp_cq_status[cq_num].st_sch_ldbtrf_q.size()), UVM_MEDIUM);

       ldb_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ; 
       
    end else begin
       dir_pp_cq_status[cq_num].st_access_sm.get ( 1 ) ;    
      
       toknum  = dir_pp_cq_status[cq_num].st_tok_num;   
       compnum = 0;       
       uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("st_check_schcnt_rpt_dirCQ[%0d]::cur_sch_cnt=%0d/cur_tok_cnt=%0d; remain_tok=%0d, current st_sch_dirtrf_q.size=%0d",
                         cq_num, dir_pp_cq_status[cq_num].st_sch_cnt, dir_pp_cq_status[cq_num].st_tok_cnt, dir_pp_cq_status[cq_num].st_tok_num, dir_pp_cq_status[cq_num].st_sch_dirtrf_q.size()), UVM_MEDIUM);

       dir_pp_cq_status[cq_num].st_access_sm.put ( 1 ) ;    
    end    
endtask

//-----------------------------------------
//-----------------------------------------        
function hqm_pp_cq_status::st_trfidle_cnt(bit is_ldb, int cq_num);
    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_enqtrfidle_cnt ++; 
    end else begin
       dir_pp_cq_status[cq_num].st_enqtrfidle_cnt ++; 
    end 
endfunction: st_trfidle_cnt

function int hqm_pp_cq_status::get_trfidle_cnt(bit is_ldb, int cq_num);
    if(is_ldb) begin
       return ldb_pp_cq_status[cq_num].st_enqtrfidle_cnt; 
    end else begin
       return dir_pp_cq_status[cq_num].st_enqtrfidle_cnt; 
    end 
endfunction: get_trfidle_cnt

//-----------------------------------------
//-----------------------------------------        
function hqm_pp_cq_status::st_trfidle_clr(bit is_ldb, int cq_num);
    if(is_ldb) begin
       ldb_pp_cq_status[cq_num].st_enqtrfidle_cnt = 0; 
    end else begin
       dir_pp_cq_status[cq_num].st_enqtrfidle_cnt = 0; 
    end 
endfunction: st_trfidle_clr

//-----------------------------------------
//-----------------------------------------        
function void hqm_pp_cq_status::force_seq_stop(bit is_ldb, int cq_num);
  if (is_ldb) begin
    if ((cq_num >= 0) && (cq_num < hqm_pkg::NUM_LDB_PP)) begin
      ldb_pp_cq_status[cq_num].force_seq_stop   = 1;
      uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("force_seq_stop ldb_pp_cq_status[%0d].force_seq_stop=1 Done", cq_num), UVM_MEDIUM);
    end else begin
      `uvm_error(get_full_name(),$psprintf("force_seq_stop() LDB CQ 0x%0x not valid",cq_num))
    end 
  end else begin
    if ((cq_num >= 0) && (cq_num < hqm_pkg::NUM_DIR_PP)) begin
      dir_pp_cq_status[cq_num].force_seq_stop   = 1;
      uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("force_seq_stop dir_pp_cq_status[%0d].force_seq_stop=1 Done", cq_num), UVM_MEDIUM);
    end else begin
      `uvm_error(get_full_name(),$psprintf("force_seq_stop() DIR CQ 0x%0x not valid",cq_num))
    end 
  end 
endfunction

function void hqm_pp_cq_status::clr_force_seq_stop(bit is_ldb, int cq_num);
  if (is_ldb) begin
    if ((cq_num >= 0) && (cq_num < hqm_pkg::NUM_LDB_PP)) begin
      ldb_pp_cq_status[cq_num].force_seq_stop   = 0;
      uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("clr_force_seq_stop ldb_pp_cq_status[%0d].force_seq_stop=0 Done", cq_num), UVM_MEDIUM);
    end else begin
      `uvm_error(get_full_name(),$psprintf("clr_force_seq_stop() LDB CQ 0x%0x not valid",cq_num))
    end 
  end else begin
    if ((cq_num >= 0) && (cq_num < hqm_pkg::NUM_DIR_PP)) begin
      dir_pp_cq_status[cq_num].force_seq_stop   = 0;
      uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("clr_force_seq_stop dir_pp_cq_status[%0d].force_seq_stop=0 Done", cq_num), UVM_MEDIUM);
    end else begin
      `uvm_error(get_full_name(),$psprintf("clr_force_seq_stop() DIR CQ 0x%0x not valid",cq_num))
    end 
  end 
endfunction

function bit hqm_pp_cq_status::is_force_seq_stop(bit is_ldb, int cq_num);
  if (is_ldb) begin
    if ((cq_num >= 0) && (cq_num < hqm_pkg::NUM_LDB_PP)) begin
      if (ldb_pp_cq_status[cq_num].force_seq_stop) begin
        return(1);
      end else begin
        return(0);
      end 
    end else begin
      `uvm_error(get_full_name(),$psprintf("is_force_seq_stop() LDB CQ 0x%0x not valid",cq_num))
      return(0);
    end 
  end else begin
    if ((cq_num >= 0) && (cq_num < hqm_pkg::NUM_DIR_PP)) begin
      if (dir_pp_cq_status[cq_num].force_seq_stop) begin
        return(1);
      end else begin
        return(0);
      end 
    end else begin
      `uvm_error(get_full_name(),$psprintf("force_seq_stop() DIR CQ 0x%0x not valid",cq_num))
      return(0);
    end 
  end 
endfunction

function void hqm_pp_cq_status::force_all_seq_stop();
  foreach (ldb_pp_cq_status[cq_num]) begin
      ldb_pp_cq_status[cq_num].force_seq_stop   = 1;
  end 
  foreach (dir_pp_cq_status[cq_num]) begin
      dir_pp_cq_status[cq_num].force_seq_stop   = 1;
  end 
  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("force_all_seq_stop Done"), UVM_MEDIUM);
endfunction

function void hqm_pp_cq_status::clr_force_all_seq_stop();
  foreach (ldb_pp_cq_status[cq_num]) begin
      ldb_pp_cq_status[cq_num].force_seq_stop   = 0;
  end 
  foreach (dir_pp_cq_status[cq_num]) begin
      dir_pp_cq_status[cq_num].force_seq_stop   = 0;
  end 
  uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("clr_force_all_seq_stop Done"), UVM_MEDIUM);
endfunction

function void hqm_pp_cq_status::reset();
    uvm_report_info("HQM_PP_CQ_STATUS", $psprintf("reset() start"), UVM_MEDIUM);
    foreach (vas_status[i]) begin
      vas_status[i].credits_avail               = new();
      vas_status[i].credits_count               = 0;
    end 
    foreach (ldb_pp_cq_status[cq_num]) begin
        ldb_pp_cq_status[cq_num].mon_enq_cnt    = 0;
        ldb_pp_cq_status[cq_num].mon_sch_cnt    = 0;
        ldb_pp_cq_status[cq_num].cq_init_done   = 0;
        ldb_pp_cq_status[cq_num].cq_gen         = 1;
        ldb_pp_cq_status[cq_num].cq_index       = 0;
    end 
    foreach (dir_pp_cq_status[cq_num]) begin
        dir_pp_cq_status[cq_num].mon_enq_cnt = 0;
        dir_pp_cq_status[cq_num].mon_sch_cnt = 0;
        dir_pp_cq_status[cq_num].cq_init_done   = 0;
        dir_pp_cq_status[cq_num].cq_gen         = 1;
        dir_pp_cq_status[cq_num].cq_index       = 0;
    end 
endfunction
 
function void hqm_pp_cq_status::set_seq_manage_credits(bit seq_manage = 1'b1);
  seq_manage_credits = seq_manage;
endfunction
