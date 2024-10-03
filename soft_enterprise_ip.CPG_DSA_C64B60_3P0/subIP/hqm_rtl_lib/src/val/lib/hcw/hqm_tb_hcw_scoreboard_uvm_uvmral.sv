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
// File   : hqm_tb_hcw_scoreboard.sv
//
// Description : hcw sb  
//
// -----------------------------------------------------------------------------

class hqm_tb_hcw_scoreboard extends uvm_scoreboard;

    `uvm_component_utils_begin(hqm_tb_hcw_scoreboard)
    `uvm_component_utils_end

    string              inst_suffix = "";

    //-- hqm_cfg
    hqm_cfg             i_hqm_cfg;

    hqm_pp_cq_status    i_hqm_pp_cq_status;     // common HQM PP/CQ status class

    sla_sm_env      sm;

    protected  bit  disabled_scoreboard;

    uvm_analysis_export #(hcw_transaction)  hcwgen_item_port;
    uvm_tlm_analysis_fifo #(hcw_transaction)    hcwgen_item_fifo;

    uvm_analysis_export #(hcw_transaction)  in_item_port;
    uvm_analysis_export #(hcw_transaction)  out_item_port;
    uvm_tlm_analysis_fifo #(hcw_transaction)    in_item_fifo;
    uvm_tlm_analysis_fifo #(hcw_transaction)    out_item_fifo;
    
    typedef struct {
      hcw_transaction   hcw_q[$];
    } hcw_qid_q_t;

    typedef struct {
      hcw_transaction   hcw_q[$];
      bit [3:0]         qtype_mask_q[$];
    } hcw_ord_qid_q_t;


    typedef struct {
      hcw_transaction   hcw_q[$];
      int               cq;
    } ldb_cq_ord_q_t;



    int                 hcw_sch_atm_count[*];
    int                 hcw_sch_atm_cq[*];
    int                 ldb_sch_atm_qid[hqm_pkg::NUM_LDB_QID][int];

    int                 hcw_sch_comb_count[*];
    int                 hcw_sch_comb_cq[*];

    // -- These flags are used for checking whether enqueue have taken place after the fid limit has been reached
    bit [31:0]          fid_limit;
    bit [31:0]          enq_after_fid_limit;

    typedef struct {
      int               hcw_comp_q[$];
    } ldb_cq_comp_q_t;

    hcw_transaction     trfgen_enqhcw_q[$];
    hcw_transaction     hcw_enq_q[$];

    //--HQMV30 support ROB
    //typedef struct {
    //  hcw_transaction   hcw_q[$];
    //  int               pp_num;
    //} hcw_ingress_q_t;

    //hcw_ingress_q_t     dir_ingress_q[hqm_pkg::NUM_DIR_CQ];
    //hcw_ingress_q_t     ldb_ingress_q[hqm_pkg::NUM_LDB_CQ];


    //--latency
    typedef struct {
      real              lat_q[$];
    } lat_q_t;

    lat_q_t             dir_latency[hqm_pkg::NUM_DIR_CQ][hqm_pkg::NUM_DIR_QID][8];
    lat_q_t             ldb_latency[hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    lat_q_t             ldb_worker_latency[hqm_pkg::NUM_LDB_CQ];

    int                 dir_first_enq_time[hqm_pkg::NUM_DIR_CQ][hqm_pkg::NUM_DIR_QID][8];
    int                 ldb_first_enq_time[hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    int                 dir_last_sch_time[hqm_pkg::NUM_DIR_CQ][hqm_pkg::NUM_DIR_QID][8];
    int                 ldb_first_sch_time[hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    int                 ldb_last_sch_time[hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];

    hcw_qid_q_t         hcw_dir_qid_q[bit [7:0]][hqm_pkg::NUM_DIR_QID][8];
    hcw_qid_q_t         hcw_uno_ldb_qid_q[bit [7:0]][hqm_pkg::NUM_LDB_QID][8];
    hcw_qid_q_t         hcw_atm_ldb_qid_q[bit [7:0]][hqm_pkg::NUM_LDB_QID][8];
    hcw_qid_q_t         hcw_ord1p_ldb_qid_q[bit [7:0]][hqm_pkg::NUM_LDB_QID][8];

    hcw_qid_q_t         hcw_ord2p_dir_qid_q[bit [7:0]][hqm_pkg::NUM_LDB_QID][8];
    hcw_qid_q_t         hcw_ord2p_uno_qid_q[bit [7:0]][hqm_pkg::NUM_LDB_QID][8];
    hcw_qid_q_t         hcw_ord2p_atm_qid_q[bit [7:0]][hqm_pkg::NUM_LDB_QID][8];
    hcw_qid_q_t         hcw_ord2p_ord_qid_q[bit [7:0]][hqm_pkg::NUM_LDB_QID][8];
    hcw_ord_qid_q_t     hcw_ord_ldb_qid_q[hqm_pkg::NUM_LDB_QID][8];

    // Queue of tbcnt (iptr) values in enqueue order
    bit [63:0]          hcw_enq_tbcnt_q[$];

    bit [64:0]          hcw_uno_ldb_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    bit [80:0]          hcw_atm_ldb_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    bit [64:0]          hcw_ord1p_ldb_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    bit [64:0]          hcw_dir_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_DIR_CQ][hqm_pkg::NUM_DIR_QID][8];

    bit [64:0]          hcw_ord2p_uno_ldb_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    bit [80:0]          hcw_ord2p_atm_ldb_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    bit [64:0]          hcw_ord2p_ord_ldb_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_LDB_CQ][hqm_pkg::NUM_LDB_QID][8];
    bit [64:0]          hcw_ord2p_dir_cq_last_tbcnt[bit [7:0]][hqm_pkg::NUM_DIR_CQ][hqm_pkg::NUM_DIR_QID][8];

    ldb_cq_comp_q_t     ldb_cq_comp_q[hqm_pkg::NUM_LDB_CQ];
    ldb_cq_comp_q_t     ldb_cq_a_comp_q[hqm_pkg::NUM_LDB_CQ];

    //--HQMV30 added
    ldb_cq_ord_q_t      ldb_cq_ord_q[hqm_pkg::NUM_LDB_CQ];


    int                 hcw_ldb_cq_hcw_num[hqm_pkg::NUM_LDB_CQ];
    int                 hcw_dir_cq_hcw_num[hqm_pkg::NUM_DIR_CQ];

    int                 HQM_FRAG_MAX;

     extern                   function                new(string name = "hqm_tb_hcw_scoreboard", uvm_component parent = null);
     extern virtual           function void           build_phase(uvm_phase phase);
     extern virtual           function void           connect_phase(uvm_phase phase);
     extern virtual           function void           check_phase(uvm_phase phase);
     extern virtual           function void           report_phase(uvm_phase phase);

     extern virtual           task run_phase (uvm_phase phase); 

     extern virtual protected task get_enq_item_from_hcwgen();
     extern virtual protected task get_enq_item_from_monitor();
     extern virtual protected task get_sch_item_from_monitor();
     
     extern virtual             task set_tbcnt(hcw_transaction hcw_trans, bit is_sch_hcw = 1'b0);
     extern virtual             task set_start_time(hcw_transaction hcw_trans);
     extern virtual             task calc_latency(hcw_transaction hcw_trans,int pf_cq,int pf_qid, bit is_meas, bit [15:0] dsi_ts);
     extern virtual             task process_enq_hcw(hcw_transaction gen_hcw_trans, hcw_transaction enq_hcw_trans);
     extern virtual             task process_sch_hcw(hcw_transaction sch_hcw_trans);
     extern virtual             task check_sch_hcw(hcw_transaction sch_hcw_trans,hcw_transaction enq_hcw_trans);
     extern virtual             task ingress_check(hcw_transaction gen_hcw_trans, hcw_transaction enq_hcw_trans);
     extern virtual             task pp_check(hcw_transaction gen_hcw_trans, hcw_transaction enq_hcw_trans);

     extern virtual             function  bit           remove_from_ord_queue(bit [hqm_pkg::NUM_LDB_QID-1:0] qid, bit [2:0] qpri, hcw_transaction hcw_trans);
     extern virtual             function  bit           check_ord_queue(hcw_transaction hcw_trans_in, output hcw_transaction hcw_trans_out);
     extern virtual             function  bit           check_reord_queue(hcw_transaction hcw_trans_in, int pf_cq, output hcw_transaction hcw_trans_out);
     extern virtual             function  bit           hcw_drop_ok(hcw_transaction hcw_trans);
     extern virtual             function  int           get_hcw_enq_tbcnt_index(bit tbcnt_v, bit [63:0] tbcnt_in, bit rob_check=0, bit [7:0] pp_type_pp=0);
     extern virtual             function  bit           hcw_scoreboard_idle();

     extern virtual             function  bit           hcw_scoreboard_reset();

     extern virtual             function  void          check_qpri_latency(int qid, int qpri_h, real latency_h, int qpri_l, real latency_l);
     extern virtual             function  void          check_cos_latency_in_bin(int bin_num, int qid_num, real ave_latency, real curr_latency, int tolerance_val);
     extern virtual             function  void          check_cos_latency_bins(real ave_latency_0, real ave_latency_1, real ave_latency_2, real ave_latency_3);
     extern virtual             function  void          check_cos_latency_bins_and_report(int expect_same_perf, int bin_num0, int bin_num1, real ave_latency_0, real ave_latency_1, int tolerance_val);
     extern virtual             function  real          calc_latency_val(int latency, int total_count);
     extern virtual             function  void          set_inst_suffix(string new_inst_suffix);

     semaphore       trfgen_enqhcw_access_sm;          /// Protection on trfgen_enqhcw_q access

     semaphore       hcw_ldb_cq_ord_q_access_sm;       // Protect access to ldb_cq_ord_q queue
     semaphore       hcw_ldb_qid_q_access_sm;          // Protect access to hcw_ldb_qid_q queue
     semaphore       hcw_uno_ldb_qid_q_access_sm;      // Protect access to hcw_ldb_qid_q queue
     semaphore       hcw_ord2p_qid_q_access_sm;        // Protect access to hcw_ord2p_<qtype>_qid_q queue

endclass
 
       
//------------------------------------------------------------------------------------
//-- new
//------------------------------------------------------------------------------------
function hqm_tb_hcw_scoreboard::new (string name = "hqm_tb_hcw_scoreboard", uvm_component parent = null);
    super.new(name, parent);

    trfgen_enqhcw_q.delete(); 

    trfgen_enqhcw_access_sm     = new(1); 
    hcw_ldb_cq_ord_q_access_sm  = new(1);
    hcw_ldb_qid_q_access_sm     = new(1);
    hcw_uno_ldb_qid_q_access_sm = new(1);
    hcw_ord2p_qid_q_access_sm   = new(1);

    hcw_scoreboard_reset();

    for(int i=0; i<hqm_pkg::NUM_LDB_CQ; i++)  hcw_ldb_cq_hcw_num[i]=0;
    for(int i=0; i<hqm_pkg::NUM_DIR_CQ; i++) hcw_dir_cq_hcw_num[i]=0;
    HQM_FRAG_MAX = 16;

    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("NUM_LDB_CQ=%0d NUM_DIR_CQ=%0d LDB_QID_WIDTH=%0d DIR_QID_WIDTH=%0d NUM_LDB_PP=%0d NUM_DIR_PP=%0d HQM_FRAG_MAX=%0d",hqm_pkg::NUM_LDB_CQ, hqm_pkg::NUM_DIR_CQ, hqm_pkg::NUM_LDB_PP, hqm_pkg::NUM_DIR_PP,  hqm_pkg::LDB_QID_WIDTH, hqm_pkg::DIR_QID_WIDTH, HQM_FRAG_MAX),UVM_LOW)

endfunction

//------------------------------------------------------------------------------------
//-- build
//------------------------------------------------------------------------------------
function void hqm_tb_hcw_scoreboard::build_phase(uvm_phase phase);
  string inst_name, inst_name0, inst_name1, inst_name2;
  uvm_object  o_tmp;
  hcw_transaction hcw_tmp;

  super.build_phase(phase);
    
  uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Creating Scoreboard"), UVM_DEBUG);

  //-----------------------------
  //-- ports
  //----------------------------- 
  hcwgen_item_port    = new("hcwgen_item_port", this);
  in_item_port        = new("in_item_port", this);
  out_item_port       = new("out_item_port", this);
  hcwgen_item_fifo    = new("hcwgen_item_fifo", this);
  in_item_fifo        = new("in_item_fifo", this);
  out_item_fifo       = new("out_item_fifo", this);

  uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Creating Scoreboard Done"), UVM_DEBUG);
endfunction

//------------------------------------------------------------------------------------
//-- connect
//------------------------------------------------------------------------------------
function void hqm_tb_hcw_scoreboard::connect_phase(uvm_phase phase); 
    uvm_object o_tmp;
  //-----------------------------
  //-- get i_hqm_cfg 
  //----------------------------- 
  if (!uvm_config_object::get(this, "",{"i_hqm_cfg",inst_suffix}, o_tmp)) begin
    uvm_report_fatal("HQM_TB_HCW_SCOREBOARD", "Unable to find i_hqm_cfg object");
  end 

  if (!$cast(i_hqm_cfg, o_tmp)) begin
    uvm_report_fatal("HQM_TB_HCW_SCOREBOARD", $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
  end    

  //-----------------------------
  //-- get i_hqm_pp_cq_status
  //-----------------------------
  if (!uvm_config_object::get(this, "",{"i_hqm_pp_cq_status",inst_suffix}, o_tmp)) begin
    uvm_report_fatal("HQM_TB_HCW_SCOREBOARD", "Unable to find i_hqm_pp_cq_status object");
  end 

  if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
    uvm_report_fatal("HQM_TB_HCW_SCOREBOARD", $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
  end 
    
  `slu_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

  hcwgen_item_port.connect(hcwgen_item_fifo.analysis_export);
  in_item_port.connect(in_item_fifo.analysis_export);
  out_item_port.connect(out_item_fifo.analysis_export);
endfunction

//------------------------------------------------------------------------------------
//-- hcw_scoreboard_idle
//------------------------------------------------------------------------------------
function bit hqm_tb_hcw_scoreboard::hcw_scoreboard_idle();
   uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("hcw_scoreboard_idle: trfgen_enqhcw_q.size=%0d hcw_enq_q=%0d", trfgen_enqhcw_q.size(),hcw_enq_q.size()), UVM_HIGH);
  if (trfgen_enqhcw_q.size() > 0) begin
    hcw_scoreboard_idle = 1'b0;
  end else if (hcw_enq_q.size() == 0) begin
    hcw_scoreboard_idle = 1'b1;
  end else begin
    if (!i_hqm_cfg.sb_exp_errors.enq_hcw_q_not_empty) begin
      hcw_scoreboard_idle = 1'b1;

      foreach (hcw_enq_q[i]) begin
        if (hcw_drop_ok(hcw_enq_q[i]) == 0) begin
          hcw_scoreboard_idle = 0;
          break;
        end 
      end 
    end 
  end 
  uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("hcw_scoreboard_idle: trfgen_enqhcw_q.size=%0d hcw_enq_q=%0d - get hcw_scoreboard_idle=%0d ", trfgen_enqhcw_q.size(),hcw_enq_q.size(),hcw_scoreboard_idle), UVM_HIGH);

endfunction

//------------------------------------------------------------------------------------
//-- hcw_scoreboard_reset
//------------------------------------------------------------------------------------
function bit hqm_tb_hcw_scoreboard::hcw_scoreboard_reset();
  `uvm_info("HQM_TB_HCW_SCOREBOARD","hcw_scoreboard_reset...",UVM_LOW)
  hcw_sch_atm_count.delete();
  hcw_sch_atm_cq.delete();
  
  hcw_sch_comb_count.delete();
  hcw_sch_comb_cq.delete();

  foreach(ldb_sch_atm_qid[qid]) begin
      ldb_sch_atm_qid[qid].delete();
  end 

  trfgen_enqhcw_q.delete();
  hcw_enq_q.delete();
  hcw_enq_tbcnt_q.delete();

  //--HQMV30 ROB
  //foreach(dir_ingress_q[pp]) begin
  //   dir_ingress_q[pp].hcw_q.delete();
  //   dir_ingress_q[pp].pp_num=pp;
  //end 
  //foreach(ldb_ingress_q[pp]) begin
  //   ldb_ingress_q[pp].hcw_q.delete();
  //   ldb_ingress_q[pp].pp_num=pp;
  //end 


  //--
  foreach (hcw_dir_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
          for (int qpri = 0 ; qpri < 8 ; qpri++) begin
              hcw_dir_qid_q[pp][qid][qpri].hcw_q.delete();
          end 
      end 
  end 

  foreach (hcw_uno_ldb_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int qpri = 0 ; qpri < 8 ; qpri++) begin
             hcw_uno_ldb_qid_q[pp][qid][qpri].hcw_q.delete();
          end 
      end 
  end 

  foreach (hcw_atm_ldb_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int qpri = 0 ; qpri < 8 ; qpri++) begin
             hcw_atm_ldb_qid_q[pp][qid][qpri].hcw_q.delete();
          end 
      end 
  end 

  foreach (hcw_ord1p_ldb_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int qpri = 0 ; qpri < 8 ; qpri++) begin
             hcw_ord1p_ldb_qid_q[pp][qid][qpri].hcw_q.delete();
          end 
      end 
  end 

  foreach (hcw_ord2p_dir_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                hcw_ord2p_dir_qid_q[pp][qid][qpri].hcw_q.delete();
                hcw_ord2p_uno_qid_q[pp][qid][qpri].hcw_q.delete();
                hcw_ord2p_atm_qid_q[pp][qid][qpri].hcw_q.delete();
                hcw_ord2p_ord_qid_q[pp][qid][qpri].hcw_q.delete();
          end 
      end 
  end 

  for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
      for (int qpri = 0 ; qpri < 8 ; qpri++) begin
          hcw_ord_ldb_qid_q[qid][qpri].hcw_q.delete();
          hcw_ord_ldb_qid_q[qid][qpri].qtype_mask_q.delete();
      end 
  end 

  for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
          for (int qpri = 0 ; qpri < 8 ; qpri++) begin
              dir_first_enq_time[cq][qid][qpri] = -1;
              dir_last_sch_time[cq][qid][qpri]  = 32'h7fffffff;
          end 
      end 
  end 

  foreach (hcw_dir_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_dir_cq_last_tbcnt[pp][cq][qid][qpri]            = '0;
              end 
          end 
      end 
  end 

  foreach (hcw_ord2p_dir_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_ord2p_dir_cq_last_tbcnt[pp][cq][qid][qpri]            = '0;
              end 
          end 
      end 
  end 

  for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
    ldb_cq_comp_q[cq].hcw_comp_q.delete();
    ldb_cq_a_comp_q[cq].hcw_comp_q.delete();
    ldb_cq_ord_q[cq].hcw_q.delete();

    for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
      for (int qpri = 0 ; qpri < 8 ; qpri++) begin
        ldb_first_enq_time[cq][qid][qpri]               = -1;
        ldb_first_sch_time[cq][qid][qpri]               = -1;
        ldb_last_sch_time[cq][qid][qpri]                = 32'h7fffffff;
      end 
    end 
  end 
 

  foreach (hcw_uno_ldb_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_uno_ldb_cq_last_tbcnt[pp][cq][qid][qpri] = 0;
              end 
          end 
      end 
  end 

  foreach (hcw_atm_ldb_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_atm_ldb_cq_last_tbcnt[pp][cq][qid][qpri] = 0;
              end 
          end 
      end 
  end 

  foreach (hcw_ord1p_ldb_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_ord1p_ldb_cq_last_tbcnt[pp][cq][qid][qpri] = 0;
              end 
          end 
      end 
  end 

  foreach (hcw_ord2p_uno_ldb_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_ord2p_uno_ldb_cq_last_tbcnt[pp][cq][qid][qpri] = 0;
              end 
          end 
      end 
  end 

  foreach (hcw_ord2p_atm_ldb_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_ord2p_atm_ldb_cq_last_tbcnt[pp][cq][qid][qpri] = 0;
              end 
          end 
      end 
  end 

  foreach (hcw_ord2p_ord_ldb_cq_last_tbcnt[pp]) begin
      for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
          for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
              for (int qpri = 0 ; qpri < 8 ; qpri++) begin
                  hcw_ord2p_ord_ldb_cq_last_tbcnt[pp][cq][qid][qpri] = 0;
              end 
          end 
      end 
  end 
endfunction

//------------------------------------------------------------------------------------
//-- hcw_drop_ok
//------------------------------------------------------------------------------------
function bit hqm_tb_hcw_scoreboard::hcw_drop_ok(hcw_transaction hcw_trans);
  int pf_pp;

  hcw_drop_ok = 1;

  pf_pp     = i_hqm_cfg.get_pf_pp(hcw_trans.is_vf,hcw_trans.vf_num,hcw_trans.is_ldb,hcw_trans.ppid,1'b1);

  if (hcw_trans.is_ldb) begin
    if (i_hqm_cfg.ldb_pp_cq_cfg[pf_pp].exp_errors.drop == 0) begin
      hcw_drop_ok = 0;
    end 
  end else begin
    if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.drop == 0) begin
      hcw_drop_ok = 0;
    end 
  end 
endfunction

//------------------------------------------------------------------------------------
//-- get_hcw_enq_tbcnt_index
//------------------------------------------------------------------------------------
function int hqm_tb_hcw_scoreboard::get_hcw_enq_tbcnt_index(bit tbcnt_v, bit [63:0] tbcnt_in, bit rob_check=0, bit [7:0] pp_type_pp=0);
  int idx_l[$];
  int use_tbcnt;
  bit is_ldb;
  int pp_num;

  use_tbcnt=0;
  is_ldb=pp_type_pp[7];
  pp_num=pp_type_pp[6:0];

  //--------------
  //--HQMV30 ROB
  //--------------
  if(is_ldb) begin
   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index:pp_type_pp=0x%0x rob_check=%0d ldb_pp_cq_cfg[%0d].cl_rob=%0d ", pp_type_pp, rob_check, pp_num, i_hqm_cfg.ldb_pp_cq_cfg[pp_num].cl_rob), UVM_HIGH)
  end else begin
   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index:pp_type_pp=0x%0x rob_check=%0d dir_pp_cq_cfg[%0d].cl_rob=%0d ", pp_type_pp, rob_check, pp_num, i_hqm_cfg.dir_pp_cq_cfg[pp_num].cl_rob), UVM_HIGH)
  end 
  
  if(rob_check==1) begin 
     if(is_ldb) begin
        if(i_hqm_cfg.ldb_pp_cq_cfg[pp_num].cl_rob) begin 
           use_tbcnt=1;
           get_hcw_enq_tbcnt_index=tbcnt_in;
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index: is_ldb=%0d pp_num=%0d cl_rob=1 get_hcw_enq_tbcnt_index=0x%0x = tbcnt=0x%0x", is_ldb, pp_num, get_hcw_enq_tbcnt_index, tbcnt_in), UVM_MEDIUM)
        end 
     end else begin
        if(i_hqm_cfg.dir_pp_cq_cfg[pp_num].cl_rob) begin 
           use_tbcnt=1;
           get_hcw_enq_tbcnt_index=tbcnt_in;
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index: is_ldb=%0d pp_num=%0d cl_rob=1 get_hcw_enq_tbcnt_index=0x%0x = tbcnt=0x%0x", is_ldb, pp_num, get_hcw_enq_tbcnt_index, tbcnt_in), UVM_MEDIUM)
        end 
     end 
  end else begin
     use_tbcnt=0;
  end 

  //--------------
  if(use_tbcnt==0) begin
     if (tbcnt_v) begin
        idx_l = hcw_enq_tbcnt_q.find_first_index with ( item == tbcnt_in );  

        if (idx_l.size() > 0 ) begin		  
           get_hcw_enq_tbcnt_index = idx_l[0];

           if (idx_l.size() > 1 ) begin		  
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index: is_ldb=%0d pp_num=%0d tbcnt=0x%0x found %0d times in hcw_enq_tbcnt_q", is_ldb, pp_num, tbcnt_in,idx_l.size()))
           end 
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index: is_ldb=%0d pp_num=%0d get_hcw_enq_tbcnt_index=0x%0x tbcnt_in=0x%0x (use_tbcnt=0)", is_ldb, pp_num, get_hcw_enq_tbcnt_index, tbcnt_in), UVM_MEDIUM)
        end else begin
           `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index: is_ldb=%0d pp_num=%0d Unable to find tbcnt=0x%0x in hcw_enq_tbcnt_q", is_ldb, pp_num, tbcnt_in))
        end 
     end else begin
       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("get_hcw_enq_tbcnt_index: tbcnt_v=%0d", tbcnt_v), UVM_HIGH)
        get_hcw_enq_tbcnt_index = -1;
     end 
  end //if(use_tbcnt==0) 
endfunction

//------------------------------------------------------------------------------------
//-- check
//------------------------------------------------------------------------------------
function void hqm_tb_hcw_scoreboard::check_phase(uvm_phase phase);
  bit check_ok;
  int pf_pp;

  check_ok = 1;

  if (trfgen_enqhcw_q.size() > 0) begin
    `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Generated HCW queue not empty - trfgen_enqhcw_q.size()=%0d",trfgen_enqhcw_q.size()))
     foreach (trfgen_enqhcw_q[i]) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("trfgen_enqhcw_q[%0d].tbcnt=0x%0x ", i, trfgen_enqhcw_q[i].tbcnt), UVM_LOW)
     end 
    check_ok = 0;
  end 

  if ((hcw_enq_q.size() > 0) && !i_hqm_cfg.sb_exp_errors.enq_hcw_q_not_empty) begin
    bit hcw_enq_q_ok;

    hcw_enq_q_ok = 1;

    foreach (hcw_enq_q[i]) begin
      if (hcw_drop_ok(hcw_enq_q[i]) == 0) begin
        hcw_enq_q_ok = 0;
        pf_pp     = i_hqm_cfg.get_pf_pp(hcw_enq_q[i].is_vf,hcw_enq_q[i].vf_num,hcw_enq_q[i].is_ldb,hcw_enq_q[i].ppid,1'b1);
        `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW not dequeued PP <0x%x> iptr <0x%x>",pf_pp, hcw_enq_q[i].iptr))
        break;
      end 
    end 

    if (!hcw_enq_q_ok) begin
      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW queue not empty - hcw_enq_q.size()=%0d",hcw_enq_q.size()))
      check_ok = 0;
    end 
  end 

  foreach (hcw_dir_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
              if ((hcw_dir_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.dir_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                  bit hcw_qid_q_ok;

                  hcw_qid_q_ok = 1;

                  foreach (hcw_dir_qid_q[pp][qid][pri].hcw_q[i]) begin
                    if (hcw_drop_ok(hcw_dir_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                      hcw_qid_q_ok = 0;
                      break;
                    end 
                  end 

                  if (!hcw_qid_q_ok) begin
                    `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW DIR QID 0x%0X qpri %0d queue not empty - hcw_dir_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, pp, qid,pri,hcw_dir_qid_q[pp][qid][pri].hcw_q.size()))
                    check_ok = 0;
                  end 
              end 
          end 
      end 
  end 

  for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
    for (int pri = 0 ; pri < 8 ; pri++) begin
      if ((hcw_ord_ldb_qid_q[qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.ord_not_empty[pri]) begin
        bit hcw_qid_q_ok;

        hcw_qid_q_ok = 1;

        foreach (hcw_ord_ldb_qid_q[qid][pri].hcw_q[i]) begin
          if (hcw_drop_ok(hcw_ord_ldb_qid_q[qid][pri].hcw_q[i]) == 0) begin
            hcw_qid_q_ok = 0;
            break;
          end 
        end 

        if (!hcw_qid_q_ok) begin
          `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW ORD LDB QID 0x%0X qpri %0d queue not empty - hcw_ord_ldb_qid_q[0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri,qid,pri,hcw_ord_ldb_qid_q[qid][pri].hcw_q.size()))

           for(int k=0; k<hcw_ord_ldb_qid_q[qid][pri].hcw_q.size(); k++) 
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW ORD LDB QID 0x%0X qpri %0d queue  hcw_ord_ldb_qid_q[0x%0x][0x%0x].hcw_q[%0d].tbcnt=0x%0x",qid,pri,qid,pri,k,hcw_ord_ldb_qid_q[qid][pri].hcw_q[k].tbcnt), UVM_LOW)
                   
          check_ok = 0;
        end 
      end 
    end 
  end 

  foreach (hcw_uno_ldb_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
             if ((hcw_uno_ldb_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                 bit hcw_qid_q_ok;

                 hcw_qid_q_ok = 1;

                 foreach (hcw_uno_ldb_qid_q[pp][qid][pri].hcw_q[i]) begin
                   if (hcw_drop_ok(hcw_uno_ldb_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                     hcw_qid_q_ok = 0;
                     break;
                   end 
                 end 

                 if (!hcw_qid_q_ok) begin
                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d qtype %0s queue not empty - hcw_uno_ldb_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, "UNO", pp, qid,pri,hcw_uno_ldb_qid_q[pp][qid][pri].hcw_q.size()))
                   check_ok = 0;
                 end 
             end 
          end 
      end 
  end 

  foreach (hcw_atm_ldb_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
             if ((hcw_atm_ldb_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                 bit hcw_qid_q_ok;

                 hcw_qid_q_ok = 1;

                 foreach (hcw_atm_ldb_qid_q[pp][qid][pri].hcw_q[i]) begin
                   if (hcw_drop_ok(hcw_atm_ldb_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                     hcw_qid_q_ok = 0;
                     break;
                   end 
                 end 

                 if (!hcw_qid_q_ok) begin
                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d qtype %0s queue not empty - hcw_atm_ldb_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, "ATM", pp, qid,pri,hcw_atm_ldb_qid_q[pp][qid][pri].hcw_q.size()))

                    for(int k=0; k<hcw_atm_ldb_qid_q[pp][qid][pri].hcw_q.size(); k++) 
                       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d queue  hcw_atm_ldb_qid_q[0x%0x][0x%0x][0x%0x].hcw_q[%0d].tbcnt=0x%0x",qid,pri,pp,qid,pri,k,hcw_atm_ldb_qid_q[pp][qid][pri].hcw_q[k].tbcnt), UVM_LOW)

                   check_ok = 0;
                 end 
             end 
          end 
      end 
  end 

  foreach (hcw_ord1p_ldb_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
             if ((hcw_ord1p_ldb_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                 bit hcw_qid_q_ok;

                 hcw_qid_q_ok = 1;

                 foreach (hcw_ord1p_ldb_qid_q[pp][qid][pri].hcw_q[i]) begin
                   if (hcw_drop_ok(hcw_ord1p_ldb_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                     hcw_qid_q_ok = 0;
                     break;
                   end 
                 end 

                 if (!hcw_qid_q_ok) begin
                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d qtype %0s queue not empty - hcw_ord1p_ldb_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, "UNO", pp, qid,pri,hcw_ord1p_ldb_qid_q[pp][qid][pri].hcw_q.size()))
                   check_ok = 0;
                 end 
             end 
          end 
      end 
  end 

  foreach (hcw_ord2p_dir_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
                 if ((hcw_ord2p_dir_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                    bit hcw_qid_q_ok;

                    hcw_qid_q_ok = 1;

                    foreach (hcw_ord2p_dir_qid_q[pp][qid][pri].hcw_q[i]) begin
                      if (hcw_drop_ok(hcw_ord2p_dir_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                        hcw_qid_q_ok = 0;
                        break;
                      end 
                    end 

                    if (!hcw_qid_q_ok) begin
                      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d qtype %0s queue not empty - hcw_ord2p_dir_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, "DIR", pp, qid,pri,hcw_ord2p_dir_qid_q[pp][qid][pri].hcw_q.size()))
                      check_ok = 0;
                    end 
                end 
          end 
      end 
  end 

  foreach (hcw_ord2p_uno_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
                 if ((hcw_ord2p_uno_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                    bit hcw_qid_q_ok;

                    hcw_qid_q_ok = 1;

                    foreach (hcw_ord2p_uno_qid_q[pp][qid][pri].hcw_q[i]) begin
                      if (hcw_drop_ok(hcw_ord2p_uno_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                        hcw_qid_q_ok = 0;
                        break;
                      end 
                    end 

                    if (!hcw_qid_q_ok) begin
                      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d qtype %0s queue not empty - hcw_ord2p_uno_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, "UNO", pp, qid,pri,hcw_ord2p_uno_qid_q[pp][qid][pri].hcw_q.size()))
                      check_ok = 0;
                    end 
                end 
          end 
      end 
  end 

  foreach (hcw_ord2p_atm_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
                 if ((hcw_ord2p_atm_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                    bit hcw_qid_q_ok;

                    hcw_qid_q_ok = 1;

                    foreach (hcw_ord2p_atm_qid_q[pp][qid][pri].hcw_q[i]) begin
                      if (hcw_drop_ok(hcw_ord2p_atm_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                        hcw_qid_q_ok = 0;
                        break;
                      end 
                    end 

                    if (!hcw_qid_q_ok) begin
                      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d qtype %0s queue not empty - hcw_ord2p_atm_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, "ATM", pp, qid,pri,hcw_ord2p_atm_qid_q[pp][qid][pri].hcw_q.size()))
                      check_ok = 0;
                    end 
                end 
          end 
      end 
  end 

  foreach (hcw_ord2p_ord_qid_q[pp]) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
          for (int pri = 0 ; pri < 8 ; pri++) begin
                 if ((hcw_ord2p_ord_qid_q[pp][qid][pri].hcw_q.size() > 0) && !i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.not_empty[pri]) begin
                    bit hcw_qid_q_ok;

                    hcw_qid_q_ok = 1;

                    foreach (hcw_ord2p_ord_qid_q[pp][qid][pri].hcw_q[i]) begin
                      if (hcw_drop_ok(hcw_ord2p_ord_qid_q[pp][qid][pri].hcw_q[i]) == 0) begin
                        hcw_qid_q_ok = 0;
                        break;
                      end 
                    end 

                    if (!hcw_qid_q_ok) begin
                      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Enqueued HCW LDB QID 0x%0X qpri %0d qtype %0s queue not empty - hcw_ord2p_ord_qid_q[0x%0x][0x%0x][0x%0x].hcw_q.size()=%0d",qid,pri, "ORD", pp, qid,pri,hcw_ord2p_ord_qid_q[pp][qid][pri].hcw_q.size()))
                      check_ok = 0;
                    end 
                end 
          end 
      end 
  end 

  if (check_ok) begin
    `uvm_info("HQM_TB_HCW_SCOREBOARD","check() passed all hcw scoreboard checks!",UVM_LOW)
  end 
endfunction

//------------------------------------------------------------------------------------
//-- report
//------------------------------------------------------------------------------------
function void hqm_tb_hcw_scoreboard::report_phase(uvm_phase phase);
  real          dir_qid_first_enq_time[hqm_pkg::NUM_DIR_QID][8];
  real          dir_qid_last_sch_time[hqm_pkg::NUM_DIR_QID][8];
  int           dir_qid_total_latency[hqm_pkg::NUM_DIR_QID][8];
  int           dir_qid_min_latency[hqm_pkg::NUM_DIR_QID][8];
  int           dir_qid_max_latency[hqm_pkg::NUM_DIR_QID][8];
  int           dir_qid_total_count[hqm_pkg::NUM_DIR_QID][8];
  real          ldb_qid_first_enq_time[hqm_pkg::NUM_LDB_QID][8];
  real          ldb_qid_last_sch_time[hqm_pkg::NUM_LDB_QID][8];
  real          ldb_qid_throughput[hqm_pkg::NUM_LDB_QID][8];
  int           ldb_qid_total_latency[hqm_pkg::NUM_LDB_QID][8];
  int           ldb_qid_min_latency[hqm_pkg::NUM_LDB_QID][8];
  int           ldb_qid_max_latency[hqm_pkg::NUM_LDB_QID][8];
  int           ldb_qid_total_count[hqm_pkg::NUM_LDB_QID][8];
  real          dir_qpri_first_enq_time[8];
  real          dir_qpri_last_sch_time[8];
  longint       dir_qpri_total_latency[8];
  int           dir_qpri_min_latency[8];
  int           dir_qpri_max_latency[8];
  longint       dir_qpri_total_count[8];
  real          ldb_qpri_first_enq_time[8];
  real          ldb_qpri_last_sch_time[8];
  longint       ldb_qpri_total_latency[8];
  int           ldb_qpri_min_latency[8];
  int           ldb_qpri_max_latency[8];
  longint       ldb_qpri_total_count[8];
  real          dir_cq_first_enq_time[hqm_pkg::NUM_DIR_CQ];
  real          dir_cq_last_sch_time[hqm_pkg::NUM_DIR_CQ];
  int           dir_cq_total_latency[hqm_pkg::NUM_DIR_CQ];
  int           dir_cq_min_latency[hqm_pkg::NUM_DIR_CQ];
  int           dir_cq_max_latency[hqm_pkg::NUM_DIR_CQ];
  int           dir_cq_total_count[hqm_pkg::NUM_DIR_CQ];
  real          ldb_cq_first_enq_time[hqm_pkg::NUM_LDB_CQ];
  real          ldb_cq_last_sch_time[hqm_pkg::NUM_LDB_CQ];
  int           ldb_cq_total_latency[hqm_pkg::NUM_LDB_CQ];
  int           ldb_cq_min_latency[hqm_pkg::NUM_LDB_CQ];
  int           ldb_cq_max_latency[hqm_pkg::NUM_LDB_CQ];
  int           ldb_cq_total_count[hqm_pkg::NUM_LDB_CQ];
  int           ave_latency_prev;  
  int           ave_latency_prev_0;  
  int           ave_latency_prev_1;  
  int           ave_latency_prev_2;  
  int           ave_latency_prev_3;  
  string        lat_report;
  real          dir_avg_rate;
  real          ldb_avg_rate;
  longint       ldb_worker_latency_delta;
  longint       ldb_worker_latency_total;
  real          ldb_worker_latency_ave_prev;
  real          ldb_worker_latency_ave_curr;
  real          ldb_worker_latency_ave_diff;
  int           ldb_qid_sch_ind[hqm_pkg::NUM_LDB_QID];
  int           ldb_cq_qid_sch_cnt[hqm_pkg::NUM_LDB_CQ];
  int           ldb_cq_qid_sch_exp;
  int           dta_cq_worker_min;
  int           dta_cq_worker_max;
  dta_cq_worker_min=1;
  dta_cq_worker_max=6;
  $value$plusargs("HQM_DTA_LDB_WORKER_QIDNUM=%0d", ldb_cq_qid_sch_exp); 
  $value$plusargs("HQM_DTA_LDB_WORKER_CQ_MIN=%0d", dta_cq_worker_min); 
  $value$plusargs("HQM_DTA_LDB_WORKER_CQ_MAX=%0d", dta_cq_worker_max); 

  for (int i = 0 ; i < hqm_pkg::NUM_DIR_QID ; i++) begin
    for (int j = 0 ; j < 8 ; j++) begin
      dir_qid_first_enq_time[i][j]      = -1;
      dir_qid_last_sch_time[i][j]       = -1;

      dir_qid_total_latency[i][j]       = 0;
      dir_qid_min_latency[i][j]         = 32'h7fffffff;
      dir_qid_max_latency[i][j]         = 0;
      dir_qid_total_count[i][j]         = 0;
    end 
  end 

  for (int i = 0 ; i < hqm_pkg::NUM_DIR_CQ ; i++) begin
    dir_cq_first_enq_time[i]    = -1;
    dir_cq_last_sch_time[i]     = -1;

    dir_cq_total_latency[i]     = 0;
    dir_cq_min_latency[i]       = 32'h7fffffff;
    dir_cq_max_latency[i]       = 0;
    dir_cq_total_count[i]       = 0;
  end 

  for (int i = 0 ; i < hqm_pkg::NUM_LDB_QID ; i++) begin
    for (int j = 0 ; j < 8 ; j++) begin
      ldb_qid_first_enq_time[i][j]      = -1;
      ldb_qid_last_sch_time[i][j]       = -1;

      ldb_qid_total_latency[i][j]       = 0;
      ldb_qid_min_latency[i][j]         = 32'h7fffffff;
      ldb_qid_max_latency[i][j]         = 0;
      ldb_qid_total_count[i][j]         = 0;
      ldb_qid_sch_ind[i]                = 0;
    end 
  end 

  for (int j = 0 ; j < 8 ; j++) begin
    dir_qpri_first_enq_time[j]  = -1;
    dir_qpri_last_sch_time[j]   = -1;
    ldb_qpri_first_enq_time[j]  = -1;
    ldb_qpri_last_sch_time[j]   = -1;

    dir_qpri_total_latency[j]   = 0;
    dir_qpri_min_latency[j]     = 32'h7fffffff;
    dir_qpri_max_latency[j]     = 0;
    dir_qpri_total_count[j]     = 0;

    ldb_qpri_total_latency[j]   = 0;
    ldb_qpri_min_latency[j]     = 32'h7fffffff;
    ldb_qpri_max_latency[j]     = 0;
    ldb_qpri_total_count[j]     = 0;
  end 

  for (int i = 0 ; i < hqm_pkg::NUM_LDB_CQ ; i++) begin
    ldb_cq_first_enq_time[i]    = -1;
    ldb_cq_last_sch_time[i]     = -1;

    ldb_cq_total_latency[i]     = 0;
    ldb_cq_min_latency[i]       = 32'h7fffffff;
    ldb_cq_max_latency[i]       = 0;
    ldb_cq_total_count[i]       = 0;
    ldb_cq_qid_sch_cnt[i]       = 0;
  end 

  for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
    for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
      for (int qpri = 0 ; qpri < 8 ; qpri++) begin
        if (dir_first_enq_time[cq][qid][qpri] >= 0) begin
          if (dir_qid_first_enq_time[qid][qpri] >= 0) begin
            if (dir_qid_first_enq_time[qid][qpri] > dir_first_enq_time[cq][qid][qpri]) begin
              dir_qid_first_enq_time[qid][qpri] = dir_first_enq_time[cq][qid][qpri];
            end 
          end else begin
            dir_qid_first_enq_time[qid][qpri] = dir_first_enq_time[cq][qid][qpri];
          end 

          if (dir_qid_last_sch_time[qid][qpri] >= 0) begin
            if (dir_qid_last_sch_time[qid][qpri] < dir_last_sch_time[cq][qid][qpri]) begin
              dir_qid_last_sch_time[qid][qpri] = dir_last_sch_time[cq][qid][qpri];
            end 
          end else begin
            dir_qid_last_sch_time[qid][qpri] = dir_last_sch_time[cq][qid][qpri];
          end 

          if (dir_qpri_first_enq_time[qpri] >= 0) begin
            if (dir_qpri_first_enq_time[qpri] > dir_first_enq_time[cq][qid][qpri]) begin
              dir_qpri_first_enq_time[qpri] = dir_first_enq_time[cq][qid][qpri];
            end 
          end else begin
            dir_qpri_first_enq_time[qpri] = dir_first_enq_time[cq][qid][qpri];
          end 

          if (dir_qpri_last_sch_time[qpri] >= 0) begin
            if (dir_qpri_last_sch_time[qpri] < dir_last_sch_time[cq][qid][qpri]) begin
              dir_qpri_last_sch_time[qpri] = dir_last_sch_time[cq][qid][qpri];
            end 
          end else begin
            dir_qpri_last_sch_time[qpri] = dir_last_sch_time[cq][qid][qpri];
          end 

          if (dir_cq_first_enq_time[cq] >= 0) begin
            if (dir_cq_first_enq_time[cq] > dir_first_enq_time[cq][qid][qpri]) begin
              dir_cq_first_enq_time[cq] = dir_first_enq_time[cq][qid][qpri];
            end 
          end else begin
            dir_cq_first_enq_time[cq] = dir_first_enq_time[cq][qid][qpri];
          end 

          if (dir_cq_last_sch_time[cq] >= 0) begin
            if (dir_cq_last_sch_time[cq] < dir_last_sch_time[cq][qid][qpri]) begin
              dir_cq_last_sch_time[cq] = dir_last_sch_time[cq][qid][qpri];
            end 
          end else begin
            dir_cq_last_sch_time[cq] = dir_last_sch_time[cq][qid][qpri];
          end 
        end 

        foreach (dir_latency[cq][qid][qpri].lat_q[index]) begin
          dir_qid_total_count[qid][qpri]++;
          dir_qid_total_latency[qid][qpri]      += dir_latency[cq][qid][qpri].lat_q[index];
          if (dir_latency[cq][qid][qpri].lat_q[index] < dir_qid_min_latency[qid][qpri]) dir_qid_min_latency[qid][qpri] = dir_latency[cq][qid][qpri].lat_q[index];
          if (dir_latency[cq][qid][qpri].lat_q[index] > dir_qid_max_latency[qid][qpri]) dir_qid_max_latency[qid][qpri] = dir_latency[cq][qid][qpri].lat_q[index];

          dir_qpri_total_count[qpri]++;
          dir_qpri_total_latency[qpri]          += dir_latency[cq][qid][qpri].lat_q[index];
          if (dir_latency[cq][qid][qpri].lat_q[index] < dir_qpri_min_latency[qpri]) dir_qpri_min_latency[qpri] = dir_latency[cq][qid][qpri].lat_q[index];
          if (dir_latency[cq][qid][qpri].lat_q[index] > dir_qpri_max_latency[qpri]) dir_qpri_max_latency[qpri] = dir_latency[cq][qid][qpri].lat_q[index];

          dir_cq_total_count[cq]++;
          dir_cq_total_latency[cq]              += dir_latency[cq][qid][qpri].lat_q[index];
          if (dir_latency[cq][qid][qpri].lat_q[index] < dir_cq_min_latency[cq]) dir_cq_min_latency[cq] = dir_latency[cq][qid][qpri].lat_q[index];
          if (dir_latency[cq][qid][qpri].lat_q[index] > dir_cq_max_latency[cq]) dir_cq_max_latency[cq] = dir_latency[cq][qid][qpri].lat_q[index];
        end 
      end 
    end 
  end 

  for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
    for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
      for (int qpri = 0 ; qpri < 8 ; qpri++) begin
        if (ldb_first_enq_time[cq][qid][qpri] >= 0) begin
          if (ldb_qid_first_enq_time[qid][qpri] >= 0) begin
            if (ldb_qid_first_enq_time[qid][qpri] > ldb_first_enq_time[cq][qid][qpri]) begin
              ldb_qid_first_enq_time[qid][qpri] = ldb_first_enq_time[cq][qid][qpri];
            end 
          end else begin
            ldb_qid_first_enq_time[qid][qpri] = ldb_first_enq_time[cq][qid][qpri];
          end 

          if (ldb_qid_last_sch_time[qid][qpri] >= 0) begin
            if (ldb_qid_last_sch_time[qid][qpri] < ldb_last_sch_time[cq][qid][qpri]) begin
              ldb_qid_last_sch_time[qid][qpri] = ldb_last_sch_time[cq][qid][qpri];
            end 
          end else begin
            ldb_qid_last_sch_time[qid][qpri] = ldb_last_sch_time[cq][qid][qpri];
          end 

          if (ldb_qpri_first_enq_time[qpri] >= 0) begin
            if (ldb_qpri_first_enq_time[qpri] > ldb_first_enq_time[cq][qid][qpri]) begin
              ldb_qpri_first_enq_time[qpri] = ldb_first_enq_time[cq][qid][qpri];
            end 
          end else begin
            ldb_qpri_first_enq_time[qpri] = ldb_first_enq_time[cq][qid][qpri];
          end 

          if (ldb_qpri_last_sch_time[qpri] >= 0) begin
            if (ldb_qpri_last_sch_time[qpri] < ldb_last_sch_time[cq][qid][qpri]) begin
              ldb_qpri_last_sch_time[qpri] = ldb_last_sch_time[cq][qid][qpri];
            end 
          end else begin
            ldb_qpri_last_sch_time[qpri] = ldb_last_sch_time[cq][qid][qpri];
          end 

          if (ldb_cq_first_enq_time[cq] >= 0) begin
            if (ldb_cq_first_enq_time[cq] > ldb_first_enq_time[cq][qid][qpri]) begin
              ldb_cq_first_enq_time[cq] = ldb_first_enq_time[cq][qid][qpri];
            end 
          end else begin
            ldb_cq_first_enq_time[cq] = ldb_first_enq_time[cq][qid][qpri];
          end 

          if (ldb_cq_last_sch_time[cq] >= 0) begin
            if (ldb_cq_last_sch_time[cq] < ldb_last_sch_time[cq][qid][qpri]) begin
              ldb_cq_last_sch_time[cq] = ldb_last_sch_time[cq][qid][qpri];
            end 
          end else begin
            ldb_cq_last_sch_time[cq] = ldb_last_sch_time[cq][qid][qpri];
          end 
        end 
        foreach (ldb_latency[cq][qid][qpri].lat_q[index]) begin
          ldb_qid_total_count[qid][qpri]++;
          ldb_qid_total_latency[qid][qpri]      += ldb_latency[cq][qid][qpri].lat_q[index];
          if (ldb_latency[cq][qid][qpri].lat_q[index] < ldb_qid_min_latency[qid][qpri]) ldb_qid_min_latency[qid][qpri] = ldb_latency[cq][qid][qpri].lat_q[index];
          if (ldb_latency[cq][qid][qpri].lat_q[index] > ldb_qid_max_latency[qid][qpri]) ldb_qid_max_latency[qid][qpri] = ldb_latency[cq][qid][qpri].lat_q[index];

          ldb_qpri_total_count[qpri]++;
          ldb_qpri_total_latency[qpri]          += ldb_latency[cq][qid][qpri].lat_q[index];
          if (ldb_latency[cq][qid][qpri].lat_q[index] < ldb_qpri_min_latency[qpri]) ldb_qpri_min_latency[qpri] = ldb_latency[cq][qid][qpri].lat_q[index];
          if (ldb_latency[cq][qid][qpri].lat_q[index] > ldb_qpri_max_latency[qpri]) ldb_qpri_max_latency[qpri] = ldb_latency[cq][qid][qpri].lat_q[index];

          ldb_cq_total_count[cq]++;
          ldb_cq_total_latency[cq]        += ldb_latency[cq][qid][qpri].lat_q[index];
          if (ldb_latency[cq][qid][qpri].lat_q[index] < ldb_cq_min_latency[cq]) ldb_cq_min_latency[cq] = ldb_latency[cq][qid][qpri].lat_q[index];
          if (ldb_latency[cq][qid][qpri].lat_q[index] > ldb_cq_max_latency[cq]) ldb_cq_max_latency[cq] = ldb_latency[cq][qid][qpri].lat_q[index];
        end 
      end 
    end 
  end 

  lat_report = "";

  for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
    for (int qpri = 0 ; qpri < 8 ; qpri++) begin
      if (dir_qid_total_count[qid][qpri] > 0) begin
        lat_report = {lat_report,$psprintf("\n    DIR QID 0x%0x QPRI %0d Average Latency = %0.1f  Min = %0.1f  Max = %0.1f  Count = %d  Throughput = %0.1f ns/HCW",
                                           qid,
                                           qpri,
                                           dir_qid_total_latency[qid][qpri]/dir_qid_total_count[qid][qpri],
                                           dir_qid_min_latency[qid][qpri],
                                           dir_qid_max_latency[qid][qpri],
                                           dir_qid_total_count[qid][qpri],
                                           (dir_qid_last_sch_time[qid][qpri] - dir_qid_first_enq_time[qid][qpri]) / dir_qid_total_count[qid][qpri]
                                          )};
      end 
    end 
  end 

  for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
    for (int qpri = 0 ; qpri < 8 ; qpri++) begin
      if (ldb_qid_total_count[qid][qpri] > 0) begin
        lat_report = {lat_report,$psprintf("\n    LDB QID 0x%0x QPRI %0d Average Latency = %0.1f  Min = %0.1f  Max = %0.1f  Count = %d  Throughput = %0.1f ns/HCW",
                                           qid,
                                           qpri,
                                           ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri],
                                           ldb_qid_min_latency[qid][qpri],
                                           ldb_qid_max_latency[qid][qpri],
                                           ldb_qid_total_count[qid][qpri],
                                           (ldb_qid_last_sch_time[qid][qpri] - ldb_qid_first_enq_time[qid][qpri]) / ldb_qid_total_count[qid][qpri]
                                          )};

        if(qpri > 0 && (ave_latency_prev > ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri])) begin
          if(i_hqm_cfg.perfck_sel == 1)
            uvm_report_error("HQM_TB_HCW_SCOREBOARD",$psprintf("QoS_CK_perfck_sel=0x%0x, ave_ldb_qid_total_latency[qid%0d][qpri%0d]=%0d, ave_latency_prev=%0d", i_hqm_cfg.perfck_sel, qid, qpri, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], ave_latency_prev),UVM_LOW);
          else if(i_hqm_cfg.perfck_sel == 2)
            uvm_report_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("QoS_CK_perfck_sel=0x%0x, ave_ldb_qid_total_latency[qid%0d][qpri%0d]=%0d, ave_latency_prev=%0d", i_hqm_cfg.perfck_sel, qid, qpri, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], ave_latency_prev),UVM_LOW);
          else 
            uvm_report_info("HQM_TB_HCW_SCOREBOARD",$psprintf("QoS_CK_perfck_sel=0x%0x, ave_ldb_qid_total_latency[qid%0d][qpri%0d]=%0d, ave_latency_prev=%0d", i_hqm_cfg.perfck_sel, qid, qpri, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], ave_latency_prev),UVM_LOW);
        end			  
        if((i_hqm_cfg.perfck_sel[7:4] == 0) && (i_hqm_cfg.perfck_sel[1] == 1) && (ave_latency_prev > ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri])) begin
            uvm_report_error("HQM_TB_HCW_SCOREBOARD",$psprintf("QoS_CK_perfck_sel=0x%0x, ave_ldb_qid_total_latency[qid%0d][qpri%0d]=%0d, ave_latency_prev=%0d", i_hqm_cfg.perfck_sel, qid, qpri, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], ave_latency_prev),UVM_LOW);
        end 

        if(i_hqm_cfg.perfck_sel[7:4] == 1) begin
          if(qid>0 && qid<4) 
            check_cos_latency_in_bin(0, qid, ave_latency_prev_0, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], i_hqm_cfg.perfck_tolerance_0);
          else if(qid>8 && qid<12) 
            check_cos_latency_in_bin(1, qid, ave_latency_prev_1, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], i_hqm_cfg.perfck_tolerance_0);
          else if(qid>16 && qid<20) 
            check_cos_latency_in_bin(2, qid, ave_latency_prev_2, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], i_hqm_cfg.perfck_tolerance_0);
          else if(qid>24 && qid<28) 
            check_cos_latency_in_bin(3, qid, ave_latency_prev_3, ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri], i_hqm_cfg.perfck_tolerance_0);
        end 

        if(i_hqm_cfg.perfck_sel[7:4]==0 && i_hqm_cfg.perfck_sel[1] == 1 && (qid==0 || qid==4 || qid==8 || qid==12)) begin
          ave_latency_prev = ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri];
        end else if(i_hqm_cfg.perfck_sel[7:4] == 1) begin
          if(qid==0)       ave_latency_prev_0 = ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri];
          else if(qid==8)  ave_latency_prev_1 = ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri];
          else if(qid==16) ave_latency_prev_2 = ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri];
          else if(qid==24) ave_latency_prev_3 = ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri];
        end else begin
          ave_latency_prev = ldb_qid_total_latency[qid][qpri]/ldb_qid_total_count[qid][qpri];
        end 
						  
      end 
    end 
  end 

  if(i_hqm_cfg.perfck_sel[7:4] == 1) begin
     check_cos_latency_bins(ave_latency_prev_0, ave_latency_prev_1, ave_latency_prev_2, ave_latency_prev_3);
  end 

  for (int qpri = 0 ; qpri < 8 ; qpri++) begin
    if (dir_qpri_total_count[qpri] > 0) begin
      lat_report = {lat_report,$psprintf("\n    DIR QPRI %0d Average Latency = %0.1f  Min = %0.1f  Max = %0.1f  Count = %d  Throughput = %0.1f ns/HCW",
                                         qpri,
                                         dir_qpri_total_latency[qpri]/dir_qpri_total_count[qpri],
                                         dir_qpri_min_latency[qpri],
                                         dir_qpri_max_latency[qpri],
                                         dir_qpri_total_count[qpri],
                                         (dir_qpri_last_sch_time[qpri] - dir_qpri_first_enq_time[qpri]) / dir_qpri_total_count[qpri]
                                        )};
    end 

    if (ldb_qpri_total_count[qpri] > 0) begin
      lat_report = {lat_report,$psprintf("\n    LDB QPRI %0d Average Latency = %0.1f  Min = %0.1f  Max = %0.1f  Count = %d  Throughput = %0.1f ns/HCW",
                                         qpri,
                                         ldb_qpri_total_latency[qpri]/ldb_qpri_total_count[qpri],
                                         ldb_qpri_min_latency[qpri],
                                         ldb_qpri_max_latency[qpri],
                                         ldb_qpri_total_count[qpri],
                                         (ldb_qpri_last_sch_time[qpri] - ldb_qpri_first_enq_time[qpri]) / ldb_qpri_total_count[qpri]
                                        )};				
        ave_latency_prev = ldb_qpri_total_latency[qpri]/ldb_qpri_total_count[qpri];					
    end 
  end 

  //----------------------------
  //-- QE.qprio checking
  //----------------------------
  //--++DIR
  //-- expect QE.prio=7 has long latency than the other QE.prio=5/3/1
  if ($test$plusargs("CHECK_DIR_AVG_QE_PRIO_7") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(dir_qpri_total_count[7] > 0 && dir_qpri_total_count[5]>0) begin
         if((dir_qpri_total_latency[7]/dir_qpri_total_count[7]) < (dir_qpri_total_latency[5]/dir_qpri_total_count[5])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 7 Average Latency = %0.1f < DIR QPRI 5 Average Latency = %0.1f",  dir_qpri_total_latency[7]/dir_qpri_total_count[7], dir_qpri_total_latency[5]/dir_qpri_total_count[5]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 7 Average Latency = %0.1f > DIR QPRI 5 Average Latency = %0.1f",  dir_qpri_total_latency[7]/dir_qpri_total_count[7], dir_qpri_total_latency[5]/dir_qpri_total_count[5]), UVM_LOW);
     end 

     if(dir_qpri_total_count[7] > 0 && dir_qpri_total_count[3]>0) begin
         if((dir_qpri_total_latency[7]/dir_qpri_total_count[7]) < (dir_qpri_total_latency[3]/dir_qpri_total_count[3])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 7 Average Latency = %0.1f < DIR QPRI 3 Average Latency = %0.1f",  dir_qpri_total_latency[7]/dir_qpri_total_count[7], dir_qpri_total_latency[3]/dir_qpri_total_count[3]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 7 Average Latency = %0.1f > DIR QPRI 3 Average Latency = %0.1f",  dir_qpri_total_latency[7]/dir_qpri_total_count[7], dir_qpri_total_latency[3]/dir_qpri_total_count[3]), UVM_LOW);
     end 

     if(dir_qpri_total_count[7] > 0 && dir_qpri_total_count[1]>0) begin
         if((dir_qpri_total_latency[7]/dir_qpri_total_count[7]) < (dir_qpri_total_latency[1]/dir_qpri_total_count[1])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 7 Average Latency = %0.1f < DIR QPRI 1 Average Latency = %0.1f",  dir_qpri_total_latency[7]/dir_qpri_total_count[7], dir_qpri_total_latency[1]/dir_qpri_total_count[1]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 7 Average Latency = %0.1f > DIR QPRI 1 Average Latency = %0.1f",  dir_qpri_total_latency[7]/dir_qpri_total_count[7], dir_qpri_total_latency[1]/dir_qpri_total_count[1]), UVM_LOW);
     end 
  end 

  //-- expect QE.prio=5 has long latency than the other QE.prio=7/3/1
  if ($test$plusargs("CHECK_DIR_AVG_QE_PRIO_5") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(dir_qpri_total_count[5] > 0 && dir_qpri_total_count[7]>0) begin
         if((dir_qpri_total_latency[5]/dir_qpri_total_count[5]) < (dir_qpri_total_latency[7]/dir_qpri_total_count[7])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 5 Average Latency = %0.1f < DIR QPRI 7 Average Latency = %0.1f",  dir_qpri_total_latency[5]/dir_qpri_total_count[5], dir_qpri_total_latency[7]/dir_qpri_total_count[7]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 5 Average Latency = %0.1f > DIR QPRI 7 Average Latency = %0.1f",  dir_qpri_total_latency[5]/dir_qpri_total_count[5], dir_qpri_total_latency[7]/dir_qpri_total_count[7]), UVM_LOW);
     end 

     if(dir_qpri_total_count[5] > 0 && dir_qpri_total_count[3]>0) begin
         if((dir_qpri_total_latency[5]/dir_qpri_total_count[5]) < (dir_qpri_total_latency[3]/dir_qpri_total_count[3])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 5 Average Latency = %0.1f < DIR QPRI 3 Average Latency = %0.1f",  dir_qpri_total_latency[5]/dir_qpri_total_count[5], dir_qpri_total_latency[3]/dir_qpri_total_count[3]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 5 Average Latency = %0.1f > DIR QPRI 3 Average Latency = %0.1f",  dir_qpri_total_latency[5]/dir_qpri_total_count[5], dir_qpri_total_latency[3]/dir_qpri_total_count[3]), UVM_LOW);
     end 

     if(dir_qpri_total_count[5] > 0 && dir_qpri_total_count[1]>0) begin
         if((dir_qpri_total_latency[5]/dir_qpri_total_count[5]) < (dir_qpri_total_latency[1]/dir_qpri_total_count[1])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 5 Average Latency = %0.1f < DIR QPRI 1 Average Latency = %0.1f",  dir_qpri_total_latency[5]/dir_qpri_total_count[5], dir_qpri_total_latency[1]/dir_qpri_total_count[1]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 5 Average Latency = %0.1f > DIR QPRI 1 Average Latency = %0.1f",  dir_qpri_total_latency[5]/dir_qpri_total_count[5], dir_qpri_total_latency[1]/dir_qpri_total_count[1]), UVM_LOW);
     end 
  end 

  //-- expect QE.prio=3 has long latency than the other QE.prio=7/5/1
  if ($test$plusargs("CHECK_DIR_AVG_QE_PRIO_3") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(dir_qpri_total_count[3] > 0 && dir_qpri_total_count[7]>0) begin
         if((dir_qpri_total_latency[3]/dir_qpri_total_count[3]) < (dir_qpri_total_latency[7]/dir_qpri_total_count[7])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 3 Average Latency = %0.1f < DIR QPRI 7 Average Latency = %0.1f",  dir_qpri_total_latency[3]/dir_qpri_total_count[3], dir_qpri_total_latency[7]/dir_qpri_total_count[7]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 3 Average Latency = %0.1f > DIR QPRI 7 Average Latency = %0.1f",  dir_qpri_total_latency[3]/dir_qpri_total_count[3], dir_qpri_total_latency[7]/dir_qpri_total_count[7]), UVM_LOW);
     end 

     if(dir_qpri_total_count[3] > 0 && dir_qpri_total_count[5]>0) begin
         if((dir_qpri_total_latency[3]/dir_qpri_total_count[3]) < (dir_qpri_total_latency[5]/dir_qpri_total_count[5])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 3 Average Latency = %0.1f < DIR QPRI 5 Average Latency = %0.1f",  dir_qpri_total_latency[3]/dir_qpri_total_count[3], dir_qpri_total_latency[5]/dir_qpri_total_count[5]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 3 Average Latency = %0.1f > DIR QPRI 5 Average Latency = %0.1f",  dir_qpri_total_latency[3]/dir_qpri_total_count[3], dir_qpri_total_latency[5]/dir_qpri_total_count[5]), UVM_LOW);
     end 

     if(dir_qpri_total_count[3] > 0 && dir_qpri_total_count[1]>0) begin
         if((dir_qpri_total_latency[3]/dir_qpri_total_count[3]) < (dir_qpri_total_latency[1]/dir_qpri_total_count[1])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 3 Average Latency = %0.1f < DIR QPRI 1 Average Latency = %0.1f",  dir_qpri_total_latency[3]/dir_qpri_total_count[3], dir_qpri_total_latency[1]/dir_qpri_total_count[1]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 3 Average Latency = %0.1f > DIR QPRI 1 Average Latency = %0.1f",  dir_qpri_total_latency[3]/dir_qpri_total_count[3], dir_qpri_total_latency[1]/dir_qpri_total_count[1]), UVM_LOW);
     end 
  end 

  //-- expect QE.prio=1 has long latency than the other QE.prio=7/5/3
  if ($test$plusargs("CHECK_DIR_AVG_QE_PRIO_1") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(dir_qpri_total_count[1] > 0 && dir_qpri_total_count[7]>0) begin
         if((dir_qpri_total_latency[1]/dir_qpri_total_count[1]) < (dir_qpri_total_latency[7]/dir_qpri_total_count[7])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 1 Average Latency = %0.1f < DIR QPRI 7 Average Latency = %0.1f",  dir_qpri_total_latency[1]/dir_qpri_total_count[1], dir_qpri_total_latency[7]/dir_qpri_total_count[7]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 1 Average Latency = %0.1f > DIR QPRI 7 Average Latency = %0.1f",  dir_qpri_total_latency[1]/dir_qpri_total_count[1], dir_qpri_total_latency[7]/dir_qpri_total_count[7]), UVM_LOW);
     end 

     if(dir_qpri_total_count[1] > 0 && dir_qpri_total_count[5]>0) begin
         if((dir_qpri_total_latency[1]/dir_qpri_total_count[1]) < (dir_qpri_total_latency[5]/dir_qpri_total_count[5])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 1 Average Latency = %0.1f < DIR QPRI 5 Average Latency = %0.1f",  dir_qpri_total_latency[1]/dir_qpri_total_count[1], dir_qpri_total_latency[5]/dir_qpri_total_count[5]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 1 Average Latency = %0.1f > DIR QPRI 5 Average Latency = %0.1f",  dir_qpri_total_latency[1]/dir_qpri_total_count[1], dir_qpri_total_latency[5]/dir_qpri_total_count[5]), UVM_LOW);
     end 

     if(dir_qpri_total_count[1] > 0 && dir_qpri_total_count[3]>0) begin
         if((dir_qpri_total_latency[1]/dir_qpri_total_count[1]) < (dir_qpri_total_latency[3]/dir_qpri_total_count[3])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 1 Average Latency = %0.1f < DIR QPRI 3 Average Latency = %0.1f",  dir_qpri_total_latency[1]/dir_qpri_total_count[1], dir_qpri_total_latency[3]/dir_qpri_total_count[3]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 1 Average Latency = %0.1f > DIR QPRI 3 Average Latency = %0.1f",  dir_qpri_total_latency[1]/dir_qpri_total_count[1], dir_qpri_total_latency[3]/dir_qpri_total_count[3]), UVM_LOW);
     end 
  end 

  //--++LDB
  //-- expect QE.prio=7 has long latency than the other QE.prio=5/3/1
  if ($test$plusargs("CHECK_LDB_AVG_QE_PRIO_7") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(ldb_qpri_total_count[7] > 0 && ldb_qpri_total_count[5]>0) begin
         if((ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]) < (ldb_qpri_total_latency[5]/ldb_qpri_total_count[5])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 7 Average Latency = %0.1f < LDB QPRI 5 Average Latency = %0.1f",  ldb_qpri_total_latency[7]/ldb_qpri_total_count[7], ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 7 Average Latency = %0.1f > LDB QPRI 5 Average Latency = %0.1f",  ldb_qpri_total_latency[7]/ldb_qpri_total_count[7], ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[7] > 0 && ldb_qpri_total_count[3]>0) begin
         if((ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]) < (ldb_qpri_total_latency[3]/ldb_qpri_total_count[3])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 7 Average Latency = %0.1f < LDB QPRI 3 Average Latency = %0.1f",  ldb_qpri_total_latency[7]/ldb_qpri_total_count[7], ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 7 Average Latency = %0.1f > LDB QPRI 3 Average Latency = %0.1f",  ldb_qpri_total_latency[7]/ldb_qpri_total_count[7], ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[7] > 0 && ldb_qpri_total_count[1]>0) begin
         if((ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]) < (ldb_qpri_total_latency[1]/ldb_qpri_total_count[1])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 7 Average Latency = %0.1f < LDB QPRI 1 Average Latency = %0.1f",  ldb_qpri_total_latency[7]/ldb_qpri_total_count[7], ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 7 Average Latency = %0.1f > LDB QPRI 1 Average Latency = %0.1f",  ldb_qpri_total_latency[7]/ldb_qpri_total_count[7], ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]), UVM_LOW);
     end 
  end 

  //-- expect QE.prio=5 has long latency than the other QE.prio=7/3/1
  if ($test$plusargs("CHECK_LDB_AVG_QE_PRIO_5") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(ldb_qpri_total_count[5] > 0 && ldb_qpri_total_count[7]>0) begin
         if((ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]) < (ldb_qpri_total_latency[7]/ldb_qpri_total_count[7])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 5 Average Latency = %0.1f < LDB QPRI 7 Average Latency = %0.1f",  ldb_qpri_total_latency[5]/ldb_qpri_total_count[5], ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 5 Average Latency = %0.1f > LDB QPRI 7 Average Latency = %0.1f",  ldb_qpri_total_latency[5]/ldb_qpri_total_count[5], ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[5] > 0 && ldb_qpri_total_count[3]>0) begin
         if((ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]) < (ldb_qpri_total_latency[3]/ldb_qpri_total_count[3])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 5 Average Latency = %0.1f < LDB QPRI 3 Average Latency = %0.1f",  ldb_qpri_total_latency[5]/ldb_qpri_total_count[5], ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 5 Average Latency = %0.1f > LDB QPRI 3 Average Latency = %0.1f",  ldb_qpri_total_latency[5]/ldb_qpri_total_count[5], ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[5] > 0 && ldb_qpri_total_count[1]>0) begin
         if((ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]) < (ldb_qpri_total_latency[1]/ldb_qpri_total_count[1])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 5 Average Latency = %0.1f < LDB QPRI 1 Average Latency = %0.1f",  ldb_qpri_total_latency[5]/ldb_qpri_total_count[5], ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 5 Average Latency = %0.1f > LDB QPRI 1 Average Latency = %0.1f",  ldb_qpri_total_latency[5]/ldb_qpri_total_count[5], ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]), UVM_LOW);
     end 
  end 

  //-- expect QE.prio=3 has long latency than the other QE.prio=7/5/1
  if ($test$plusargs("CHECK_LDB_AVG_QE_PRIO_3") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(ldb_qpri_total_count[3] > 0 && ldb_qpri_total_count[7]>0) begin
         if((ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]) < (ldb_qpri_total_latency[7]/ldb_qpri_total_count[7])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 3 Average Latency = %0.1f < LDB QPRI 7 Average Latency = %0.1f",  ldb_qpri_total_latency[3]/ldb_qpri_total_count[3], ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 3 Average Latency = %0.1f > LDB QPRI 7 Average Latency = %0.1f",  ldb_qpri_total_latency[3]/ldb_qpri_total_count[3], ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[3] > 0 && ldb_qpri_total_count[5]>0) begin
         if((ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]) < (ldb_qpri_total_latency[5]/ldb_qpri_total_count[5])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 3 Average Latency = %0.1f < LDB QPRI 5 Average Latency = %0.1f",  ldb_qpri_total_latency[3]/ldb_qpri_total_count[3], ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 3 Average Latency = %0.1f > LDB QPRI 5 Average Latency = %0.1f",  ldb_qpri_total_latency[3]/ldb_qpri_total_count[3], ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[3] > 0 && ldb_qpri_total_count[1]>0) begin
         if((ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]) < (ldb_qpri_total_latency[1]/ldb_qpri_total_count[1])) 
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 3 Average Latency = %0.1f < LDB QPRI 1 Average Latency = %0.1f",  ldb_qpri_total_latency[3]/ldb_qpri_total_count[3], ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 3 Average Latency = %0.1f > LDB QPRI 1 Average Latency = %0.1f",  ldb_qpri_total_latency[3]/ldb_qpri_total_count[3], ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]), UVM_LOW);
     end 
  end 

  //-- expect QE.prio=1 has long latency than the other QE.prio=7/5/3 (prio=1 has higher priority than 3/5/7, latency could be less than other prio's)
  if ($test$plusargs("CHECK_LDB_AVG_QE_PRIO_1") && !$test$plusargs("HQMPROC_BYPASS_CHECK_QE_PRIO")) begin
     if(ldb_qpri_total_count[1] > 0 && ldb_qpri_total_count[7]>0) begin
         if((ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]) < (ldb_qpri_total_latency[7]/ldb_qpri_total_count[7])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 1 Average Latency = %0.1f < LDB QPRI 7 Average Latency = %0.1f",  ldb_qpri_total_latency[1]/ldb_qpri_total_count[1], ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 1 Average Latency = %0.1f > LDB QPRI 7 Average Latency = %0.1f",  ldb_qpri_total_latency[1]/ldb_qpri_total_count[1], ldb_qpri_total_latency[7]/ldb_qpri_total_count[7]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[1] > 0 && ldb_qpri_total_count[5]>0) begin
         if((ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]) < (ldb_qpri_total_latency[5]/ldb_qpri_total_count[5])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 1 Average Latency = %0.1f < LDB QPRI 5 Average Latency = %0.1f",  ldb_qpri_total_latency[1]/ldb_qpri_total_count[1], ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 1 Average Latency = %0.1f > LDB QPRI 5 Average Latency = %0.1f",  ldb_qpri_total_latency[1]/ldb_qpri_total_count[1], ldb_qpri_total_latency[5]/ldb_qpri_total_count[5]), UVM_LOW);
     end 

     if(ldb_qpri_total_count[1] > 0 && ldb_qpri_total_count[3]>0) begin
         if((ldb_qpri_total_latency[1]/ldb_qpri_total_count[1]) < (ldb_qpri_total_latency[3]/ldb_qpri_total_count[3])) 
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 1 Average Latency = %0.1f < LDB QPRI 3 Average Latency = %0.1f",  ldb_qpri_total_latency[1]/ldb_qpri_total_count[1], ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]));
         else
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 1 Average Latency = %0.1f > LDB QPRI 3 Average Latency = %0.1f",  ldb_qpri_total_latency[1]/ldb_qpri_total_count[1], ldb_qpri_total_latency[3]/ldb_qpri_total_count[3]), UVM_LOW);
     end 
  end 

  //----------------------------
  // Added this check for Avg Rate within expected range for HQMV25 PVIM#1409119649
  //----------------------------
  if ($test$plusargs("CHECK_AVG_RATE_QPRI0")) begin
      dir_avg_rate = (dir_qpri_total_count[0]>0) ? ((dir_qpri_last_sch_time[0] - dir_qpri_first_enq_time[0]) / dir_qpri_total_count[0]) : 0;
      dir_avg_rate = dir_avg_rate/i_hqm_cfg.hqm_sys_clk_freq; // clk_freq = 800MHz
      ldb_avg_rate = (ldb_qpri_total_count[0]>0) ? ((ldb_qpri_last_sch_time[0] - ldb_qpri_first_enq_time[0]) / ldb_qpri_total_count[0]) : 0;
      ldb_avg_rate = ldb_avg_rate/i_hqm_cfg.hqm_sys_clk_freq; // clk_freq = 800MHz

      if ((dir_avg_rate >= 3.71) && (dir_avg_rate <= 4.21)) begin // expected range withing -5% to +5%
          uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 0 Avg Rate = 1 HCW every %0.2f clk cycles is within (5 percent of 4 clks) the expected range of (3.8,4.2); clk rate (800MHz), hqm_sys_clk_freq=%0f",  dir_avg_rate, i_hqm_cfg.hqm_sys_clk_freq), UVM_LOW);
      end 
      else begin
          if($test$plusargs("HQM_EN_PRIM_ISM_DLY_TASK")) 
             uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 0 Avg Rate = 1 HCW every %0.2f clk cycles is within (5 percent of 4 clks) the expected range of (3.8,4.2); clk rate (800MHz), hqm_sys_clk_freq=%0f",  dir_avg_rate, i_hqm_cfg.hqm_sys_clk_freq));
          else
             uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DIR QPRI 0 Avg Rate = 1 HCW every %0.2f clk cycles is within (5 percent of 4 clks) the expected range of (3.8,4.2); clk rate (800MHz), hqm_sys_clk_freq=%0f",  dir_avg_rate, i_hqm_cfg.hqm_sys_clk_freq));
      end 

      if ((ldb_avg_rate >= 7.6) && (ldb_avg_rate <= 8.4)) begin // expected range withing -5% to +5%
          uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 0 Avg Rate = 1 HCW every %0.2f clk cycles is within (5 percent of 8 clks) the expected range of (7.6,8.4); clk rate (800MHz), hqm_sys_clk_freq=%0f",  ldb_avg_rate, i_hqm_cfg.hqm_sys_clk_freq), UVM_LOW);
      end 
      else begin
          if($test$plusargs("HQM_EN_PRIM_ISM_DLY_TASK")) 
             uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 0 Avg Rate = 1 HCW every %0.2f clk cycles is within (5 percent of 8 clks) the expected range of (7.6,8.4); clk rate (800MHz), hqm_sys_clk_freq=%0f",  ldb_avg_rate, i_hqm_cfg.hqm_sys_clk_freq));
          else
             uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB QPRI 0 Avg Rate = 1 HCW every %0.2f clk cycles is within (5 percent of 8 clks) the expected range of (7.6,8.4); clk rate (800MHz), hqm_sys_clk_freq=%0f",  ldb_avg_rate, i_hqm_cfg.hqm_sys_clk_freq));
      end 
  end 


  for (int cq = 0 ; cq < hqm_pkg::NUM_DIR_CQ ; cq++) begin
    if (dir_cq_total_count[cq] > 0) begin
      lat_report = {lat_report,$psprintf("\n    DIR CQ 0x%0x Average Latency = %0.1f  Min = %0.1f  Max = %0.1f  Count = %d  Throughput = %0.1f ns/HCW",
                                         cq,
                                         dir_cq_total_latency[cq]/dir_cq_total_count[cq],
                                         dir_cq_min_latency[cq],
                                         dir_cq_max_latency[cq],
                                         dir_cq_total_count[cq],
                                         (dir_cq_last_sch_time[cq] - dir_cq_first_enq_time[cq]) / dir_cq_total_count[cq]
                                        )};
    end 
  end 

  for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
    if (ldb_cq_total_count[cq] > 0) begin
      lat_report = {lat_report,$psprintf("\n    LDB CQ 0x%0x Average Latency = %0.1f  Min = %0.1f  Max = %0.1f  Count = %d  Throughput = %0.1f ns/HCW",
                                         cq,
                                         ldb_cq_total_latency[cq]/ldb_cq_total_count[cq],
                                         ldb_cq_min_latency[cq],
                                         ldb_cq_max_latency[cq],
                                         ldb_cq_total_count[cq],
                                         (ldb_cq_last_sch_time[cq] - ldb_cq_first_enq_time[cq]) / ldb_cq_total_count[cq]
                                        )};
    end 
  end 

  //-- HQMV30 Direct Tests (LDB)
  for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
     uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB CQ 0x%0x Count = %d hqm_cfg.ldb_pp_cq_cfg[%0d].cq_pcq=%0d ", cq, ldb_cq_total_count[cq], cq, i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_pcq), UVM_LOW);

     //----------------------------------------
     //-- HQMV30 Code to check cq_pcq (LDB)
     //-- direct test: when doing PCQ (paired-CQ), CQ[n] gets all the QEs; CQ[n+1] won't; 
     //----------------------------------------
     if(i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_pcq==1 && cq%2==0) begin
         //--Even CQ receives SCHED HCWs
         //--There is the case such as one QID is assigned to multiple CQs (even CQs), so one of the even CQ doesn't receive any SCHED QE which is okay
         if(ldb_cq_total_count[cq] == 0) begin
              uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB_PCQ_Check: LDB CQ 0x%0x Count = %d = 0 when hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d, hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d ", cq, ldb_cq_total_count[cq], cq, i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_pcq, cq+1, i_hqm_cfg.ldb_pp_cq_cfg[cq+1].cq_pcq), UVM_LOW);
         end else begin
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB_PCQ_Check: LDB CQ 0x%0x Count = %d > 0 when hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d, hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d", cq, ldb_cq_total_count[cq], cq, i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_pcq, cq+1, i_hqm_cfg.ldb_pp_cq_cfg[cq+1].cq_pcq), UVM_LOW);
         end 


         //--Paired ODD CQ does not receive SCHED HCWs
         if(i_hqm_cfg.ldb_pp_cq_cfg[cq+1].cq_pcq==1) begin
           if(ldb_cq_total_count[cq+1] > 0) begin
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB_PCQ_Check: LDB CQ 0x%0x Count = %d > 0 when hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d, hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d ", cq+1, ldb_cq_total_count[cq+1], cq, i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_pcq, cq+1, i_hqm_cfg.ldb_pp_cq_cfg[cq+1].cq_pcq), UVM_LOW);
           end else begin
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB_PCQ_Check: LDB CQ 0x%0x Count = %d = 0 when hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d, hqm_cfg.ldb_pp_cq_cfg[0x%0x].cq_pcq=%0d", cq+1, ldb_cq_total_count[cq+1], cq, i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_pcq, cq+1, i_hqm_cfg.ldb_pp_cq_cfg[cq+1].cq_pcq), UVM_LOW);
           end 
         end else begin
           uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB_PCQ_Check: LDB CQ[0x%0x].cq_pcq=%0d but CQ[0x%0x].cq_pcq=%0d check cq_pcq programming", cq, i_hqm_cfg.ldb_pp_cq_cfg[cq].cq_pcq, cq+1, i_hqm_cfg.ldb_pp_cq_cfg[cq+1].cq_pcq), UVM_LOW);
         end 
     end 

     //----------------------------------------
     //-- HQMV30 Code to check PALB (LDB)
     //----------------------------------------
     //-- Two direct cases
     if ( $test$plusargs("HQM_PALB_SET_0") ) begin
        if(ldb_cq_total_count[cq]>0 && cq<7) begin
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB_PALB_Check: LDB CQ 0x%0x Count = %d > 0 when +HQMV30_PALB_CASE0_CQ7 expecting all QEs schedule to CQ7 ", cq, ldb_cq_total_count[cq+1]), UVM_LOW);
        end 
     end 
     if ( $test$plusargs("HQM_PALB_SET_1") ) begin
        if(ldb_cq_total_count[cq]>0) begin
           if(cq==1 || cq==3 || cq==5) begin
              uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("LDB_PALB_Check: LDB CQ 0x%0x Count = %d > 0 when +HQMV30_PALB_CASE0_CQ7 expecting all QEs schedule to CQ7 ", cq, ldb_cq_total_count[cq+1]), UVM_LOW);
           end 
        end 
     end 
  end //-- HQMV30 Direct Tests




  // -- Code to check that in case of random priority, higher priority QEs have lower average latency than lower priority QEs (testcase : hcw_ldb_test:atm_random_pri)
  begin

      if ( $test$plusargs("CHECK_QPRI_LATENCY") ) begin

          int unsigned qpri_bin;
          int unsigned qpri_per_bin;

          qpri_bin = 4; // For HQMv2
          void'($value$plusargs("hqm_qpri_bin=%0d", qpri_bin));
          uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Number of qpri bins = %0d", qpri_bin), UVM_LOW);
          qpri_per_bin = 8 / qpri_bin;

          for (int qid = 0 ; qid < 32 ; qid++) begin
              if (i_hqm_cfg.is_fid_qid_v(qid)) begin
                  for (int i = 0 ; i < (qpri_bin - 1); i++) begin
                      for (int j = 0 ; j < qpri_per_bin; j++) begin
                          for (int k = 0 ; k < qpri_per_bin; k++) begin

                              real latency_qpri_h;
                              real latency_qpri_l;
                              int  qpri_h;
                              int  qpri_l;

                              qpri_h = (i * qpri_per_bin) + j;
                              qpri_l = (i * qpri_per_bin) + k + qpri_per_bin;

                              latency_qpri_h = calc_latency_val(ldb_qid_total_latency[qid][qpri_h], ldb_qid_total_count[qid][qpri_h]);
                              latency_qpri_l = calc_latency_val(ldb_qid_total_latency[qid][qpri_l], ldb_qid_total_count[qid][qpri_l]);
                              check_qpri_latency(qid, qpri_h, latency_qpri_h, qpri_l, latency_qpri_l);
                          end 
                      end 
                  end 
              end else begin
                  uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Skipping check for qid=0x%0x as qid has fid_cfg_v=0", qid), UVM_LOW);
              end 
          end 
      end 
  end 

  // -- Code to check if enqueues took place after FID limit has been reached
  if ($test$plusargs("CHECK_FID_LIMIT") ) begin
      if ( |enq_after_fid_limit ) begin
          uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Enqueue after fid limit achieved(0x%0x)", enq_after_fid_limit), UVM_LOW);
      end else begin
          uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("Enqueue after fid limit not achieved(0x%0x)", enq_after_fid_limit));
      end 
  end 

  if (lat_report != "") begin
    `uvm_info("HQM_TB_HCW_SCOREBOARD",{"Latency Report",lat_report},UVM_LOW)
  end 

  //--------------------------------
  //-- starvation avoidance checking support
  //-- (ldb_last_sch_time[cq][qid][qpri] != 32'h7fffffff) 
  //-- ldb_first_sch_time[0][7][0] > ldb_last_sch_time[0][0][0]
  //--------------------------------
  if($test$plusargs("HQM_LDB_STARVA_THRUPUT_CHECK")) begin
    for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
      for (int qpri = 0 ; qpri < 8 ; qpri++) begin
        if (ldb_qid_total_count[qid][qpri] > 0) begin
           ldb_qid_throughput[qid][qpri] = (ldb_qid_last_sch_time[qid][qpri] - ldb_qid_first_enq_time[qid][qpri]) / ldb_qid_total_count[qid][qpri];
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK_THROUGHTPUT: ldb_qid_throughput[qid%0d][pri%0d]=%0f ", qid, qpri, ldb_qid_throughput[qid][qpri]), UVM_LOW)
           if(qid>0) begin
               if(ldb_qid_throughput[qid][qpri] < ldb_qid_throughput[qid-1][qpri]) 
                 `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK_THROUGHTPUT: ldb_qid_throughput[qid%0d][pri%0d]=%0f is greater than ldb_qid_throughput[qid%0d][pri%0d]=%0f", qid, qpri, ldb_qid_throughput[qid][qpri], qid-1, qpri, ldb_qid_throughput[qid-1][qpri]))
           end 
        end  
      end 
    end 
  end 

  if($test$plusargs("HQM_LDB_STRICT_CHECK")) begin
    //--arb strict: pri[qpri] comes out after  pri[qpri-1] 
    for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
      for (int qpri = 0 ; qpri < 8 ; qpri++) begin
        if (ldb_qid_total_count[qid][qpri] > 0) begin
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTRICTARB_CHECK: ldb_last_sch_time[cq0][qid%0d][pri%0d]=%0d ldb_first_sch_time[cq0][qid%0d][pri%0d]=%0d", qid, qpri, ldb_last_sch_time[0][qid][qpri], qid, qpri, ldb_first_sch_time[0][qid][qpri]), UVM_LOW)

           if(qid>0) begin
               if(ldb_last_sch_time[0][qid-1][qpri] > ldb_first_sch_time[0][qid][qpri]) 
                 `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTRICTARB_CHECK: ldb_last_sch_time[cq0][qid%0d][pri%0d]=%0d is completed later than ldb_first_sch_time[cq0][qid%0d][pri%0d]=%0d, fail in arb strict mode", qid-1, qpri, ldb_last_sch_time[0][qid-1][qpri], qid, qpri, ldb_first_sch_time[0][qid][qpri]))
               else
                 `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTRICTARB_CHECK: ldb_last_sch_time[cq0][qid%0d][pri%0d]=%0d is completed earlier than ldb_first_sch_time[cq0][qid%0d][pri%0d]=%0d, expected in arb strict mode", qid-1, qpri, ldb_last_sch_time[0][qid-1][qpri], qid, qpri, ldb_first_sch_time[0][qid][qpri]), UVM_LOW)
           end 
        end  
      end 
    end 
  end 

  //----------------------------------------------------------------------
  // Ex.) configuration to select among 4 requestors:
  //
  //  cfg_weight[7:0]     = 127; //          reqs[0] wins arb 128/256 times
  //
  //  cfg_weight[15:8]    = 254; //          reqs[1] wins arb 127/256 times
  //
  //  cfg_weight[23:16]   = 255; //          reqs[2] wins arb 1/256 times
  //
  //  cfg_weight[31:24]   = 0;   //          reqs[3] never wins through weight arbitration. Can be selected only when
  //                                         requestor 2, 0, or 1 are not valid
  //
  // NOTE: to make 8 req uniform random distribution: ,.cfg_weight( { 8'hff,8'hdf,8'hbf,8'h9f,8'h7f,8'h5f,8'h3f,8'h1f } )
  // Basically the difference between adjacent weights is the fraction out of 256 that that requestor will be picked; e.g. if weight0=0 and weight1=10, then req0 has a 10/256 chance of being selected.
  //----------------------------------------------------------------------

  if($test$plusargs("HQM_LDB_STARVA_CHECK") && !$test$plusargs("HQM_SKIP_AGITATE_SEQ")) begin
      //--setting_2 of pri8: pri[7] comes out occasionally in the middle of other QIDs' traffic 
      if(ldb_last_sch_time[0][0][0] < ldb_first_sch_time[0][7][0]) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid0][0]=%0d < ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][0][0], ldb_first_sch_time[0][7][0]))
      end else begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid0][0]=%0d > ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][0][0], ldb_first_sch_time[0][7][0]), UVM_LOW)
      end 
      if(ldb_last_sch_time[0][1][0] < ldb_first_sch_time[0][7][0]) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid1][0]=%0d < ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][1][0], ldb_first_sch_time[0][7][0]))
      end else begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid1][0]=%0d > ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][1][0], ldb_first_sch_time[0][7][0]), UVM_LOW)
      end 
      if(ldb_last_sch_time[0][2][0] < ldb_first_sch_time[0][7][0]) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid2][0]=%0d < ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][2][0], ldb_first_sch_time[0][7][0]))
      end else begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid2][0]=%0d > ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][2][0], ldb_first_sch_time[0][7][0]), UVM_LOW)
      end 
      if(ldb_last_sch_time[0][3][0] < ldb_first_sch_time[0][7][0]) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid3][0]=%0d < ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][3][0], ldb_first_sch_time[0][7][0]))
      end else begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid3][0]=%0d > ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][3][0], ldb_first_sch_time[0][7][0]), UVM_LOW)
      end 
      if(ldb_last_sch_time[0][4][0] < ldb_first_sch_time[0][7][0]) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid4][0]=%0d < ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][4][0], ldb_first_sch_time[0][7][0]))
      end else begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid4][0]=%0d > ldb_first_sch_time[cq0][qid7][0]=%0d ", ldb_last_sch_time[0][4][0], ldb_first_sch_time[0][7][0]), UVM_LOW)
      end 
      if(ldb_last_sch_time[0][5][0] < ldb_first_sch_time[0][7][0]) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid2][0]=%0d < ldb_first_sch_time[cq0][qid5][0]=%0d ", ldb_last_sch_time[0][5][0], ldb_first_sch_time[0][7][0]))
      end else begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBSTARVA_LAT_CHECK: ldb_last_sch_time[cq0][qid2][0]=%0d > ldb_first_sch_time[cq0][qid5][0]=%0d ", ldb_last_sch_time[0][5][0], ldb_first_sch_time[0][7][0]), UVM_LOW)
      end 
  end 


  //--------------------------------
  //-- DTA support
  //-- ldb_worker_latency[cq].lat_q[*] 
  //--------------------------------
  ldb_worker_latency_ave_prev = 0;
  for (int cq = 0 ; cq < hqm_pkg::NUM_LDB_CQ ; cq++) begin
     ldb_worker_latency_total=0;

     if($test$plusargs("HQM_LDB_WORKER_CHECK")) begin
        //--scen7 DTA (sw solution using token control)
        if(ldb_worker_latency[cq].lat_q.size()>2) begin
           for(int ind=0; ind<(ldb_worker_latency[cq].lat_q.size()-1); ind++) begin
              ldb_worker_latency_delta =  (ldb_worker_latency[cq].lat_q[ind+1] - ldb_worker_latency[cq].lat_q[ind]); 
              ldb_worker_latency_total =  ldb_worker_latency_total + ldb_worker_latency_delta; 
              uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Enqueue after fid limit achieved(0x%0x)", enq_after_fid_limit), UVM_LOW);
             `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_LAT CQ 0x%0x: curr[%0d].worker_lat=%0t prev[%0d].worker_lat=%0t, ldb_worker_latency_delta=%0d",
                                                       cq, ind+1, ldb_worker_latency[cq].lat_q[ind+1], ind, ldb_worker_latency[cq].lat_q[ind], ldb_worker_latency_delta),UVM_MEDIUM)
           end 

           ldb_worker_latency_ave_curr = ldb_worker_latency_total/ldb_worker_latency[cq].lat_q.size();

           if(ldb_worker_latency_ave_prev !=0) begin
              if(ldb_worker_latency_ave_curr > ldb_worker_latency_ave_prev) ldb_worker_latency_ave_diff = ldb_worker_latency_ave_curr - ldb_worker_latency_ave_prev;
              else                                                          ldb_worker_latency_ave_diff = ldb_worker_latency_ave_prev - ldb_worker_latency_ave_curr;
        
              if(ldb_worker_latency_ave_diff > 50) 
                `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_LAT_AVE CQ 0x%0x: ldb_worker_latency_total=%0d, ldb_worker_latency_ave_prev=%0f ldb_worker_latency_ave_curr=%0f ldb_worker_latency_ave_diff=%0f > 100 ", cq, ldb_worker_latency_total, ldb_worker_latency_ave_prev, ldb_worker_latency_ave_curr, ldb_worker_latency_ave_diff))
           end 

          `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_LAT_AVE CQ 0x%0x: ldb_worker_latency_total=%0d, ldb_worker_latency_ave_prev=%0f ldb_worker_latency_ave_curr=%0f ldb_worker_latency_ave_diff=%0f", cq, ldb_worker_latency_total, ldb_worker_latency_ave_prev, ldb_worker_latency_ave_curr, ldb_worker_latency_ave_diff),UVM_LOW)

           ldb_worker_latency[cq].lat_q.delete();
           ldb_worker_latency_ave_prev = ldb_worker_latency_ave_curr;   
        end else if(cq >= dta_cq_worker_min && cq <= dta_cq_worker_max) begin
                `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_LAT_AVE CQ 0x%0x: ldb_worker_latency[%0d].lat_q.size=%0d doesn't have work", cq, cq, ldb_worker_latency[cq].lat_q.size()))
        end //if(ldb_worker_latency[cq].lat_q.size()>2

        //--scen8 DTA (hw solution using new LSP feature cq_ldb_inflight_threshold=1)
        if(cq >= dta_cq_worker_min && cq <= dta_cq_worker_max )begin
          ldb_cq_qid_sch_cnt[cq]=0;

          for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
             ldb_qid_sch_ind[qid]=0;
             for (int qpri = 0 ; qpri < 8 ; qpri++) begin
               if (ldb_last_sch_time[cq][qid][qpri] != 32'h7fffffff) begin
                   ldb_qid_sch_ind[qid] = 1;
                  `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_CQQIDPRIO: ldb_last_sch_time[cq%0d][qid%0d][pri%0d]=%0d", cq, qid, qpri, ldb_last_sch_time[cq][qid][qpri]),UVM_LOW)
               end 
             end 
             if(ldb_qid_sch_ind[qid]==1) begin
                 ldb_cq_qid_sch_cnt[cq]++;
                `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_CQQID: cq=%0d ldb_qid_sch_ind[qid%0d]=%0d ldb_cq_qid_sch_cnt[cq%0d]=%0d", cq, qid, ldb_qid_sch_ind[qid], cq, ldb_cq_qid_sch_cnt[cq]),UVM_LOW)
             end 
          end 

          `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_CQ: ldb_cq_qid_sch_cnt[cq%0d]=%0d", cq, ldb_cq_qid_sch_cnt[cq]),UVM_LOW)
          if($test$plusargs("HQM_DTA_RQPRNDLOCK_LDB_WORKER_CHECK") && ldb_cq_qid_sch_cnt[cq] < ldb_cq_qid_sch_exp) begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGLDBWORKER_CQ: ldb_cq_qid_sch_cnt[cq%0d]=%0d", cq, ldb_cq_qid_sch_cnt[cq]))
          end 
        end 
     end 
  end 

endfunction

//------------------------------------------------------------------------------------
//-- run
//------------------------------------------------------------------------------------
task hqm_tb_hcw_scoreboard::run_phase (uvm_phase phase);
    fork
      get_enq_item_from_hcwgen();          
      get_enq_item_from_monitor();
      get_sch_item_from_monitor();
    join_none
endtask

//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//-- ENQED HCW sneak from hcw generator (axi_translator) 
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
task hqm_tb_hcw_scoreboard::get_enq_item_from_hcwgen();
  hcw_transaction item;
  hcw_transaction to_q;
  int hcwgenin_item_count = 0;
    
  forever begin
    //-- retrive hcw_item from hcwgen 
    hcwgen_item_fifo.get(item);
  $cast(to_q, item);//.clone()); 

    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_GENHCW_isldb=%0d_PP=0x%0x, CMD=(v=%0d/o=%0d/u=%0d/t=%0d), QTYPE=%0s QID 0x%0x QPRI %0d LOCKID 0x%0x NO_DEC %0d tbcnt=0x%0x cmp_id=0x%0x ",
                 to_q.is_ldb, to_q.ppid,  to_q.qe_valid, to_q.qe_orsp, to_q.qe_uhl, to_q.cq_pop, to_q.qtype.name(), to_q.qid, to_q.qpri, to_q.lockid, to_q.no_inflcnt_dec, to_q.iptr, to_q.cmp_id),UVM_LOW)

    if(to_q.qe_valid || to_q.qe_orsp || to_q.qe_uhl || to_q.cq_pop)begin
       uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("HCWSB_GENHCW_%0d: v=%0d/o=%0d/u=%0d/t=%0d/qtype=%0s/enqattr=%0d/ppid=0x%0x/qid=0x%0x/lockid=0x%0x, tbcnt=0x%0x/tbcnt=%0d/iptr=0x%8x;", 
                          hcwgenin_item_count, to_q.qe_valid, to_q.qe_orsp, to_q.qe_uhl, to_q.cq_pop, to_q.qtype.name(), to_q.enqattr, to_q.ppid, to_q.qid, to_q.lockid, to_q.iptr, to_q.tbcnt, to_q.iptr), UVM_MEDIUM);
       hcwgenin_item_count ++;
        
       trfgen_enqhcw_access_sm.get ( 1 );
	      
       trfgen_enqhcw_q.push_back(to_q);	   	
	   	
       trfgen_enqhcw_access_sm.put ( 1 );	   
    end 
  end //--forever	
endtask: get_enq_item_from_hcwgen
	
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//-- ENQED traffic capture
//-- capture hcw_transaction driven to DUT(hqm_core) via TB AXI master
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
task hqm_tb_hcw_scoreboard::get_enq_item_from_monitor();
  hcw_transaction       item;
  hcw_transaction       to_q;
  int                   idx_l[$];
    
  forever begin
    // retrive hcw_item from TB AXI master mon 
    in_item_fifo.get(item);
  $cast(to_q, item);//.clone());

    // determine testbench count (sequence number)
    set_tbcnt(to_q);
      
    //------     
    //-- find original hcw from trfgen_enqhcw_q:  hcw_tr_rebuild has original information
    //------   
    if (trfgen_enqhcw_q.size() > 0) begin
      trfgen_enqhcw_access_sm.get ( 1 ) ;

      idx_l = trfgen_enqhcw_q.find_first_index with ( item.tbcnt == to_q.tbcnt );  

      if (idx_l.size() > 0 ) begin		  
        process_enq_hcw(trfgen_enqhcw_q[idx_l[0]],to_q);

        uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("get_enq_item_from_monitor__remove_from_trfgen_enqhcw_q: v=%0d/o=%0d/u=%0d/t=%0d/qtype=%0s/ppid=0x%0x/qid=0x%0x/tbcnt=0x%0x; trfgen_enqhcw_q.size=%0d",to_q.qe_valid, to_q.qe_orsp, to_q.qe_uhl, to_q.cq_pop, to_q.qtype.name(), to_q.ppid, to_q.qid, to_q.tbcnt, trfgen_enqhcw_q.size()), UVM_MEDIUM); 
        trfgen_enqhcw_q.delete(idx_l[0]); 

        if (idx_l.size() > 1) begin
          `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("More than one entry (%d) in trfgen_enqhcw_q with tbcnt==0x%04x",idx_l.size(),to_q.tbcnt))
        end 
      end 

      trfgen_enqhcw_access_sm.put ( 1 ) ;
    end 
  end 
endtask  

//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//-- SCHED traffic capture
//-- capture hcw_transaction (SCHED) driven by DUT(hqm_core) to TB AXI slave
//-- When receives SCHED hcw (ppid/prod_port/qtype/qid/qpri/dsi/ptr)
//-- 1/ check if SCHED hcw has correct qid/qpri/qtype
//-- 2/ if DIR/UNO, check ordering based on QID
//-- 3/ if ATM, check ordering and single thread
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
task hqm_tb_hcw_scoreboard::get_sch_item_from_monitor();
  hcw_transaction   item;
  hcw_transaction   to_q;
                
  forever begin
    //---------------------------------	    
    //---------------------------------	
    //-- retrive hcw_item from TB AXI slave mon 
    //---------------------------------	    
    //---------------------------------	
    out_item_fifo.get(item);
  $cast(to_q, item);//.clone());
         
    set_tbcnt(to_q,1'b1);

    process_sch_hcw(to_q);
  end 
endtask

// Set the tbcnt field of hcw_trans using iptr
task hqm_tb_hcw_scoreboard::set_tbcnt(hcw_transaction hcw_trans,bit is_sch_hcw);
  hcw_trans.tbcnt = hcw_trans.iptr;
endtask : set_tbcnt

task hqm_tb_hcw_scoreboard::set_start_time(hcw_transaction hcw_trans);
  hcw_trans.mea_start_time    = $realtime/1ns;
  hcw_trans.mea_latency_valid = 0;
endtask : set_start_time

task hqm_tb_hcw_scoreboard::calc_latency(hcw_transaction hcw_trans,int pf_cq,int pf_qid, bit is_meas, bit [15:0] dsi_ts);
  time                   curr_worker_time; 

  if (hcw_trans.sch_is_ldb) begin
    if (ldb_first_enq_time[pf_cq][pf_qid][hcw_trans.qpri] < 0) begin
      ldb_first_enq_time[pf_cq][pf_qid][hcw_trans.qpri]     = hcw_trans.mea_start_time;
    end 
  end else begin
    if (dir_first_enq_time[pf_cq][pf_qid][hcw_trans.qpri] < 0) begin
      dir_first_enq_time[pf_cq][pf_qid][hcw_trans.qpri]     = hcw_trans.mea_start_time;
    end 
  end 

  curr_worker_time            = ($realtime/1ns);
  hcw_trans.mea_start_time    = ($realtime/1ns) - hcw_trans.mea_start_time;
  hcw_trans.mea_latency_valid = 1;

  if (hcw_trans.sch_is_ldb) begin
    if (ldb_first_sch_time[pf_cq][pf_qid][hcw_trans.qpri] < 0) begin
      ldb_first_sch_time[pf_cq][pf_qid][hcw_trans.qpri]    = $realtime/1ns;
    end 

    if($test$plusargs("HQM_LDB_WORKER_CHECK")) ldb_worker_latency[pf_cq].lat_q.push_back(curr_worker_time);
    ldb_latency[pf_cq][pf_qid][hcw_trans.qpri].lat_q.push_back(hcw_trans.mea_start_time);
    ldb_last_sch_time[pf_cq][pf_qid][hcw_trans.qpri]       = $realtime/1ns;
  end else begin
    dir_latency[pf_cq][pf_qid][hcw_trans.qpri].lat_q.push_back(hcw_trans.mea_start_time);
    dir_last_sch_time[pf_cq][pf_qid][hcw_trans.qpri]       = $realtime/1ns;
  end 

  if(is_meas) begin
       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGTSSCH %0s PP 0x%0x tb_lat %0d dsi_ts %0d diff %0d",(hcw_trans.sch_is_ldb ? "LDB" : "DIR"),pf_cq, hcw_trans.mea_start_time, dsi_ts, (hcw_trans.mea_start_time-dsi_ts)),UVM_MEDIUM)
  end 
endtask : calc_latency

task hqm_tb_hcw_scoreboard::pp_check(hcw_transaction gen_hcw_trans, hcw_transaction enq_hcw_trans);
  int   pf_pp;
  int   pf_qid;
  int   vas;
  int   dvas;
  bit   is_ao_cfg_v;

  if (gen_hcw_trans.is_vf) begin
    // VPP valid check
    if (!i_hqm_cfg.is_vpp_v(enq_hcw_trans.vf_num,enq_hcw_trans.is_ldb,enq_hcw_trans.ppid)) begin
      gen_hcw_trans.ingress_drop = 1;
      enq_hcw_trans.ingress_drop = 1;
      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal VPP 0x%0x, vf_num=%0d",enq_hcw_trans.ppid,enq_hcw_trans.vf_num),UVM_LOW)
      return;
    end 
  end else if (i_hqm_cfg.get_iov_mode() == HQM_SCIOV_MODE) begin
    // PP valid check
    if ( (!i_hqm_cfg.is_sciov_pp_v(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid)) && (!enq_hcw_trans.is_nm_pf) ) begin
      gen_hcw_trans.ingress_drop = 1;
      enq_hcw_trans.ingress_drop = 1;
      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal SCIOV %s VPP 0x%0x is_nm_pf %0d",(enq_hcw_trans.is_ldb ? "LDB" : "DIR"),enq_hcw_trans.ppid, enq_hcw_trans.is_nm_pf),UVM_LOW)
      return;
    end 
  end else begin
    // PP valid check
    if ( (!i_hqm_cfg.is_pp_v(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid)) && (!enq_hcw_trans.is_nm_pf) ) begin
      gen_hcw_trans.ingress_drop = 1;
      enq_hcw_trans.ingress_drop = 1;
      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal %s PP 0x%0x",(enq_hcw_trans.is_ldb ? "LDB" : "DIR"),enq_hcw_trans.ppid),UVM_LOW)
      return;
    end 
  end 

  case (i_hqm_cfg.get_iov_mode())
    HQM_PF_MODE: begin
      if (gen_hcw_trans.is_vf) begin
        `uvm_error("HQM_TB_HCW_SCOREBOARD","HCW command indicates is_vf when SRIOV not enabled")
      end 

      pf_pp       = enq_hcw_trans.ppid;
    end 
    HQM_SCIOV_MODE: begin
      if (gen_hcw_trans.is_vf) begin
        `uvm_error("HQM_TB_HCW_SCOREBOARD","HCW command indicates is_vf when SRIOV not enabled")
      end 

      pf_pp       = i_hqm_cfg.get_pf_pp(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,1'b1);
    end 
    HQM_SRIOV_MODE: begin
      pf_pp       = i_hqm_cfg.get_pf_pp(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,1'b1);
    end 
  endcase

  // Excess Fragment check
  if (gen_hcw_trans.qe_valid) begin
    // Excess fragments in FRAG
    if(gen_hcw_trans.qe_orsp) begin
       if(gen_hcw_trans.frg_cnt > HQM_FRAG_MAX ) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        //-- don't return credit //i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Excess_Frag_in_FRAG frg_cnt=%0d frg_num=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x tbcnt=0x%0x qid=0x%0x",gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_last,gen_hcw_trans.ordidx, gen_hcw_trans.ordqid, gen_hcw_trans.tbcnt, pf_qid),UVM_LOW)
        return;
       end 
    end 

    // Excess fragments in RENQ/RENQ_T
    if(gen_hcw_trans.qe_uhl && gen_hcw_trans.reord) begin
       if(gen_hcw_trans.frg_cnt > HQM_FRAG_MAX ) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        //-- don't return credit //i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Excess_Frag_in_RENQ frg_cnt=%0d frg_num=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x tbcnt=0x%0x qid=0x%0x",gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_last,gen_hcw_trans.ordidx, gen_hcw_trans.ordqid, gen_hcw_trans.tbcnt, pf_qid),UVM_LOW)
        return;
       end 
    end 
  end 

  // Get VAS for PP
  vas = i_hqm_cfg.get_vas(enq_hcw_trans.is_ldb,pf_pp);

  // NEW,NEW_T,RENQ,RENQ_T,RELS
  if (enq_hcw_trans.qe_valid || (enq_hcw_trans.qe_orsp && (enq_hcw_trans.qe_uhl == 0) && (enq_hcw_trans.cq_pop == 0))) begin
    if (gen_hcw_trans.is_vf) begin
      // VQID valid check
      if (!i_hqm_cfg.is_vqid_v(enq_hcw_trans.vf_num,(enq_hcw_trans.qtype == QDIR) ? 1'b0 : 1'b1,enq_hcw_trans.qid)) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal VQID 0x%0x, vf_num=%0d",enq_hcw_trans.qid,enq_hcw_trans.vf_num),UVM_LOW)
        return;
      end 
    end else if (i_hqm_cfg.get_iov_mode() == HQM_SCIOV_MODE) begin
      // SCIOV VQID valid check
      if ( (!i_hqm_cfg.is_sciov_vqid_v(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,((enq_hcw_trans.qtype == QDIR) ? 1'b0 : 1'b1),enq_hcw_trans.qid)) && (!enq_hcw_trans.is_nm_pf) ) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal SCIOV %s VPP 0x%0x VQID 0x%0x is_nm_pf %0d",(enq_hcw_trans.is_ldb ? "LDB" : "DIR"),enq_hcw_trans.ppid,enq_hcw_trans.qid, enq_hcw_trans.is_nm_pf),UVM_LOW)
        return;
      end 
    end else begin
      // QID valid check
      if (!i_hqm_cfg.is_qid_v((enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid)) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal %s QID 0x%0x",(enq_hcw_trans.qtype == QDIR) ? "DIR" : "LDB",enq_hcw_trans.qid),UVM_LOW)
        return;
      end 
    end 
  end 

  case (i_hqm_cfg.get_iov_mode())
    HQM_PF_MODE: begin
      pf_qid      = enq_hcw_trans.qid;
    end 
    HQM_SCIOV_MODE: begin
      pf_qid      = i_hqm_cfg.get_sciov_qid(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b1,enq_hcw_trans.is_nm_pf);
    end 
    HQM_SRIOV_MODE: begin
      pf_qid      = i_hqm_cfg.get_pf_qid(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b1,enq_hcw_trans.is_nm_pf);
    end 
  endcase

  is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(pf_qid); 

  if (enq_hcw_trans.qe_valid) begin
    // VAS QID valid check
    if (!i_hqm_cfg.is_vasqid_v(vas,(enq_hcw_trans.qtype != QDIR),pf_qid)) begin
      gen_hcw_trans.ingress_drop = 1;
      enq_hcw_trans.ingress_drop = 1;
      i_hqm_pp_cq_status.put_vas_credit(vas);
      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: VAS 0x%0x QID 0x%0x not valid",vas,pf_qid),UVM_LOW)
      return;
    end 

    // Atomic QID check
    if (enq_hcw_trans.qtype == QATM) begin
      if (!i_hqm_cfg.is_fid_qid_v(pf_qid)) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: QID 0x%0x not configured for atomic traffic",pf_qid),UVM_LOW)
        return;
      end 
    end 

    // Unordered QID check
    if (enq_hcw_trans.qtype == QUNO) begin
      if (i_hqm_cfg.is_sn_qid_v(pf_qid)) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: QID 0x%0x not configured for unordered traffic",pf_qid),UVM_LOW)
        return;
      end 
    end 

    // Ordered QID check
    if (enq_hcw_trans.qtype == QORD) begin
      if (!i_hqm_cfg.is_sn_qid_v(pf_qid)) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: QID 0x%0x not configured for ordered traffic",pf_qid),UVM_LOW)
        return;
      end 
    end 

    //--AO QID check
    if(is_ao_cfg_v) begin
      if (!i_hqm_cfg.is_sn_qid_v(pf_qid)) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: QID 0x%0x not configured for ordered traffic when is_ao_cfg_v=1",pf_qid),UVM_LOW)
      end 
      if (!i_hqm_cfg.is_fid_qid_v(pf_qid)) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: QID 0x%0x not configured for atomic traffic when is_ao_cfg_v=1",pf_qid),UVM_LOW)
      end 

      if (enq_hcw_trans.qtype == QUNO) begin
        gen_hcw_trans.ingress_drop = 1;
        enq_hcw_trans.ingress_drop = 1;
        i_hqm_pp_cq_status.put_vas_credit(vas);
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: QID 0x%0x not configured for AO traffic with QTYPE %0s",pf_qid, enq_hcw_trans.qtype.name()),UVM_LOW)
        return;
      end 
    end 
  end 

endtask : pp_check

task hqm_tb_hcw_scoreboard::ingress_check(hcw_transaction gen_hcw_trans, hcw_transaction enq_hcw_trans);
  hcw_cmd_t     hcw_cmd;
  int           pf_pp;
  int           pf_qid;
  int           idx_l[$];
  bit           is_ao_cfg_v;


  //---------------------------
  if (!i_hqm_cfg.is_legal_sai(.op(UVM_WRITE),.sai8(enq_hcw_trans.sai),.file_name("hqm_pf_cfg_i"),.reg_name("device_command")) && i_hqm_cfg.no_sai_check==0) begin
    gen_hcw_trans.ingress_drop = 1;
    enq_hcw_trans.ingress_drop = 1;
    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal SAI 0x%0x for HCW enqueue",enq_hcw_trans.sai),UVM_LOW)

  end else begin
     hcw_cmd = {enq_hcw_trans.qe_valid,enq_hcw_trans.qe_orsp,enq_hcw_trans.qe_uhl,enq_hcw_trans.cq_pop};

    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_check:: Start with hcw_cmd %s - is_ldb %0d PP 0x%0x QID 0x%0x QTYPE %0s - gen_hcw_trans.ingress_drop=%0d", hcw_cmd.name(), enq_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.qid, enq_hcw_trans.qtype.name(), gen_hcw_trans.ingress_drop),UVM_MEDIUM)

      case (i_hqm_cfg.get_iov_mode())
        HQM_PF_MODE: begin
          if (gen_hcw_trans.is_vf) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD","HCW command indicates is_vf when SRIOV not enabled")
          end 
    
          pf_pp       = enq_hcw_trans.ppid;
          pf_qid      = enq_hcw_trans.qid;
        end 
        HQM_SCIOV_MODE: begin
          if (gen_hcw_trans.is_vf) begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD","HCW command indicates is_vf when SRIOV not enabled")
          end 
    
          pf_pp       = i_hqm_cfg.get_pf_pp(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,1'b1);
          pf_qid      = i_hqm_cfg.get_sciov_qid(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b1,enq_hcw_trans.is_nm_pf);
        end 
        HQM_SRIOV_MODE: begin
          pf_pp       = i_hqm_cfg.get_pf_pp(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,1'b1);
          pf_qid      = i_hqm_cfg.get_pf_qid(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b1);
        end 
      endcase
    
      is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(pf_qid); 
    
      // HCW command checks
      case (hcw_cmd)
        NOOP:       begin
          pp_check(gen_hcw_trans,enq_hcw_trans);
        end 
        BAT_T:      begin
          pp_check(gen_hcw_trans,enq_hcw_trans);
        end 
        COMP:       begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd_dir_pp) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp))
            end 
          end else begin
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
        COMP_T:     begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd_dir_pp) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp))
            end 
          end else begin
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
    
        A_COMP:       begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd_dir_pp) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp))
            end 
          end else begin
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
    
        A_COMP_T:     begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd_dir_pp) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp))
            end 
          end else begin
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
    
        RELS:       begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd_dir_pp) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp))
            end 
          end else if (enq_hcw_trans.qtype == QDIR) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: HCW command %s with directed QID",hcw_cmd.name()),UVM_LOW)
          end else begin
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
        ARM:       begin
          pp_check(gen_hcw_trans,enq_hcw_trans);
        end 
        NEW:        begin
          pp_check(gen_hcw_trans,enq_hcw_trans);
        end 
        NEW_T:      begin
          pp_check(gen_hcw_trans,enq_hcw_trans);
        end 
        RENQ:       begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd_dir_pp) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp))
            end 
          end else begin
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("RENQ HCW command %s with PP 0x%0x ingress_drop %0d reord %0d",hcw_cmd.name(),pf_pp,gen_hcw_trans.ingress_drop,gen_hcw_trans.reord),UVM_LOW)
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
        RENQ_T:     begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd_dir_pp) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp))
            end 
          end else begin
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("RENQ_T HCW command %s with PP 0x%0x ingress_drop %0d reord %0d",hcw_cmd.name(),pf_pp,gen_hcw_trans.ingress_drop,gen_hcw_trans.reord),UVM_LOW)
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
        FRAG:       begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
          end else begin
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW command %s with PP 0x%0x ingress_drop %0d",hcw_cmd.name(),pf_pp,gen_hcw_trans.ingress_drop),UVM_MEDIUM)
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
        FRAG_T:     begin
          if (!enq_hcw_trans.is_ldb) begin
            gen_hcw_trans.ingress_drop = 1;
            enq_hcw_trans.ingress_drop = 1;
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command %s with directed PP 0x%0x",hcw_cmd.name(),pf_pp),UVM_LOW)
          end else begin
           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW command %s with PP 0x%0x ingress_drop %0d",hcw_cmd.name(),pf_pp,gen_hcw_trans.ingress_drop),UVM_MEDIUM)
            pp_check(gen_hcw_trans,enq_hcw_trans);
          end 
        end 
        ILLEGAL14, ILLEGAL15: begin
          gen_hcw_trans.ingress_drop = 1;
          enq_hcw_trans.ingress_drop = 1;
          if (enq_hcw_trans.is_ldb) begin
            if (i_hqm_cfg.ldb_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command 0x%0x",hcw_cmd),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command 0x%0x",hcw_cmd))
            end 
          end else begin
            if (i_hqm_cfg.dir_pp_cq_cfg[pf_pp].exp_errors.ill_hcw_cmd) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Illegal HCW command 0x%0x",hcw_cmd),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Illegal HCW command 0x%0x",hcw_cmd))
            end 
          end 
        end 
        default: begin
          gen_hcw_trans.ingress_drop = 1;
          enq_hcw_trans.ingress_drop = 1;
          `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_drop=1:: Illegal HCW command 0x%0x",hcw_cmd))
        end 
      endcase
    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("ingress_check:: End with hcw_cmd %s - is_ldb %0d PP 0x%0x QID 0x%0x QTYPE %0s - gen_hcw_trans.ingress_drop=%0d", hcw_cmd.name(), enq_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.qid, enq_hcw_trans.qtype.name(), gen_hcw_trans.ingress_drop),UVM_MEDIUM)
  end //

  if (gen_hcw_trans.exp_ingress_drop && !enq_hcw_trans.ingress_drop) begin
    `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - expected ingress drop case but scoreboard did not generate an ingress drop"))
  end 
endtask : ingress_check

task hqm_tb_hcw_scoreboard::process_enq_hcw(hcw_transaction gen_hcw_trans, hcw_transaction enq_hcw_trans);
  bit [6:0]             pf_qid;
  int                   pf_cq;
  int                   gen_pp;
  int                   comp_idx;
  hcw_transaction       sch_trans;
  bit                   adj_is_ldb;
  bit [7:0]             pp_type_pp;
  int                   idx_l[$];
  hcw_transaction       hcw_trans_from_cq;
  int                   is_ao_cfg_v;  

  set_start_time(gen_hcw_trans);

  ingress_check(gen_hcw_trans,enq_hcw_trans);

  //------------------------------
  //-- COMP processing 
  //------------------------------
  if ((gen_hcw_trans.qe_uhl && !gen_hcw_trans.ingress_drop) || (gen_hcw_trans.qe_uhl && gen_hcw_trans.ingress_comp_nodrop)) begin
    pf_cq = i_hqm_cfg.get_pf_pp(gen_hcw_trans.is_vf, gen_hcw_trans.vf_num, gen_hcw_trans.is_ldb ,gen_hcw_trans.ppid);

    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DBGENQ_HCW_isldb=%0d_PP=0x%0x, Has_Completion => GENCMD=(v=%0d/o=%0d/u=%0d/t=%0d), tbcnt=0x%0x cmp_id=0x%0x is_ord=%0d; 2ndP(reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x ordpri=%0d ordlockid=0x%0x reordidx=0x%0x)",
                 gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, gen_hcw_trans.qe_valid, gen_hcw_trans.qe_orsp, gen_hcw_trans.qe_uhl, gen_hcw_trans.cq_pop, enq_hcw_trans.iptr, enq_hcw_trans.cmp_id, gen_hcw_trans.is_ord, gen_hcw_trans.reord, gen_hcw_trans.frg_num, gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_last, gen_hcw_trans.ordidx, gen_hcw_trans.ordqid, gen_hcw_trans.ordpri, gen_hcw_trans.ordlockid, gen_hcw_trans.reordidx ),UVM_LOW)

    if ((pf_cq >= 0) && (pf_cq < hqm_pkg::NUM_LDB_CQ) && gen_hcw_trans.is_ldb==1) begin
       //-- LDBCQ --//
       if(gen_hcw_trans.qe_valid==0 && gen_hcw_trans.qe_orsp==1) begin
          //-----------------------------//
          //-- A_COMP/A_COMP_T         --//
          //-----------------------------//
                //--COMB flow: comp_idx[31:28] should be 4'b0011
                if (ldb_cq_a_comp_q[pf_cq].hcw_comp_q.size() > 0) begin
                    comp_idx        = ldb_cq_a_comp_q[pf_cq].hcw_comp_q.pop_front();
                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_A_COMP_isldb=%0d_PP=0x%0x:: tbcnt=0x%0x; 2ndP(ordidx=0x%0x); found comp_idx=0x%0x from ldb_cq_a_comp_q[0x%0x].hcw_comp_q.size=%0d", gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.iptr, gen_hcw_trans.ordidx, comp_idx, pf_cq, ldb_cq_a_comp_q[pf_cq].hcw_comp_q.size()),UVM_LOW)
                end else begin
                    comp_idx = 32'hffffffff;
                    if (i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].exp_errors.unexp_comp) begin
                      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - unexpected A_COMP from PP/CQ 0x%0x (expected this)",pf_cq),UVM_LOW)
                    end else begin
                      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - unexpected A_COMP from PP/CQ 0x%0x",pf_cq))
                    end 
                end 

       end else begin
          //-----------------------------//
          //-- COMP/COMP_T/RENQ/RENQ_T --//
          //-----------------------------//
          //-- is_ord=0 :: 
          //--03312022: try is_ord   if(gen_hcw_trans.reord==0) begin 
          if(gen_hcw_trans.is_ord==0) begin 
             //-- ATM_COMP/RENQ :: should pop comp_idx[31:28]=4'b0000
             if (ldb_cq_comp_q[pf_cq].hcw_comp_q.size() > 0) begin
                 comp_idx        = ldb_cq_comp_q[pf_cq].hcw_comp_q.pop_front();
                `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_COMP_isldb=%0d_PP=0x%0x:: tbcnt=0x%0x; 2ndP(ordidx=0x%0x); found comp_idx=0x%0x from ldb_cq_comp_q[0x%0x].hcw_comp_q.size=%0d", gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.iptr, gen_hcw_trans.ordidx, comp_idx, pf_cq, ldb_cq_comp_q[pf_cq].hcw_comp_q.size()),UVM_LOW)
             end else begin
                 comp_idx = 32'hffffffff;
                 if (i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].exp_errors.unexp_comp) begin
                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - unexpected completion from PP/CQ 0x%0x (expected this)",pf_cq),UVM_LOW)
                 end else begin
                  `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - unexpected completion from PP/CQ 0x%0x",pf_cq))
                 end 
             end 
          end else begin
             //------------- HQMV30 ORD
             //--HQMV30 enhancement
             //------------- HQMV30 ORD
             //--find the matching qid/pri from ldb_cq_ord_q[cq].hcw_q[] based on ordidx
             //------------- HQMV30 ORD
             //-- ORD_COMP/RENQ :: comp_idx[31:28]=4'b0100

             if($test$plusargs("HQM_ENQ_ROBENA") || $test$plusargs("HQM_USE_CQORD_QUEUE")) begin 
                //--HQMV30 ROBENA
                hcw_ldb_cq_ord_q_access_sm.get(1);
               `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_2ndP_Comp_isldb=%0d_PP=0x%0x:: tbcnt=0x%0x; 2ndP(ordidx=0x%0x); ldb_cq_ord_q[0x%0x].hcw_q.size=%0d (+HQM_ENQ_ROBENA) ", gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.iptr, gen_hcw_trans.ordidx, enq_hcw_trans.ppid, ldb_cq_ord_q[enq_hcw_trans.ppid].hcw_q.size()),UVM_LOW)

                idx_l = ldb_cq_ord_q[enq_hcw_trans.ppid].hcw_q.find_first_index with ( item.tbcnt == gen_hcw_trans.ordidx ); 

                if (idx_l.size() > 0 ) begin		  
                   hcw_trans_from_cq = ldb_cq_ord_q[enq_hcw_trans.ppid].hcw_q[idx_l[0]];
                   ldb_cq_ord_q[enq_hcw_trans.ppid].hcw_q.delete(idx_l[0]);

                   //-- formation of comp_idx for ORD's COMP (comp or renq)
                   comp_idx = 32'h40000000 + (hcw_trans_from_cq.qid << 19) + (hcw_trans_from_cq.qpri << 16);
                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_2ndP_Comp_isldb=%0d_PP=0x%0x:: tbcnt=0x%0x; 2ndP(ordidx=0x%0x); found 1stpass_ord_sched_hcw with qid=0x%0x pri=%0d => comp_idx=0x%0x", gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.iptr, gen_hcw_trans.ordidx, hcw_trans_from_cq.qid, hcw_trans_from_cq.qpri, comp_idx),UVM_LOW)
                end else begin
                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_2ndP_Comp_isldb=%0d_PP=0x%0x:: tbcnt=0x%0x; 2ndP(ordidx=0x%0x); ldb_cq_ord_q[0x%0x].hcw_q not find ordidx=0x%0x => no comp_idx", gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.iptr,  gen_hcw_trans.ordidx, enq_hcw_trans.ppid, gen_hcw_trans.ordidx))
                   comp_idx = 32'h40000000; //--tmp
                end 
                hcw_ldb_cq_ord_q_access_sm.put(1);

             end else begin
                //--HQMV25 
                if (ldb_cq_comp_q[pf_cq].hcw_comp_q.size() > 0) begin
                    comp_idx        = ldb_cq_comp_q[pf_cq].hcw_comp_q.pop_front();
                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_2ndP_Comp_isldb=%0d_PP=0x%0x:: tbcnt=0x%0x; 2ndP(ordidx=0x%0x); found 1stpass_ord_sched_hcw from ldb_cq_comp_q (w/o +HQM_ENQ_ROBENA) => comp_idx=0x%0x", gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.iptr, gen_hcw_trans.ordidx, comp_idx),UVM_LOW)
                end else begin
                    comp_idx = 32'hffffffff;
                    if (i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].exp_errors.unexp_comp) begin
                      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - unexpected completion from PP/CQ 0x%0x (expected this)",pf_cq),UVM_LOW)
                    end else begin
                      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - unexpected completion from PP/CQ 0x%0x",pf_cq))
                    end 
                end 
             end //--if($test$plusargs("HQM_ENQ_ROBENA") || $test$plusargs("HQM_USE_CQORD_QUEUE"))
          end //--if(gen_hcw_trans.is_ord==0)  

       end //--if(gen_hcw_trans.qe_valid==0 && gen_hcw_trans.qe_orsp==1) 

    end else begin
       //-- DIRCQ --//
       comp_idx = 32'hffffffff;
       if (gen_hcw_trans.is_ldb) begin
          if (i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].exp_errors.ill_comp) begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - illegal completion (expected)",comp_idx), UVM_LOW)
          end else begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - illegal completion",comp_idx))
          end 
        end else begin
          if (i_hqm_cfg.dir_pp_cq_cfg[pf_cq].exp_errors.ill_comp) begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - illegal completion (expected)",comp_idx), UVM_LOW)
          end else begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("HCW - illegal completion",comp_idx))
          end 
        end 
    end 
  end else if (gen_hcw_trans.qe_valid && gen_hcw_trans.qe_orsp && gen_hcw_trans.reord && !gen_hcw_trans.ingress_drop) begin
    //-- qe_valid=1, qe_orsp=1; reord=1  => FRAG
    //-- ORD_FRAG :: comp_idx[31:28]=4'b1000
    comp_idx = 32'h8fffffff;
  end else begin
    comp_idx = 32'hffffffff;
  end 

  adj_is_ldb = gen_hcw_trans.is_ldb;

  i_hqm_pp_cq_status.st_trfidle_clr(gen_hcw_trans.is_ldb, enq_hcw_trans.ppid);
 

  //`uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_HCW_isldb=%0d_PP=0x%0x, GENCMD=(v=%0d/o=%0d/u=%0d/t=%0d) ENQCMD=(v=%0d/o=%0d/u=%0d/t=%0d), QTYPE=%0s QID 0x%0x QPRI %0d LOCKID 0x%0x NO_DEC %0d tbcnt=0x%0x cmp_id=0x%0x, ingress_drop=%0d, comp_idx=0x%0x is_ord=%0d; 2ndP(reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x ordpri=%0d ordlockid=0x%0x reordidx=0x%0x)",
  //               gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, gen_hcw_trans.qe_valid, gen_hcw_trans.qe_orsp, gen_hcw_trans.qe_uhl, gen_hcw_trans.cq_pop, enq_hcw_trans.qe_valid, enq_hcw_trans.qe_orsp, enq_hcw_trans.qe_uhl, enq_hcw_trans.cq_pop, enq_hcw_trans.qtype.name(), enq_hcw_trans.qid, enq_hcw_trans.qpri, enq_hcw_trans.lockid, enq_hcw_trans.no_inflcnt_dec, enq_hcw_trans.iptr, enq_hcw_trans.cmp_id, gen_hcw_trans.ingress_drop, comp_idx, gen_hcw_trans.is_ord, gen_hcw_trans.reord, gen_hcw_trans.frg_num, gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_last, gen_hcw_trans.ordidx, gen_hcw_trans.ordqid, gen_hcw_trans.ordpri, gen_hcw_trans.ordlockid, gen_hcw_trans.reordidx ),UVM_LOW)

  `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_HCW_isldb=%0d_PP=0x%0x, ENQCMD=(v=%0d/o=%0d/u=%0d/t=%0d), QTYPE=%0s QID 0x%0x QPRI %0d LOCKID 0x%0x NO_DEC %0d tbcnt=0x%0x cmp_id=0x%0x, ingress_drop=%0d, comp_idx=0x%0x is_ord=%0d; 2ndP(reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x ordpri=%0d ordlockid=0x%0x reordidx=0x%0x)",
                 gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.qe_valid, enq_hcw_trans.qe_orsp, enq_hcw_trans.qe_uhl, enq_hcw_trans.cq_pop, enq_hcw_trans.qtype.name(), enq_hcw_trans.qid, enq_hcw_trans.qpri, enq_hcw_trans.lockid, enq_hcw_trans.no_inflcnt_dec, enq_hcw_trans.iptr, enq_hcw_trans.cmp_id, gen_hcw_trans.ingress_drop, comp_idx, gen_hcw_trans.is_ord, gen_hcw_trans.reord, gen_hcw_trans.frg_num, gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_last, gen_hcw_trans.ordidx, gen_hcw_trans.ordqid, gen_hcw_trans.ordpri, gen_hcw_trans.ordlockid, gen_hcw_trans.reordidx ),UVM_LOW)

  //-------------------------------
  //-- When it's a Valid (new/renq)
  //-------------------------------
  //if (gen_hcw_trans.qe_valid) begin
  if (gen_hcw_trans.qe_valid & enq_hcw_trans.qe_valid) begin
    //-- ENQ: NEW/NEW_T/RENQ/RENQ_T --
    if (!gen_hcw_trans.ingress_drop) begin
      if (i_hqm_cfg.is_sciov_mode()) begin
        pf_qid = i_hqm_cfg.get_sciov_qid(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b1,enq_hcw_trans.is_nm_pf);
      end else begin
        pf_qid = i_hqm_cfg.get_pf_qid(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b1,enq_hcw_trans.is_nm_pf);
      end 

      gen_pp = i_hqm_cfg.get_pf_pp(gen_hcw_trans.is_vf, gen_hcw_trans.vf_num, gen_hcw_trans.is_ldb, gen_hcw_trans.ppid);
      pp_type_pp = { adj_is_ldb, 7'(gen_pp) };
      gen_hcw_trans.pp_type_pp = pp_type_pp;
      enq_hcw_trans.pp_type_pp = pp_type_pp;
      gen_hcw_trans.pf_qid     = pf_qid;
      enq_hcw_trans.pf_qid     = pf_qid;
      i_hqm_pp_cq_status.enq_status_upd(gen_hcw_trans);

      is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(pf_qid); 

     //`uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_ENQHCW_isldb=%0d_PP=0x%0x (is_vf=%0d vf_num=%0d), GENCMD=(v=%0d/o=%0d/u=%0d/t=%0d) ENQCMD=(v=%0d/o=%0d/u=%0d/t=%0d), QTYPE=%0s QID 0x%0x PF_QID 0x%0x QPRI %0d LOCKID 0x%0x NO_DEC %0d tbcnt=0x%0x, pp_type_pp=0x%0x comp_idx=0x%0x wu=%0d; meas=%0d idsi=0x%0x is_ord=%0d; 2ndP(reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x ordpri=%0d ordlockid=0x%0x reordidx=0x%0x)",
     //            gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.is_vf, enq_hcw_trans.vf_num, gen_hcw_trans.qe_valid, gen_hcw_trans.qe_orsp, gen_hcw_trans.qe_uhl, gen_hcw_trans.cq_pop, enq_hcw_trans.qe_valid, enq_hcw_trans.qe_orsp, enq_hcw_trans.qe_uhl, enq_hcw_trans.cq_pop, enq_hcw_trans.qtype.name(),  enq_hcw_trans.qid, enq_hcw_trans.pf_qid, enq_hcw_trans.qpri, enq_hcw_trans.lockid, enq_hcw_trans.no_inflcnt_dec, enq_hcw_trans.iptr, pp_type_pp, comp_idx, enq_hcw_trans.wu, enq_hcw_trans.meas, enq_hcw_trans.idsi, gen_hcw_trans.is_ord, gen_hcw_trans.reord, gen_hcw_trans.frg_num, gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_last, gen_hcw_trans.ordidx, gen_hcw_trans.ordqid, gen_hcw_trans.ordpri, gen_hcw_trans.ordlockid,gen_hcw_trans.reordidx),UVM_LOW)

     `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGENQ_ENQHCW_isldb=%0d_PP=0x%0x, ENQCMD=(v=%0d/o=%0d/u=%0d/t=%0d), QTYPE=%0s QID 0x%0x PF_QID 0x%0x QPRI %0d LOCKID 0x%0x NO_DEC %0d tbcnt=0x%0x, pp_type_pp=0x%0x comp_idx=0x%0x wu=%0d; meas=%0d idsi=0x%0x is_ord=%0d, is_ao_cfg_v=%0d; 2ndP(reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x ordpri=%0d ordlockid=0x%0x reordidx=0x%0x)",
                 gen_hcw_trans.is_ldb, enq_hcw_trans.ppid, enq_hcw_trans.qe_valid, enq_hcw_trans.qe_orsp, enq_hcw_trans.qe_uhl, enq_hcw_trans.cq_pop, enq_hcw_trans.qtype.name(),  enq_hcw_trans.qid, enq_hcw_trans.pf_qid, enq_hcw_trans.qpri, enq_hcw_trans.lockid, enq_hcw_trans.no_inflcnt_dec, enq_hcw_trans.iptr, pp_type_pp, comp_idx, enq_hcw_trans.wu, enq_hcw_trans.meas, enq_hcw_trans.idsi, gen_hcw_trans.is_ord, is_ao_cfg_v, gen_hcw_trans.reord, gen_hcw_trans.frg_num, gen_hcw_trans.frg_cnt, gen_hcw_trans.frg_last, gen_hcw_trans.ordidx, gen_hcw_trans.ordqid, gen_hcw_trans.ordpri, gen_hcw_trans.ordlockid,gen_hcw_trans.reordidx),UVM_LOW)

      case (enq_hcw_trans.qtype)
        QDIR: begin
          if (comp_idx[31:28] == 4'b1111 || comp_idx[31:28] == 4'b0000 || comp_idx[31:28] == 4'b0011 ) begin
            hcw_dir_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
          end else if((gen_hcw_trans.qe_uhl && comp_idx[31:28] == 4'b0100) || (gen_hcw_trans.reord && comp_idx[31:28] == 4'b1000)) begin
            hcw_ord2p_qid_q_access_sm.get(1);
            hcw_ord2p_dir_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
            hcw_ord2p_qid_q_access_sm.put(1);
          end 
        end 
        QUNO: begin
          if (comp_idx[31:28] == 4'b1111 || comp_idx[31:28] == 4'b0000 || comp_idx[31:28] == 4'b0011 ) begin
            hcw_uno_ldb_qid_q_access_sm.get(1);
            hcw_uno_ldb_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
            hcw_uno_ldb_qid_q_access_sm.put(1);
          end else if((gen_hcw_trans.qe_uhl && comp_idx[31:28] == 4'b0100) || (gen_hcw_trans.reord && comp_idx[31:28] == 4'b1000)) begin
            hcw_ord2p_qid_q_access_sm.get(1);
            hcw_ord2p_uno_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
            hcw_ord2p_qid_q_access_sm.put(1);
          end 
        end 
        QATM: begin
          if (comp_idx[31:28] == 4'b1111 || comp_idx[31:28] == 4'b0000 || comp_idx[31:28] == 4'b0011 ) begin
            hcw_ldb_qid_q_access_sm.get(1);
            hcw_atm_ldb_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
            if (fid_limit[pf_qid]) begin
                uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Enqueue after fid_limit has been reached for pf_qid=0x%0x", pf_qid), UVM_LOW);
                enq_after_fid_limit[pf_qid] = 1'b1;
            end else begin
                enq_after_fid_limit[pf_qid] = 1'b0;
            end 
            hcw_ldb_qid_q_access_sm.put(1);
          end else if((gen_hcw_trans.qe_uhl && comp_idx[31:28] == 4'b0100) || (gen_hcw_trans.reord && comp_idx[31:28] == 4'b1000)) begin
            hcw_ord2p_qid_q_access_sm.get(1);
            hcw_ord2p_atm_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
            hcw_ord2p_qid_q_access_sm.put(1);
          end 
        end 
        QORD: begin
          if (comp_idx[31:28] == 4'b1111 || comp_idx[31:28] == 4'b0000 || comp_idx[31:28] == 4'b0011 ) begin
            hcw_ldb_qid_q_access_sm.get(1);
            hcw_ord1p_ldb_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
            hcw_ldb_qid_q_access_sm.put(1);
          end else if((gen_hcw_trans.qe_uhl && comp_idx[31:28] == 4'b0100) || (gen_hcw_trans.reord && comp_idx[31:28] == 4'b1000)) begin
            hcw_ord2p_qid_q_access_sm.get(1);
            hcw_ord2p_ord_qid_q[pp_type_pp][pf_qid][gen_hcw_trans.qpri].hcw_q.push_back(gen_hcw_trans);
            hcw_ord2p_qid_q_access_sm.put(1);
          end 
        end 
      endcase

      hcw_enq_q.push_back(gen_hcw_trans);
      hcw_enq_tbcnt_q.push_back(gen_hcw_trans.tbcnt);
    end else begin      // ingress_drop - return credit
       //-- ENQ DROP --
    end 
  end else begin
    //-- NON-ENQ --
      gen_pp = i_hqm_cfg.get_pf_pp(gen_hcw_trans.is_vf, gen_hcw_trans.vf_num, gen_hcw_trans.is_ldb, gen_hcw_trans.ppid);
      pp_type_pp = { adj_is_ldb, 7'(gen_pp) };
      gen_hcw_trans.pp_type_pp = pp_type_pp;

      i_hqm_pp_cq_status.enq_status_upd(gen_hcw_trans);
  end 

  //-------------------------------
  //-- When it's a COMP (comp/renq)
  //-- HQMV30:AO-- Two cases: gen_hcw_trans.qe_orsp==0 (COMP) and gen_hcw_trans.qe_orsp==1 (A_COMP)
  //-------------------------------
  if (gen_hcw_trans.qe_uhl && gen_hcw_trans.is_ldb && !gen_hcw_trans.ingress_drop) begin
    //-- COMP/COMP_T/RENQ/RENQ_T --//
    case (comp_idx[31:28])
      //----------------------
      4'b0000: begin      // ATM completion: HQMV30:AO-- Two cases:are considered
        if (hcw_sch_atm_count[comp_idx] > 0) begin
          hcw_sch_atm_count[comp_idx]--;

          uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_ATM_ENQCOMP_DECR - PP 0x%0x curr_tbcnt 0x%0x hcw_sch_atm_count[0x%0x]=%0d hcw_sch_atm_cq[0x%0x]=%0d", enq_hcw_trans.ppid, enq_hcw_trans.tbcnt, comp_idx, hcw_sch_atm_count[comp_idx], comp_idx, hcw_sch_atm_cq[comp_idx]), UVM_LOW);

          if (hcw_sch_atm_count[comp_idx] == 0) begin
            hcw_sch_atm_count.delete(comp_idx);
            hcw_sch_atm_cq.delete(comp_idx);
            uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_ATM_ENQCOMP_REMOVE - PP 0x%0x curr_tbcnt 0x%0x hcw_sch_atm_count[0x%0x]=%0d hcw_sch_atm_cq[0x%0x]=%0d", enq_hcw_trans.ppid, enq_hcw_trans.tbcnt, comp_idx, hcw_sch_atm_count[comp_idx], comp_idx, hcw_sch_atm_cq[comp_idx]), UVM_LOW);
          end 
        end else begin
          if (i_hqm_cfg.ldb_qid_cfg[pf_qid].exp_errors.unexp_atm_comp[gen_hcw_trans.qpri]) begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("TRACE_ATOMIC_ATM_ENQCOMP - unexpected ATM completion with comp_idx=0x%0x (expected)",comp_idx),UVM_LOW)
          end else begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("TRACE_ATOMIC_ATM_ENQCOMP - unexpected ATM completion with comp_idx=0x%0x",comp_idx))
          end 
        end 
        foreach (ldb_sch_atm_qid[qid]) begin
            if (ldb_sch_atm_qid[qid].exists(comp_idx)) begin
                ldb_sch_atm_qid[qid][comp_idx]--;
                if (ldb_sch_atm_qid[qid][comp_idx] == 0) begin
                    ldb_sch_atm_qid[qid].delete(comp_idx);
                end 
                break;
            end 
        end 
      end 
      //----------------------
      4'b0100: begin      // ORD completion: V2/V25: support  RENQ/RENQ_T or  COMP/COMP_T to end 2nd pass

          //--moved to above two cases
          remove_from_ord_queue(comp_idx[25:19],comp_idx[18:16],gen_hcw_trans);
      end 

      //----------------------
      4'b0011: begin      // COMP completion: HQMV30:AO --A_COMP only -- check atomicity of COMB (HQMV30)
        if (hcw_sch_comb_count[comp_idx] > 0) begin
          hcw_sch_comb_count[comp_idx]--;

          uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_COMB_ENQACOMP_DECR - PP 0x%0x curr_tbcnt 0x%0x hcw_sch_comb_count[0x%0x]=%0d hcw_sch_comb_cq[0x%0x]=%0d", enq_hcw_trans.ppid, enq_hcw_trans.tbcnt, comp_idx, hcw_sch_comb_count[comp_idx], comp_idx, hcw_sch_comb_cq[comp_idx]), UVM_LOW);

          if (hcw_sch_comb_count[comp_idx] == 0) begin
            hcw_sch_comb_count.delete(comp_idx);
            hcw_sch_comb_cq.delete(comp_idx);
            uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_COMB_ENQACOMP_REMOVE - PP 0x%0x curr_tbcnt 0x%0x hcw_sch_comb_count[0x%0x]=%0d hcw_sch_comb_cq[0x%0x]=%0d", enq_hcw_trans.ppid, enq_hcw_trans.tbcnt, comp_idx, hcw_sch_comb_count[comp_idx], comp_idx, hcw_sch_comb_cq[comp_idx]), UVM_LOW);
          end 
        end else begin
          if (i_hqm_cfg.ldb_qid_cfg[pf_qid].exp_errors.unexp_atm_comp[gen_hcw_trans.qpri]) begin
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("TRACE_ATOMIC_COMB_ENQACOMP - unexpected ATM completion with comp_idx=0x%0x (expected)",comp_idx),UVM_LOW)
          end else begin
            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("TRACE_ATOMIC_COMB_ENQACOMP - unexpected ATM completion with comp_idx=0x%0x",comp_idx))
          end 
        end 
      end 

      4'b1000,4'b1100: begin        // --no such case 
      end 
    endcase

    //--wu_scheduled update upon returning completion (COMP only)
    if(i_hqm_cfg.ldb_pp_cq_cfg[enq_hcw_trans.ppid].wu_limit > 0 && gen_hcw_trans.qe_orsp==0 && !$test$plusargs("HQM_BYPASS_WU_TRACE")) 
        i_hqm_pp_cq_status.remove_hcw_from_ldb_cq_bkt(enq_hcw_trans.ppid);
  end //--if (gen_hcw_trans.qe_uhl && gen_hcw_trans.is_ldb && !gen_hcw_trans.ingress_drop

  gen_hcw_trans.is_ldb  = adj_is_ldb;   // adjust is_ldb for DM case

endtask : process_enq_hcw


//-----------------------------------------------------------
//-- remove_from_ord_queue
//-- HCW saved upon SCHED received
//-- When returning completion (renq/renq_t/comp/comp_t) check from hcw_ord_ldb_qid_q to remove it
//-----------------------------------------------------------
function bit hqm_tb_hcw_scoreboard::remove_from_ord_queue(bit [hqm_pkg::NUM_LDB_QID-1:0] qid, bit [2:0] qpri, hcw_transaction hcw_trans);
  int                   idx_l[$];
  int                   replay_idx_l[$];

  remove_from_ord_queue = 1'b0;

  if(hcw_trans.reord==1 && hcw_trans.frg_last==1) begin
     //-----------------------------------
     //--reord flow: FRAG/RENQ/COMP tbcnt is curr_tbcnt; ordidx is 1st ORD's tbcnt; 
     //--reord flow: REAG/RENQ/COMP all have reord=1
     //--reord flow: RENQ/COMP have frg_last=1; remove_from_ord_queue is called upon receiving RENQ/COMP to terminate reord flow, and remove 1st ORD HCW from hcw_ord_ldb_qid_q
     //-----------------------------------
     idx_l = hcw_ord_ldb_qid_q[qid][qpri].hcw_q.find_first_index with ( item.tbcnt == hcw_trans.ordidx );  
  end else begin
     idx_l = hcw_ord_ldb_qid_q[qid][qpri].hcw_q.find_first_index with ( item.tbcnt == hcw_trans.tbcnt );  
  end 

  if (idx_l.size() > 0 ) begin		  
    remove_from_ord_queue = 1'b1;
    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue(qid=0x%0x, qpri=%0d, tbcnt=0x%0x), (reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x) idx_l.size=%0d ",qid,qpri,hcw_trans.tbcnt, hcw_trans.reord, hcw_trans.frg_num,hcw_trans.frg_cnt,hcw_trans.frg_last, hcw_trans.ordidx, hcw_trans.ordqid, idx_l.size()),UVM_LOW)
    hcw_ord_ldb_qid_q[qid][qpri].qtype_mask_q.delete(idx_l[0]);
    hcw_ord_ldb_qid_q[qid][qpri].hcw_q.delete(idx_l[0]);

    //-----------------------------------
    //-- Check replay sequence here
    //-- before receiving RENQ/COMP, RTL should not send out any FRAGs, the reord FRAGs should all exist in hcw_enq_q
    //-- zero-frag case: skip replay checking
    //-- ingress_drop case: skip replay checking
    //-----------------------------------
    if(hcw_trans.reord==1 && hcw_trans.frg_cnt>0 && hcw_trans.frg_last==1 && hcw_trans.ingress_drop==0) begin
       replay_idx_l = hcw_enq_q.find_index with (item.reord == 1 && item.ordidx == hcw_trans.ordidx && item.ordqid == hcw_trans.ordqid);  
      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue_replay_check (tbcnt=0x%0x reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x) replay_idx_l.size=%0d ", hcw_trans.tbcnt, hcw_trans.reord, hcw_trans.frg_num,hcw_trans.frg_cnt,hcw_trans.frg_last, hcw_trans.ordidx, hcw_trans.ordqid, replay_idx_l.size()),UVM_LOW)

       if(replay_idx_l.size() != hcw_trans.frg_cnt && hcw_trans.frg_cnt<=HQM_FRAG_MAX) begin
           if(i_hqm_cfg.ldb_pp_cq_cfg[hcw_trans.ppid].exp_errors.remove_ord_pp==1)
             `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue_replay_check_fail (tbcnt=0x%0x reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x) replay_idx_l.size=%0d hcw_trans.ppid=0x%0x",hcw_trans.tbcnt, hcw_trans.reord, hcw_trans.frg_num,hcw_trans.frg_cnt,hcw_trans.frg_last, hcw_trans.ordidx, hcw_trans.ordqid, replay_idx_l.size(), hcw_trans.ppid))
           else
             `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue_replay_check_fail (tbcnt=0x%0x reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x) replay_idx_l.size=%0d",hcw_trans.tbcnt, hcw_trans.reord, hcw_trans.frg_num,hcw_trans.frg_cnt,hcw_trans.frg_last, hcw_trans.ordidx, hcw_trans.ordqid, replay_idx_l.size()))
             //--HQMV30_ROB_ORD `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue_replay_check_fail (tbcnt=0x%0x reord=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d ordidx=0x%0x ordqid=0x%0x) replay_idx_l.size=%0d",hcw_trans.tbcnt, hcw_trans.reord, hcw_trans.frg_num,hcw_trans.frg_cnt,hcw_trans.frg_last, hcw_trans.ordidx, hcw_trans.ordqid, replay_idx_l.size()))
       end 
    end 
  end 

  if (idx_l.size() != 1 ) begin		  
    if (i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.remove_ord_q[qpri]) begin
      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue(qid=0x%0x, qpri=%0d, tbcnt=0x%0x) - illegal number of matching tbcnt values = %d (expected)",qid,qpri,hcw_trans.tbcnt,idx_l.size()),UVM_LOW)
    end else if($test$plusargs("HQM_ORD_QID_Q_RELAXEDCHECK")) begin
      //-- when running with +HQM_ORD_QID_Q_RELAXEDCHECK
      //-- it's used in hqm_pp_cq_based_seq set of sequences when cmp_type_sel=3 (don't use sched tbcnt as renq/renq_t/comp/comp_t tbcnt, in such case, it loses track of the original tbcnt and can't use this hcw_ord_ldb_qid_q which is push_back in SCHED)
      `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue(qid=0x%0x, qpri=%0d, tbcnt=0x%0x) - illegal number of matching tbcnt values = %d +HQM_ORD_QID_Q_RELAXEDCHECK",qid,qpri,hcw_trans.tbcnt,idx_l.size()))
    end else begin
      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("remove_from_ord_queue(qid=0x%0x, qpri=%0d, tbcnt=0x%0x) - illegal number of matching tbcnt values = %d",qid,qpri,hcw_trans.tbcnt,idx_l.size()))
    end 
  end 
endfunction : remove_from_ord_queue

function bit hqm_tb_hcw_scoreboard::check_ord_queue(hcw_transaction hcw_trans_in, output hcw_transaction hcw_trans_out);
  int                   idx_l[$];

  check_ord_queue = 1'b0;
  
  if(hcw_trans_in.reord==1 && hcw_trans_in.frg_last==0) begin
       //--For 2nd PASS HCWs, don't remove until it's reord=1 && hcw_trans_in.frg_last==1
      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_ord_queue:: return 1 reord:frag with qid=0x%0x, qpri=%0d, qtype=%s, tbcnt=0x%0x (reorder=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d) ",hcw_trans_in.qid,hcw_trans_in.qpri, hcw_trans_in.qtype.name(),hcw_trans_in.tbcnt, hcw_trans_in.reord, hcw_trans_in.frg_num,hcw_trans_in.frg_cnt,hcw_trans_in.frg_last),UVM_LOW)
       hcw_trans_out = null;
       return(1'b1);       
  end else begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
	for (int qpri = 0 ; qpri < 8 ; qpri++) begin
	  if (hcw_ord_ldb_qid_q[qid][qpri].hcw_q.size() > 0) begin
            idx_l = hcw_ord_ldb_qid_q[qid][qpri].hcw_q.find_first_index with ( item.tbcnt == hcw_trans_in.tbcnt );  

            if (idx_l.size() > 0) begin
              hcw_trans_out = hcw_ord_ldb_qid_q[qid][qpri].hcw_q[idx_l[0]];

              if (hcw_ord_ldb_qid_q[qid][qpri].qtype_mask_q[idx_l[0]][hcw_trans_in.qtype]) begin
        	if (i_hqm_cfg.ldb_qid_cfg[qid].exp_errors.ord_out_of_order[qpri]) begin
        	  `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Ordered HCW out of order qid=0x%0x, qpri=%0d, qtype=%s, tbcnt=0x%0x (expected)",qid,qpri,hcw_trans_in.qtype.name(),hcw_trans_in.tbcnt),UVM_LOW)
        	end else begin
        	  `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Ordered HCW out of order qid=0x%0x, qpri=%0d, qtype=%s, tbcnt=0x%0x",qid,qpri,hcw_trans_in.qtype.name(),hcw_trans_in.tbcnt))
        	end 
              end 

              for (int i = 0 ; i < idx_l[0] ; i++) begin
        	hcw_ord_ldb_qid_q[qid][qpri].qtype_mask_q[i][hcw_trans_in.qtype] = 1'b1;
              end 

              //--remove hcw on frg_last
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_ord_queue:: return 1 reord:terminate with qid=0x%0x, qpri=%0d, qtype=%s, tbcnt=0x%0x (reorder=%0d frg_num=%0d frg_cnt=%0d frg_last=%0d) ",qid,qpri,hcw_trans_in.qtype.name(),hcw_trans_in.tbcnt, hcw_trans_in.reord, hcw_trans_in.frg_num,hcw_trans_in.frg_cnt,hcw_trans_in.frg_last),UVM_LOW)
              hcw_ord_ldb_qid_q[qid][qpri].hcw_q.delete(idx_l[0]);
              hcw_ord_ldb_qid_q[qid][qpri].qtype_mask_q.delete(idx_l[0]);
              return(1'b1);
            end 
	  end 
	end 
      end 
  end 

  //--for 1st pass hcw, it should return 0 and null
  hcw_trans_out = null;

  return (1'b0);
endfunction : check_ord_queue


function bit hqm_tb_hcw_scoreboard::check_reord_queue(hcw_transaction hcw_trans_in, int pf_cq, output hcw_transaction hcw_trans_out);
  int                   idx_l[$];
  int                   ordidx_l[$];
  int                   reordidx_l[$];
  int                   replay_l[$];
  
  check_reord_queue = 1'b0; 
  hcw_trans_out = null;  
  
  `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue to find PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x reordidx=0x%0x;; reord=%0d ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x ordidx=0x%0x;hqm_pkg::LDB_QID_WIDTH=%0d",
                   hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.reordidx, hcw_trans_in.reord, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid,hcw_trans_in.ordidx, hqm_pkg::LDB_QID_WIDTH),UVM_LOW)


   case(hcw_trans_in.qtype)
   QDIR: begin
             if(hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin
                 //-- reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp; the same 1stP ordqid/ordpri; if this ordidx(1stP tbcnt) is the oldest	     
                 //-- note: ordlockid carry original {is_ldb, ppid}: source producer port 
                 ordidx_l = hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with (item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && item.ordlockid == hcw_trans_in.ordlockid && (item.ordidx < hcw_trans_in.ordidx));  

                 if (ordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.dir_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_dir_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                       if(!$test$plusargs("HQM_SCH_REORD_RELAXEDCHECK")) 
                         `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_dir_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                       else 
                         `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_dir_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))

                        for(int kk=0; kk<ordidx_l.size(); kk++) begin
                           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail_debug: hcw_ord2p_dir_qid_q[0x%0x][0x%0x][0x%0x].hcw_q[%0d].ordidx=0x%0x tbcnt=0x%0x", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qpri, kk, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[ordidx_l[kk]].ordidx, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[ordidx_l[kk]].tbcnt), UVM_MEDIUM)
                        end 

                       for(int kk=0; kk<hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size(); kk++) begin
                             `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: hcw_ord2p_dir_qid_q.hcw_q[%0d].hcw.ordidx=0x%0x", kk, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[kk].ordidx), UVM_MEDIUM)
                       end 
                    end 
                 end	
             end	

             if(hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin
                 //--this is to check the ordering on the 2nd-pass reord flow. reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp; the same 1stP ordidx/ordqid/ordpri; if this reord hcw.tbcnt is the oldest	     
                 reordidx_l = hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.ordidx == hcw_trans_in.ordidx && item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && (item.tbcnt < hcw_trans_in.tbcnt));  

                 if (reordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.dir_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_dir_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_dir_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_dir_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                 end 
             end	               
             end	               

             foreach (hcw_ord2p_dir_qid_q[pp]) begin
                 //--this is to check the ordering on the 2nd-pass reord flow.
                 idx_l = hcw_ord2p_dir_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.tbcnt == hcw_trans_in.tbcnt  );  

                 if (idx_l.size() > 0) begin
                   hcw_trans_out = hcw_ord2p_dir_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[idx_l[0]]; 
                   hcw_ord2p_dir_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.delete(idx_l[0]); 

                   //--comment out this checking and use the above checking method, because 2nd pass ordering checking rely on 1st pass with the same ordqid/ordpri/(ordidx)
                   if (hcw_trans_in.reord && (get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt) <= get_hcw_enq_tbcnt_index(hcw_ord2p_dir_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_dir_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0]))) begin
                      //`uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue CQ out of order - LDB CQ 0x%0x QTYPE QDIR QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                      //       pf_cq, hcw_trans_in.pf_qid, hcw_trans_in.qpri, hcw_trans_out.tbcnt, get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt),
                      //       hcw_ord2p_dir_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0],
                      //       get_hcw_enq_tbcnt_index(hcw_ord2p_dir_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_dir_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0])))
                    end 

                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x found received curr_tbcnt=0x%0x, curr hcw_ord2p_dir_qid_q.size=%0d",
                                                   pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_ord2p_dir_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()),UVM_LOW)
                   check_reord_queue = 1'b1; 
                   hcw_ord2p_dir_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri] = {1'b1,hcw_trans_out.tbcnt};
                   break;
                 end else begin
                    hcw_trans_out = null;		   
                 end  
             end	               
	 end 
   QUNO: begin
             if(hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin
                 //-- reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp; the same 1stP ordqid/ordpri; if this ordidx(1stP tbcnt) is the oldest	     
                 //-- note: ordlockid carry original {is_ldb, ppid}: source producer port 
                 ordidx_l = hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with (item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && item.ordlockid == hcw_trans_in.ordlockid && (item.ordidx < hcw_trans_in.ordidx));  

                 if (ordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.ldb_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_uno_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                       if(!$test$plusargs("HQM_SCH_REORD_RELAXEDCHECK")) 
                          `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_uno_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                       else
                          `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_uno_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))

                        for(int kk=0; kk<ordidx_l.size(); kk++) begin
                           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail_debug: hcw_ord2p_uno_qid_q[0x%0x][0x%0x][0x%0x].hcw_q[%0d].ordidx=0x%0x tbcnt=0x%0x", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qpri, kk, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[ordidx_l[kk]].ordidx, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[ordidx_l[kk]].tbcnt), UVM_MEDIUM)
                        end 

                        for(int kk=0; kk<hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size(); kk++) begin
                           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail_debug: current hcw_ord2p_uno_qid_q[0x%0x][0x%0x][0x%0x].hcw_q[%0d].ordidx=0x%0x tbcnt=0x%0x", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qpri, kk, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[kk].ordidx, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[kk].tbcnt), UVM_MEDIUM)
                        end 
                    end 
                 end	
             end	

             if(hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin 
                 //--this is to check the ordering on the 2nd-pass reord flow. reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp; the same 1stP ordidx/ordqid/ordpri; if this reord hcw.tbcnt is the oldest	     
                 reordidx_l = hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.ordidx == hcw_trans_in.ordidx && item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && (item.tbcnt < hcw_trans_in.tbcnt));  

                 if (reordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.ldb_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_uno_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_uno_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                 end 
             end 
             end 
	     
             foreach (hcw_ord2p_uno_qid_q[pp]) begin
                 //--this is to check the ordering on the 2nd-pass reord flow.
                 idx_l = hcw_ord2p_uno_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.tbcnt == hcw_trans_in.tbcnt );  

                 if (idx_l.size() > 0) begin
                   hcw_trans_out = hcw_ord2p_uno_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[idx_l[0]]; 
                   hcw_ord2p_uno_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.delete(idx_l[0]); 
		   
                   //--comment out this checking and use the above checking method, because 2nd pass ordering checking rely on 1st pass with the same ordqid/ordpri/(ordidx)
                   if (hcw_trans_in.reord && (get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt) <= get_hcw_enq_tbcnt_index(hcw_ord2p_uno_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_uno_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0]))) begin
                      //`uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue CQ out of order - LDB CQ 0x%0x QTYPE QUNO QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                      //       pf_cq, hcw_trans_in.pf_qid, hcw_trans_in.qpri, hcw_trans_out.tbcnt, get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt),
                      //       hcw_ord2p_uno_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0],
                      //       get_hcw_enq_tbcnt_index(hcw_ord2p_uno_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_uno_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0])))
                    end 
		   
                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x found received curr_tbcnt=0x%0x, curr hcw_ord2p_uno_qid_q.size=%0d",
                                                   pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_ord2p_uno_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()),UVM_LOW)
                   check_reord_queue = 1'b1; 
                   hcw_ord2p_uno_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri] = {1'b1,hcw_trans_out.tbcnt};
                   break;
                 end else begin
                    hcw_trans_out = null;		   
                 end  
             end	               
	 end 
   QATM: begin
             if(hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin
                 //-- reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp; the same 1stP ordqid/ordpri; if this ordidx(1stP tbcnt) is the oldest	     
                 ordidx_l = hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with (item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && item.ordlockid == hcw_trans_in.ordlockid && (item.ordidx < hcw_trans_in.ordidx));  

                 if (ordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.ldb_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                       `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_atm_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                        if(!$test$plusargs("HQM_SCH_REORD_RELAXEDCHECK")) 
                          `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_atm_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                        else
                          `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_atm_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))

                        for(int kk=0; kk<ordidx_l.size(); kk++) begin
                           `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail_debug: hcw_ord2p_atm_qid_q[0x%0x][0x%0x][0x%0x].hcw_q[%0d].ordidx=0x%0x tbcnt=0x%0x", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qpri, kk, hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[ordidx_l[kk]].ordidx, hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[ordidx_l[kk]].tbcnt), UVM_MEDIUM)
                        end 

                    end 
                 end	
             end	

             if(hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin
                 //--this is to check the ordering on the 2nd-pass reord flow. reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp/lockid; the same 1stP ordidx/ordqid/ordpri; if this reord hcw.tbcnt is the oldest	     
                 reordidx_l = hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.ordidx == hcw_trans_in.ordidx && item.lockid == hcw_trans_in.lockid && item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && (item.tbcnt < hcw_trans_in.tbcnt)); //--remove && item.ordlockid == hcw_trans_in.ordlockid 

                 if (reordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.ldb_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_atm_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_atm_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_atm_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                    end 
                 end	
             end	

             foreach (hcw_ord2p_atm_qid_q[pp]) begin
                 //--this is to check the ordering on the 2nd-pass reord flow.
                 idx_l = hcw_ord2p_atm_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.tbcnt == hcw_trans_in.tbcnt );  

                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x found received curr_tbcnt=0x%0x, idx_l.size=%0d, dbg_curr hcw_ord2p_atm_qid_q.size=%0d",
                                                   pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt,idx_l.size(), hcw_ord2p_atm_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()),UVM_LOW)

                 if (idx_l.size() > 0) begin
                   hcw_trans_out = hcw_ord2p_atm_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[idx_l[0]]; 
                   hcw_ord2p_atm_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.delete(idx_l[0]); 

                   //--comment out this checking and use the above checking method, because 2nd pass ordering checking rely on 1st pass with the same ordqid/ordpri/(ordidx)
                   if (hcw_trans_in.reord && (get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt) <= get_hcw_enq_tbcnt_index(hcw_ord2p_atm_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_atm_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0]))) begin
                      //`uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue CQ out of order - LDB CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                      //       pf_cq, hcw_trans_in.pf_qid, hcw_trans_in.qpri, hcw_trans_out.tbcnt, get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt),
                      //       hcw_ord2p_atm_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0],
                      //       get_hcw_enq_tbcnt_index(hcw_ord2p_atm_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_atm_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0])))
                    end 

                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x found received curr_tbcnt=0x%0x, curr hcw_ord2p_atm_qid_q.size=%0d",
                                                   pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_ord2p_atm_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()),UVM_LOW)
                   check_reord_queue = 1'b1; 
                   hcw_ord2p_atm_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri] = {1'b1,hcw_trans_out.tbcnt};
                   break;
                 end else begin
                    hcw_trans_out = null;		   
                 end 
             end	
	 end 
   QORD: begin
             if(hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin
                 //-- reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp; the same 1stP ordqid/ordpri; if this ordidx(1stP tbcnt) is the oldest	     
                 ordidx_l = hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with (item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && (item.ordidx < hcw_trans_in.ordidx));  

                 if (ordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.ldb_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_ord_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                        if(!$test$plusargs("HQM_SCH_REORD_RELAXEDCHECK")) 
                          `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_ord_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                        else
                          `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ordidx_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x(reordidx); ORDQID 0x%0x ORDPRI %0d ORDLOCKID 0x%0x, ORDIDX 0x%0x not oldest in hcw_ord2p_ord_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri, hcw_trans_in.ordlockid, hcw_trans_in.ordidx, hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                    end 
                 end //if (ordidx_l.size() > 0)   
             end 

             if(hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size() > 0 && hcw_trans_in.reord) begin
                 //--this is to check the ordering on the 2nd-pass reord flow. reorder flow ordering check: check with the same 2ndP qid/pri/qtype/pp; the same 1stP ordidx/ordqid/ordpri; if this reord hcw.tbcnt is the oldest	     
                 reordidx_l = hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.ordidx == hcw_trans_in.ordidx && item.ordqid == hcw_trans_in.ordqid && item.ordpri == hcw_trans_in.ordpri && (item.tbcnt < hcw_trans_in.tbcnt));  

                 if (reordidx_l.size() > 0) begin  
                    if (i_hqm_cfg.ldb_qid_cfg[hcw_trans_in.pf_qid].exp_errors.sch_out_of_order[hcw_trans_in.qpri]) begin
                      `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_ord_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()), UVM_MEDIUM)
                    end else begin
                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue_reord_ordering_ckfail: PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x; ORDQID 0x%0x ORDPRI %0d ORDIDX 0x%0x tbcnt=0x%0x(reordidx) not oldest in hcw_ord2p_ord_qid_q.size=%0d", hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.ordidx, hcw_trans_in.tbcnt, hcw_trans_in.ordqid, hcw_trans_in.ordpri,hcw_trans_in.tbcnt, hcw_ord2p_ord_qid_q[hcw_trans_in.pp_type_pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()))
                 end 
             end	
             end	

             foreach (hcw_ord2p_ord_qid_q[pp]) begin
                 //--this is to check the ordering on the 2nd-pass reord flow.
                 idx_l = hcw_ord2p_ord_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.find_first_index with ( item.tbcnt == hcw_trans_in.tbcnt );  

                 if (idx_l.size() > 0) begin
                   hcw_trans_out = hcw_ord2p_ord_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q[idx_l[0]]; 
                   hcw_ord2p_ord_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.delete(idx_l[0]); 

                   //--comment out this checking and use the above checking method, because 2nd pass ordering checking rely on 1st pass with the same ordqid/ordpri/(ordidx)
                   if (hcw_trans_in.reord && (get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt) <= get_hcw_enq_tbcnt_index(hcw_ord2p_ord_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_ord_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0]))) begin
                      //`uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue CQ out of order - LDB CQ 0x%0x QTYPE QORD QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                      //       pf_cq, hcw_trans_in.pf_qid, hcw_trans_in.qpri, hcw_trans_out.tbcnt, get_hcw_enq_tbcnt_index(1'b1,hcw_trans_out.tbcnt),
                      //       hcw_ord2p_ord_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0],
                      //       get_hcw_enq_tbcnt_index(hcw_ord2p_ord_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][64], hcw_ord2p_ord_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri][63:0])))
                   end 
   
                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x found received curr_tbcnt=0x%0x, curr hcw_ord2p_ord_qid_q.size=%0d",
                                                   pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt, hcw_ord2p_ord_qid_q[pp][hcw_trans_in.pf_qid][hcw_trans_in.qpri].hcw_q.size()),UVM_LOW)
                   check_reord_queue = 1'b1;
                   hcw_ord2p_ord_ldb_cq_last_tbcnt[pp][pf_cq][hcw_trans_in.pf_qid][hcw_trans_in.qpri] = {1'b1,hcw_trans_out.tbcnt};
                   break;
                 end else begin
                    hcw_trans_out = null;		   
                 end 
             end	
	 end 
   endcase 	  
   
   if(check_reord_queue==0) begin 
    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_reord_queue NOT found PP 0x%0x QID 0x%0x (QID 0x%0x) QPRI %0d QTYPE %0s LOCKID 0x%0x curr_tbcnt=0x%0x",
                   hcw_trans_in.pp_type_pp, hcw_trans_in.pf_qid, hcw_trans_in.qid, hcw_trans_in.qpri, hcw_trans_in.qtype.name(), hcw_trans_in.lockid, hcw_trans_in.tbcnt),UVM_LOW)
   end 
endfunction : check_reord_queue



task hqm_tb_hcw_scoreboard::process_sch_hcw(hcw_transaction sch_hcw_trans);
  hcw_transaction       enq_hcw_trans;
  hcw_transaction       nxt_hcw_trans;
  hcw_transaction       reord_nxt_hcw_trans;
  int                   idx_l[$];
  int                   qid_idx_l[$];
  bit [6:0]             pf_qid, sch_pf_qid;
  bit [6:0]             pf_cq;
  int                   comp_idx;
  int                   comb_a_comp_idx;
  int                   comb_comp_idx;
  bit                   nxt_hcw_search_done;
  int                   vas;
  int                   init_avail_credit;
  int                   qid_depth_threshold;
  int                   is_ao_cfg_v;
  bit [1:0]             enq_qtype_val;
 
    
  //------     
  //-- find original hcw from trfgen_enqhcw_q:  hcw_tr_rebuild has original information
  //------   
  if (hcw_enq_q.size() > 0) begin
    idx_l = hcw_enq_q.find_first_index with ( item.tbcnt == sch_hcw_trans.tbcnt );  

    if (idx_l.size() > 0 ) begin		  
      enq_hcw_trans = hcw_enq_q[idx_l[0]];

      hcw_enq_q.delete(idx_l[0]); 

      if (i_hqm_cfg.is_sciov_mode()) begin
         pf_qid = i_hqm_cfg.get_sciov_qid(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b0,enq_hcw_trans.is_nm_pf);
      end else begin
         pf_qid = i_hqm_cfg.get_pf_qid(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,(enq_hcw_trans.qtype != QDIR),enq_hcw_trans.qid,1'b0,enq_hcw_trans.is_nm_pf);
         //--anyan_modify_02182021
         if(sch_hcw_trans.sch_is_ldb && (!$test$plusargs("HQM_SCH_PF_QID_CHECK"))) begin
            sch_pf_qid = i_hqm_cfg.get_pf_qid(sch_hcw_trans.is_vf,sch_hcw_trans.vf_num,(enq_hcw_trans.qtype != QDIR),sch_hcw_trans.qid,1'b0,sch_hcw_trans.is_nm_pf);
         end 
      end 

      pf_cq = i_hqm_cfg.get_pf_pp(sch_hcw_trans.is_vf, sch_hcw_trans.vf_num, sch_hcw_trans.sch_is_ldb ,sch_hcw_trans.ppid);

      // Get VAS for CQ
      vas = i_hqm_cfg.get_vas(sch_hcw_trans.is_ldb,pf_cq);

      init_avail_credit   = i_hqm_cfg.vas_cfg[vas].credit_cnt; 

      calc_latency(enq_hcw_trans,pf_cq,pf_qid,sch_hcw_trans.meas,sch_hcw_trans.idsi);

      nxt_hcw_search_done       = 0;

      i_hqm_pp_cq_status.sch_status_upd(sch_hcw_trans.sch_is_ldb, pf_cq, pf_qid, sch_hcw_trans.is_error, enq_hcw_trans);
      i_hqm_pp_cq_status.st_trfidle_clr(sch_hcw_trans.sch_is_ldb, pf_cq); 


      //--check wu passed through
      if(enq_hcw_trans.wu != sch_hcw_trans.wu) 
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_WUCK %0s CQ 0x%0x QTYPE %0s QID 0x%0x WU doesn't match: enq_hcw_trans.wu %0d sch_hcw_trans.wu %0d", (sch_hcw_trans.sch_is_ldb == 1) ? "LDB" : "DIR", pf_cq, enq_hcw_trans.qtype.name(), pf_qid, enq_hcw_trans.wu, sch_hcw_trans.wu))


      if(sch_hcw_trans.sch_is_ldb) begin
         //--wu_scheduled update upon receiving sch ldb hcw
         if(i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].wu_limit > 0 || i_hqm_cfg.hqmproc_trfston==1) 
            i_hqm_pp_cq_status.add_hcw_to_ldb_cq_bkt(pf_cq, i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].wu_limit, i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].wu_limit_tolerance, i_hqm_cfg.hqmproc_lspblockwu, enq_hcw_trans);

         //--check qid consistency
         if(i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[0].qidv == 0 &&
            i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[1].qidv == 0 && 
            i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[2].qidv == 0 && 
            i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[3].qidv == 0 && 
            i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[4].qidv == 0 && 
            i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[5].qidv == 0 && 
            i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[6].qidv == 0 && 
            i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[7].qidv == 0  
           )
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_QIDCK %0s CQ 0x%0x QTYPE %0s QID 0x%0x not valid", (sch_hcw_trans.sch_is_ldb == 1) ? "LDB" : "DIR", pf_cq, enq_hcw_trans.qtype.name(), pf_qid))

          //--check qid consistency
          if(i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].cq_pcq==1 && pf_cq%2==0) begin
           if( (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[0].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[0].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[1].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[1].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[2].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[2].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[3].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[3].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[4].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[4].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[5].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[5].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[6].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[6].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[7].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[7].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[0].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[0].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[1].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[1].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[2].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[2].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[3].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[3].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[4].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[4].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[5].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[5].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[6].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[6].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[7].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq+1].qidix[7].qidv == 1) )
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_QIDCK %0s CQ 0x%0x and PCQ 0x%0x  QTYPE %0s QID 0x%0x not programmed", (sch_hcw_trans.sch_is_ldb == 1) ? "LDB" : "DIR", pf_cq, (pf_cq+1), enq_hcw_trans.qtype.name(), pf_qid))        

          end else begin
           if( (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[0].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[0].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[1].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[1].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[2].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[2].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[3].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[3].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[4].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[4].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[5].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[5].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[6].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[6].qidv == 1) &&
             (pf_qid != i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[7].qid && i_hqm_cfg.ldb_pp_cq_cfg[pf_cq].qidix[7].qidv == 1) ) 
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_QIDCK %0s CQ 0x%0x QTYPE %0s QID 0x%0x not programmed", (sch_hcw_trans.sch_is_ldb == 1) ? "LDB" : "DIR", pf_cq, enq_hcw_trans.qtype.name(), pf_qid))        
          end 

         //--check is_ao_cfg_v
         is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(pf_qid);

         //--enq_qtype_val (AO (COMB):  enq_qtype_val=0, ATM with is_ao_cfg_v=1)
         if(enq_hcw_trans.qtype == QDIR)      enq_qtype_val=3;
         else if(enq_hcw_trans.qtype == QORD) enq_qtype_val=2;
         else if(enq_hcw_trans.qtype == QUNO) enq_qtype_val=1;
         else if(enq_hcw_trans.qtype == QATM) enq_qtype_val=0;

         //--log
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_HCW_LDB (IS_VF %0d VF_NUM %0d) CQ 0x%0x QTYPE %0s VQID 0x%0x (ENQ QID 0x%0x SCH QID 0x%0x) QPRI %0d LOCKID 0x%0x received curr_tbcnt=0x%0x is_ao_cfg_v=%0d enq_qtype_val=%0d cmp_id=0x%0x qid_depth=%0d enq_hcw.wu=%0d wu=%0d meas=%0d idsi=0x%0x",
                                                       sch_hcw_trans.is_vf, sch_hcw_trans.vf_num, pf_cq, enq_hcw_trans.qtype.name(), sch_hcw_trans.qid, pf_qid, sch_pf_qid, sch_hcw_trans.qpri, sch_hcw_trans.lockid, sch_hcw_trans.tbcnt, is_ao_cfg_v, enq_qtype_val, sch_hcw_trans.cmp_id, sch_hcw_trans.qid_depth, enq_hcw_trans.wu, sch_hcw_trans.wu, sch_hcw_trans.meas,sch_hcw_trans.idsi),UVM_LOW)
      end else begin
         enq_qtype_val=3; 
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_HCW_DIR (IS_VF %0d VF_NUM %0d) CQ 0x%0x QTYPE %0s VQID 0x%0x QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x qid_depth=%0d  enq_hcw.wu=%0d wu=%0d meas=%0d idsi=0x%0x enq_qtype_val=%0d",
                                                       sch_hcw_trans.is_vf, sch_hcw_trans.vf_num, pf_cq, enq_hcw_trans.qtype.name(), sch_hcw_trans.qid, pf_qid, sch_hcw_trans.qpri, sch_hcw_trans.tbcnt, sch_hcw_trans.qid_depth, enq_hcw_trans.wu, sch_hcw_trans.wu, sch_hcw_trans.meas,sch_hcw_trans.idsi, enq_qtype_val),UVM_LOW)
      end 

      if (enq_hcw_trans.qtype == QDIR)         qid_depth_threshold = i_hqm_cfg.dir_qid_cfg[pf_qid].dir_qid_depth_thresh;
      else if (enq_hcw_trans.qtype == QATM)    qid_depth_threshold = i_hqm_cfg.ldb_qid_cfg[pf_qid].atm_qid_depth_thresh;
      else                                     qid_depth_threshold = i_hqm_cfg.ldb_qid_cfg[pf_qid].nalb_qid_depth_thresh; 

      //-- congestion check
      if (qid_depth_threshold/2 >= init_avail_credit) begin
         if(sch_hcw_trans.qid_depth >= 1)
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_CKQIDDEPTH %0s CQ 0x%0x QTYPE %0s QID 0x%0x QID_DEPTH %0d not expect >=1, curr_tbcnt=0x%0x/init_credid=%0d/qid_depth_threshold=%0d/vas=%0d",(sch_hcw_trans.sch_is_ldb == 1) ? "LDB" : "DIR", pf_cq, enq_hcw_trans.qtype.name(), pf_qid, sch_hcw_trans.qid_depth, sch_hcw_trans.tbcnt, init_avail_credit, qid_depth_threshold, vas))
      end else if ((qid_depth_threshold*3)/4 >= init_avail_credit) begin
         if(sch_hcw_trans.qid_depth >= 2)
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_CKQIDDEPTH %0s CQ 0x%0x QTYPE %0s QID 0x%0x QID_DEPTH %0d not expect >=2, curr_tbcnt=0x%0x/init_credid=%0d/qid_depth_threshold=%0d/vas=%0d",(sch_hcw_trans.sch_is_ldb == 1) ? "LDB" : "DIR", pf_cq, enq_hcw_trans.qtype.name(), pf_qid, sch_hcw_trans.qid_depth, sch_hcw_trans.tbcnt, init_avail_credit, qid_depth_threshold, vas))
      end else if (qid_depth_threshold >= init_avail_credit) begin
         if(sch_hcw_trans.qid_depth == 3)
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHED_CKQIDDEPTH %0s CQ 0x%0x QTYPE %0s QID 0x%0x QID_DEPTH %0d not expect =3, curr_tbcnt=0x%0x/init_credid=%0d/qid_depth_threshold=%0d/vas=%0d",(sch_hcw_trans.sch_is_ldb == 1) ? "LDB" : "DIR", pf_cq, enq_hcw_trans.qtype.name(), pf_qid, sch_hcw_trans.qid_depth, sch_hcw_trans.tbcnt, init_avail_credit, qid_depth_threshold, vas))
      end  


      //----------------------------------------------------------
      //----------------------------------------------------------
      while (!nxt_hcw_search_done) begin
        case (enq_hcw_trans.qtype)
          //-------------------------//
          //-------------------------//
          QDIR: begin
              if(sch_hcw_trans.sch_is_ldb==0 && enq_qtype_val==3) begin
                   if (check_ord_queue(enq_hcw_trans,nxt_hcw_trans) == 1'b0) begin
                       foreach (hcw_dir_qid_q[pp]) begin
                           qid_idx_l = hcw_dir_qid_q[pp][pf_qid][enq_hcw_trans.qpri].hcw_q.find_first_index with ( item.tbcnt == sch_hcw_trans.tbcnt );  

                           if (qid_idx_l.size() > 0) begin
                               nxt_hcw_trans = hcw_dir_qid_q[pp][pf_qid][enq_hcw_trans.qpri].hcw_q[qid_idx_l[0]];
                               hcw_dir_qid_q[pp][pf_qid][enq_hcw_trans.qpri].hcw_q.delete(qid_idx_l[0]);
                               `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ ordering check - DIR CQ 0x%0x QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                                pf_cq,pf_qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt),
                                                                hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0],
                                                                get_hcw_enq_tbcnt_index(hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64],hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0])), UVM_MEDIUM)

                               if (get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp) < get_hcw_enq_tbcnt_index(hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64],hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0], 1, pp)) begin
                                 if (i_hqm_cfg.dir_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
                                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - DIR CQ 0x%0x QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                                pf_cq,pf_qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                            hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0],
                                                            get_hcw_enq_tbcnt_index(hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64],hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0], 1, pp)), UVM_MEDIUM)
                                 end else begin
                                   `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - DIR CQ 0x%0x QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                                pf_cq,pf_qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                            hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0],
                                                            get_hcw_enq_tbcnt_index(hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64],hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0], 1, pp)))
                                 end 
                               end 
                               hcw_dir_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri] = {1'b1,nxt_hcw_trans.tbcnt};
                               break;
                           end else begin
                               nxt_hcw_trans = null;
                           end 
                       end 
                   end 
            end else if(sch_hcw_trans.sch_is_ldb==0 && is_ao_cfg_v==1 && enq_qtype_val==3) begin
                uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DEBUGSCHCQ: CQ 0x%0x QTYPE QDIR QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x; is_ao_cfg_v=1: ENQ QTYPE=DIR Wrong traffic", pf_cq,pf_qid,enq_hcw_trans.qpri,sch_hcw_trans.tbcnt));
            end //if(sch_hcw_trans.sch_is_ldb==0 && is_ao_cfg_v==0 && enq_qtype_val==3) 
         end //--QDIR: begin

        //-------------------------//
        //-------------------------//
        QUNO: begin
           if(sch_hcw_trans.sch_is_ldb==1 && is_ao_cfg_v==0 && enq_qtype_val==1) begin
            ldb_cq_comp_q[pf_cq].hcw_comp_q.push_back(32'hffffffff);
            if (check_ord_queue(enq_hcw_trans,nxt_hcw_trans) == 1'b0) begin
               hcw_uno_ldb_qid_q_access_sm.get(1);
               foreach (hcw_uno_ldb_qid_q[pp]) begin

                  qid_idx_l = hcw_uno_ldb_qid_q[pp][pf_qid][enq_hcw_trans.qpri].hcw_q.find_first_index with ( item.tbcnt == sch_hcw_trans.tbcnt );  

                  if (qid_idx_l.size() > 0) begin
                    nxt_hcw_trans = hcw_uno_ldb_qid_q[pp][pf_qid][enq_hcw_trans.qpri].hcw_q[qid_idx_l[0]];
                    hcw_uno_ldb_qid_q[pp][pf_qid][enq_hcw_trans.qpri].hcw_q.delete(qid_idx_l[0]);
                   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ ordering check - LDB CQ 0x%0x QTYPE QUNO QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                           pf_cq,pf_qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt),
                                                           hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64], hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0])), UVM_MEDIUM)

                    if (get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp) < get_hcw_enq_tbcnt_index(hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64], hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0], 1, pp)) begin
                       if (i_hqm_cfg.ldb_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
                          `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - LDB CQ 0x%0x QTYPE QUNO QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                           pf_cq,pf_qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                           hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64], hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0], 1, pp)), UVM_MEDIUM)
                       end else begin
                          `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - LDB CQ 0x%0x QTYPE QUNO QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                           pf_cq,pf_qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                           hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][64], hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri][63:0], 1, pp)))
                       end 
                    end 

                    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DBG_LDB CQ 0x%0x QTYPE QUNO QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x, prev_tbcnt=0x%0x ",
                                                         pf_cq,pf_qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri] ),UVM_MEDIUM)

                    hcw_uno_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][enq_hcw_trans.qpri] = {1'b1,nxt_hcw_trans.tbcnt};
                    break;
                  end else begin
                    nxt_hcw_trans = null;
                  end 
              end 
              hcw_uno_ldb_qid_q_access_sm.put(1);
            end 
           end else if(sch_hcw_trans.sch_is_ldb==1 && is_ao_cfg_v==1 && enq_qtype_val==1) begin
                uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("DEBUGSCHCQ: CQ 0x%0x QTYPE QUNO QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x; is_ao_cfg_v=1: ENQ QTYPE=UNO Wrong traffic", pf_cq,pf_qid,enq_hcw_trans.qpri,sch_hcw_trans.tbcnt));
           end //--if(sch_hcw_trans.sch_is_ldb==1 && is_ao_cfg_v==0 && enq_qtype_val==1) 
        end //--QUNO: begin

        //-------------------------//
        //-------------------------//
        QATM: begin
          //-- Including both regular ATM case with is_ao_cfg_v=0; and HQMV30 AO case which has ENQ_QTYPE=ATM (00) with is_ao_cfg_v=1
          if(sch_hcw_trans.sch_is_ldb==1 && enq_qtype_val==0) begin
            if ( unsigned'(hcw_sch_atm_count.sum()) >= 2048) begin
                uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_ATM_Number of ATM QEs exceeds(%d) the max. number of ATM QEs(%0d) that can be inflight", unsigned'(hcw_sch_atm_count.sum()), 2048));
            end 

            if ( unsigned'(hcw_sch_comb_count.sum()) >= 2048) begin
                uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_COMB_Number of ATM QEs exceeds(%d) the max. number of ATM QEs(%0d) that can be inflight", unsigned'(hcw_sch_atm_count.sum()), 2048));
            end 

            if (check_ord_queue(enq_hcw_trans,nxt_hcw_trans) == 1'b0) begin
              hcw_ldb_qid_q_access_sm.get(1);

              //--ordering check (This part needs to be revisited due to lockid dimension)
              foreach (hcw_atm_ldb_qid_q[pp]) begin
                  qid_idx_l = hcw_atm_ldb_qid_q[pp][pf_qid][sch_hcw_trans.qpri].hcw_q.find_first_index with ( item.tbcnt == sch_hcw_trans.tbcnt); //-- && item.lockid == sch_hcw_trans.lockid);  

                  if (qid_idx_l.size() > 0) begin
                    nxt_hcw_trans = hcw_atm_ldb_qid_q[pp][pf_qid][sch_hcw_trans.qpri].hcw_q[qid_idx_l[0]];
                    hcw_atm_ldb_qid_q[pp][pf_qid][sch_hcw_trans.qpri].hcw_q.delete(qid_idx_l[0]);
                    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ ordering check - LDB CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d LOCKID 0x%0x received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x), is_ao_cfg_v=%0d",
                                                           pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.lockid,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt),
                                                           hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0]), is_ao_cfg_v), UVM_MEDIUM)

                    if (get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp) < get_hcw_enq_tbcnt_index(hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0], 1, pp)) begin
                       if (hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][80:65]==sch_hcw_trans.lockid) begin
                          if (i_hqm_cfg.ldb_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
                             `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - LDB CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d LOCKID 0x%0x received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                           pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.lockid,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                           hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0], 1, pp)), UVM_MEDIUM)
                          end else begin
                             `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - LDB CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d LOCKID 0x%0x received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                           pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.lockid,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                           hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0], 1, pp)))
                          end 
                       end 
                    end 

                    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ_LDB CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d LOCKID 0x%0x received curr_tbcnt=0x%0x, prev_lockid=0x%0x prev_tbcnt=0x%0x is_ao_cfg_v=%0d",
                                                         pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.lockid, nxt_hcw_trans.tbcnt,hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][80:65], nxt_hcw_trans.tbcnt,hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64:0],is_ao_cfg_v),UVM_MEDIUM)

                    hcw_atm_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri] = {nxt_hcw_trans.lockid,1'b1,nxt_hcw_trans.tbcnt};
                    break;
                  end else begin
                    nxt_hcw_trans = null;
                  end 
              end //--foreach
              if (nxt_hcw_trans==null) begin
                    `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("Atomic HCW scheduled - cannot find matching tbcnt and lockid in hcw_atm_ldb_qid_q (sch_hcw_trans cq=%0d qtype=%0s qid=%0d qpri=%0d lockid=0x%04x tbcnt=0x%0x)", pf_cq,enq_hcw_trans.qtype.name(),sch_hcw_trans.qid,sch_hcw_trans.qpri,sch_hcw_trans.lockid, sch_hcw_trans.tbcnt))
              end 

              hcw_ldb_qid_q_access_sm.put(1);
            end 


            //---------------------------------------
            //--  comp_idx processing
            //---------------------------------------
            //--ATM: comp_idx formation 
            //---------------------------------------
            comp_idx = (pf_qid << 19) + (enq_hcw_trans.qpri << 16) + enq_hcw_trans.lockid;
            comb_a_comp_idx =  32'h30000000 + comp_idx;
            comb_comp_idx   =  32'h40000000 + comp_idx; //--should be 32'h40000000 ??? //--TMP:: when hqm_pp_cq_base_seq doesn't run with HQM_USE_CQORD_QUEUE
  
            if(is_ao_cfg_v==1) begin
                //-- COMB: ATM_ORD (HQMV30)
                ldb_cq_a_comp_q[pf_cq].hcw_comp_q.push_back(comb_a_comp_idx);
               `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ_LDB_ATM_A_COMP_IDX: CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x comb_a_comp_idx=0x%0x when comp_idx=0x%0x, ldb_cq_a_comp_q[%0d].hcw_comp_q.size=%0d, ldb_sch_atm_qid[%0d].num=%0d is_ao_cfg_v=%0d",
                                              pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.tbcnt, comb_a_comp_idx, comp_idx, pf_cq, ldb_cq_a_comp_q[pf_cq].hcw_comp_q.size(), pf_qid, ldb_sch_atm_qid[pf_qid].num(), is_ao_cfg_v),UVM_MEDIUM)

                if( $test$plusargs("HQM_USE_CQORD_QUEUE")) begin 
                   //--HQMV30 Enhancement
                   hcw_ldb_cq_ord_q_access_sm.get(1);
                   ldb_cq_ord_q[pf_cq].hcw_q.push_back(sch_hcw_trans);
                   hcw_ldb_cq_ord_q_access_sm.put(1);
                  `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ_LDB_ATMCOMB_COMP_IDX__HQM_USE_CQORD_QUEUE: CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x comp_idx=0x%0x, ldb_cq_ord_q[%0d].hcw_q.size=%0d is_ao_cfg_v=%0d",
                                              pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.tbcnt, comp_idx, pf_cq, ldb_cq_ord_q[pf_cq].hcw_q.size(), is_ao_cfg_v),UVM_MEDIUM)
                end else begin
                   //-- without +HQM_USE_CQORD_QUEUE:: still use ldb_cq_comp_q[pf_cq].hcw_comp_q to keep tracking comb_comp_idx
                   ldb_cq_comp_q[pf_cq].hcw_comp_q.push_back(comb_comp_idx);
                  `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ_LDB_ATMCOMB_COMP_IDX__REGULAR: CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x comb_comp_idx=0x%0x when comp_idx=0x%0x, ldb_cq_comp_q[%0d].hcw_comp_q.size=%0d, ldb_sch_atm_qid[%0d].num=%0d is_ao_cfg_v=%0d",
                                              pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.tbcnt, comb_comp_idx, comp_idx, pf_cq, ldb_cq_comp_q[pf_cq].hcw_comp_q.size(), pf_qid, ldb_sch_atm_qid[pf_qid].num(), is_ao_cfg_v),UVM_MEDIUM)
 
                end 
            end else begin
                //--regular ATM (HQMV25)
                ldb_cq_comp_q[pf_cq].hcw_comp_q.push_back(comp_idx);
               `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ_LDB_ATM_COMP_IDX: CQ 0x%0x QTYPE QATM QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x comp_idx=0x%0x, ldb_cq_comp_q[%0d].hcw_comp_q.size=%0d, ldb_sch_atm_qid[%0d].num=%0d is_ao_cfg_v=%0d",
                                              pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.tbcnt, comp_idx, pf_cq, ldb_cq_comp_q[pf_cq].hcw_comp_q.size(), pf_qid, ldb_sch_atm_qid[pf_qid].num(), is_ao_cfg_v),UVM_MEDIUM)
            end 


            //---------------------------------------
            //--V3_AO: TBA
            //---------------------------------------
            if(is_ao_cfg_v==1) begin
                if(!$test$plusargs("HQM_ORD_QID_Q_RELAXEDCHECK")) begin  //--+HQM_ORD_QID_Q_RELAXEDCHECK:: when hqm_pp_cq_base_seq doesn't run with HQM_USE_CQORD_QUEUE, and runs with cmd_type_sel=3(renq/renq_t/comp/comp_t tbcnt is not the original tbcnt, it's newly generated tbcnt)
                     hcw_ord_ldb_qid_q[pf_qid][enq_hcw_trans.qpri].hcw_q.push_back(sch_hcw_trans);
                     hcw_ord_ldb_qid_q[pf_qid][enq_hcw_trans.qpri].qtype_mask_q.push_back(4'h0);
                    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DBG_LDB_ATMCOMB_COMP_IDX: CQ 0x%0x QTYPE QORD QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x, ldb_cq_comp_q[%0d].hcw_comp_q.size=%0d, ldb_cq_ord_q[%0d].hcw_q.size=%0d; sch_hcw_trans put to hcw_ord_ldb_qid_q[%0d][%0d].size=%0d, is_ao_cfg_v=%0d",
                                                         pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.tbcnt, pf_cq, ldb_cq_comp_q[pf_cq].hcw_comp_q.size(),  pf_cq, ldb_cq_ord_q[pf_cq].hcw_q.size(), pf_qid, enq_hcw_trans.qpri, hcw_ord_ldb_qid_q[pf_qid][enq_hcw_trans.qpri].hcw_q.size(), is_ao_cfg_v ),UVM_MEDIUM)
                end 
            end 


            //---------
            // -- 12 is added due to internal hardware pipelining (Refer Joe's mail subject : FID limit scenario)
            // -- +1 (HQMV2); in HQMV25, +4 for tolerance because of LSP QID affinity change
            if ( ldb_sch_atm_qid[pf_qid].num() >= (i_hqm_cfg.ldb_qid_cfg[pf_qid].fid_limit + 4 + 12) ) begin
                if($test$plusargs("HQM_BYPASS_FID_CHECK")) 
                   uvm_report_warning("HQM_TB_HCW_SCOREBOARD", $psprintf("More flow-ids(%0d) used by PF QID(0x%0x) then configured(%0d) with +HQM_BYPASS_FID_CHECK", ldb_sch_atm_qid[pf_qid].num(), pf_qid, (i_hqm_cfg.ldb_qid_cfg[pf_qid].fid_limit + 1 + 12) ));
                else
                   uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("More flow-ids(%0d) used by PF QID(0x%0x) then configured(%0d)", ldb_sch_atm_qid[pf_qid].num(), pf_qid, (i_hqm_cfg.ldb_qid_cfg[pf_qid].fid_limit + 1 + 12) ));
            end else begin
                   uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Now flow-ids(%0d) used by PF QID(0x%0x) with configured(%0d) ", ldb_sch_atm_qid[pf_qid].num(), pf_qid, (i_hqm_cfg.ldb_qid_cfg[pf_qid].fid_limit + 1 + 12) ), UVM_HIGH);
            end 
            if (ldb_sch_atm_qid[pf_qid].exists(comp_idx)) begin
                uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Atomic HCW scheduled - PF QID(0x%0x)/lockid(0x%0x) combination already exists", pf_qid, enq_hcw_trans.lockid), UVM_MEDIUM);
                ldb_sch_atm_qid[pf_qid][comp_idx]++;
            end else begin
                uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Atomic HCW scheduled - PF QID(0x%0x)/lockid(0x%0x) combination fist time seen", pf_qid, enq_hcw_trans.lockid), UVM_MEDIUM);
                ldb_sch_atm_qid[pf_qid][comp_idx] = 1;
            end 

            // -- The below logic is added so that in case of hcw_ldb_test:atm_fixed_pri, we can verify that fid_limit has reached
            // -- https://hsdes.intel.com/appstore/article/#/14010178070 (10072019 fix the checking. 
            // -- The former check is  if ldb_sch_atm_qid[pf_qid].num() > (i_hqm_cfg.ldb_qid_cfg[pf_qid].fid_limit + 1) 
            // -- loose the check as:
            if ( ( ldb_sch_atm_qid[pf_qid].num() > (i_hqm_cfg.ldb_qid_cfg[pf_qid].fid_limit ) ) && ( ldb_sch_atm_qid[pf_qid].num() <= (i_hqm_cfg.ldb_qid_cfg[pf_qid].fid_limit + 12 + 1) ) ) begin
                uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("FID limit(0x%0x) reached for QID 0x%0x", ldb_sch_atm_qid[pf_qid].num(), pf_qid), UVM_LOW);
                fid_limit[pf_qid] = 1'b1;
            end else begin
                fid_limit[pf_qid] = 1'b0;
            end 

            if(is_ao_cfg_v==1) begin
                //---------------------------------------
                //--HHQMV30: COMB atomicity tracing support (A_COMP flow) :hcw_sch_comb_count[comb_a_comp_idx]
                //---------------------------------------
                if (hcw_sch_comb_count.exists(comb_a_comp_idx)) begin
                   if (pf_cq != hcw_sch_comb_cq[comb_a_comp_idx]) begin
                     `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("TRACE_ATOMIC_COMB_Atomic HCW scheduled for unexpected CQ (is_vf=%0d vf_num=%0d cq=%0d qtype=%s qid=%d qpri=%0d lockid=0x%04x tbcnt=0x%0x) hcw_sch_comb_count[0x%0x]=%0d hcw_sch_comb_cq[0x%0x]=%0d",
                                                       enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,pf_cq,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,enq_hcw_trans.lockid,enq_hcw_trans.tbcnt, comb_a_comp_idx, hcw_sch_comb_count[comb_a_comp_idx], comb_a_comp_idx, hcw_sch_comb_cq[comb_a_comp_idx]))
                   end 
                   hcw_sch_comb_count[comb_a_comp_idx]++;
                   uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_COMB_SCHCONT_INCR - CQ 0x%0x QID 0x%0x LOCKID 0x%0x curr_tbcnt 0x%0x hcw_sch_comb_count[0x%0x]=%0d hcw_sch_comb_cq[0x%0x]=%0d", pf_cq, pf_qid, enq_hcw_trans.lockid, enq_hcw_trans.tbcnt, comb_a_comp_idx, hcw_sch_comb_count[comb_a_comp_idx], comb_a_comp_idx, hcw_sch_comb_cq[comb_a_comp_idx]), UVM_MEDIUM);
                end else begin
                   hcw_sch_comb_count[comb_a_comp_idx] = 1;
                   hcw_sch_comb_cq[comb_a_comp_idx] = pf_cq;
                   uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_COMB_SCHCONT_ADDNEW - CQ 0x%0x QID 0x%0x LOCKID 0x%0x curr_tbcnt 0x%0x hcw_sch_comb_count[0x%0x]=%0d hcw_sch_comb_cq[0x%0x]=%0d", pf_cq, pf_qid, enq_hcw_trans.lockid, enq_hcw_trans.tbcnt, comb_a_comp_idx, hcw_sch_comb_count[comb_a_comp_idx], comb_a_comp_idx, hcw_sch_comb_cq[comb_a_comp_idx]), UVM_MEDIUM);
                end 

            end else begin
                //---------------------------------------
                //--V25: atomicity tracing support
                //--HHQMV30: Regular ATM atomicity tracing support : use hcw_sch_atm_count[comp_idx]
                //---------------------------------------
                if (hcw_sch_atm_count.exists(comp_idx)) begin
                   if (pf_cq != hcw_sch_atm_cq[comp_idx]) begin
                     `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("TRACE_ATOMIC_ATM_Atomic HCW scheduled for unexpected CQ (is_vf=%0d vf_num=%0d cq=%0d qtype=%s qid=%d qpri=%0d lockid=0x%04x tbcnt=0x%0x) hcw_sch_atm_count[0x%0x]=%0d hcw_sch_atm_cq[0x%0x]=%0d",
                                                       enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,pf_cq,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,enq_hcw_trans.lockid,enq_hcw_trans.tbcnt, comp_idx, hcw_sch_atm_count[comp_idx], comp_idx, hcw_sch_atm_cq[comp_idx]))
                   end 
                   hcw_sch_atm_count[comp_idx]++;
                   uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_ATM_SCHCONT_INCR - CQ 0x%0x QID 0x%0x LOCKID 0x%0x curr_tbcnt 0x%0x hcw_sch_atm_count[0x%0x]=%0d hcw_sch_atm_cq[0x%0x]=%0d", pf_cq, pf_qid, enq_hcw_trans.lockid, enq_hcw_trans.tbcnt, comp_idx, hcw_sch_atm_count[comp_idx], comp_idx, hcw_sch_atm_cq[comp_idx]), UVM_MEDIUM);
                end else begin
                   hcw_sch_atm_count[comp_idx] = 1;
                   hcw_sch_atm_cq[comp_idx] = pf_cq;
                   uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("TRACE_ATOMIC_ATM_SCHCONT_ADDNEW - CQ 0x%0x QID 0x%0x LOCKID 0x%0x curr_tbcnt 0x%0x hcw_sch_atm_count[0x%0x]=%0d hcw_sch_atm_cq[0x%0x]=%0d", pf_cq, pf_qid, enq_hcw_trans.lockid, enq_hcw_trans.tbcnt, comp_idx, hcw_sch_atm_count[comp_idx], comp_idx, hcw_sch_atm_cq[comp_idx]), UVM_MEDIUM);
                end 
            end //if(is_ao_cfg_v==1) 

          end //--if(sch_hcw_trans.sch_is_ldb==1 && enq_qtype_val==0) 
        end //--QATM: begin


        //-------------------------//
        //-------------------------//
        QORD: begin
          if(sch_hcw_trans.sch_is_ldb==1 && enq_qtype_val==2) begin
            hcw_ldb_qid_q_access_sm.get(1);

            //-- ordering check on 1st PASS
            foreach (hcw_ord1p_ldb_qid_q[pp]) begin

                  qid_idx_l = hcw_ord1p_ldb_qid_q[pp][pf_qid][sch_hcw_trans.qpri].hcw_q.find_first_index with ( item.tbcnt == sch_hcw_trans.tbcnt );  

                  if (qid_idx_l.size() > 0) begin
                    nxt_hcw_trans = hcw_ord1p_ldb_qid_q[pp][pf_qid][sch_hcw_trans.qpri].hcw_q[qid_idx_l[0]];
                    hcw_ord1p_ldb_qid_q[pp][pf_qid][sch_hcw_trans.qpri].hcw_q.delete(qid_idx_l[0]);
                    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCHCQ ordering check - LDB CQ 0x%0x QTYPE QORD QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x), is_ao_cfg_v=%0d",
                                                           pf_cq,pf_qid,sch_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt),
                                                           hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0]), is_ao_cfg_v), UVM_MEDIUM)

                    if (get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp) < get_hcw_enq_tbcnt_index(hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0], 1, pp)) begin
                         if (i_hqm_cfg.ldb_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
                            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - LDB CQ 0x%0x QTYPE QORD QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                           pf_cq,pf_qid,sch_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                           hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0], 1, pp)), UVM_MEDIUM)
                         end else begin
                            `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("CQ out of order - LDB CQ 0x%0x QTYPE QORD QID 0x%0x QPRI %0d received tbcnt=0x%0x(index=0x%0x), last tbcnt=0x%0x(index=0x%0x)",
                                                           pf_cq,pf_qid,sch_hcw_trans.qpri,nxt_hcw_trans.tbcnt,get_hcw_enq_tbcnt_index(1'b1,nxt_hcw_trans.tbcnt, 1, pp),
                                                           hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0],
                                                           get_hcw_enq_tbcnt_index(hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][64], hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri][63:0], 1, pp)))
                         end 
                    end 

                    `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DBG_LDB CQ 0x%0x QTYPE QORD QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x, prev_tbcnt=0x%0x, is_ao_cfg_v=%0d",
                                                         pf_cq,pf_qid,sch_hcw_trans.qpri,nxt_hcw_trans.tbcnt,hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri],is_ao_cfg_v ),UVM_MEDIUM)

                    hcw_ord1p_ldb_cq_last_tbcnt[pp][pf_cq][pf_qid][sch_hcw_trans.qpri] = {1'b1,nxt_hcw_trans.tbcnt};
                    break;
                  end else begin
                    nxt_hcw_trans = null;
                  end 
            end 

            if (nxt_hcw_trans==null) begin
                    `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("Ordered HCW scheduled - cannot find matching tbcnt in hcw_ord1p_ldb_qid_q (sch_hcw_trans cq=%0d qtype=%0s qid=%0d qpri=%0d lockid=0x%04x tbcnt=0x%0x)",pf_cq,enq_hcw_trans.qtype.name(),sch_hcw_trans.qid,sch_hcw_trans.qpri,sch_hcw_trans.lockid, sch_hcw_trans.tbcnt))
            end 


            hcw_ldb_qid_q_access_sm.put(1);

            //--V1/V2:
            //--V2.5 there is 1-frag (RENQ/RENQ_T) case only, RENQ/RENQ_T can be any qType/qid, temp remove marker "32'h40000000" 
            if($test$plusargs("HQM_ENQ_ROBENA") || $test$plusargs("HQM_USE_CQORD_QUEUE")) begin 
               //--HQMV30 Enhancement
               hcw_ldb_cq_ord_q_access_sm.get(1);
               ldb_cq_ord_q[pf_cq].hcw_q.push_back(sch_hcw_trans);
               hcw_ldb_cq_ord_q_access_sm.put(1);
            end else begin
               comp_idx = 32'h40000000 + (pf_qid << 19) + (enq_hcw_trans.qpri << 16);
               ldb_cq_comp_q[pf_cq].hcw_comp_q.push_back(comp_idx);
            end 

            hcw_ord_ldb_qid_q[pf_qid][enq_hcw_trans.qpri].hcw_q.push_back(sch_hcw_trans);
            hcw_ord_ldb_qid_q[pf_qid][enq_hcw_trans.qpri].qtype_mask_q.push_back(4'h0);
            `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("DBG_LDB_ORD: CQ 0x%0x QTYPE QORD QID 0x%0x QPRI %0d received curr_tbcnt=0x%0x, comp_idx=0x%0x, ldb_cq_comp_q[%0d].hcw_comp_q.size=%0d, ldb_cq_ord_q[%0d].hcw_q.size=%0d; sch_hcw_trans put to hcw_ord_ldb_qid_q[%0d][%0d].size=%0d, is_ao_cfg_v=%0d",
                          pf_cq,pf_qid,sch_hcw_trans.qpri,sch_hcw_trans.tbcnt, comp_idx, pf_cq, ldb_cq_comp_q[pf_cq].hcw_comp_q.size(),  pf_cq, ldb_cq_ord_q[pf_cq].hcw_q.size(), pf_qid, enq_hcw_trans.qpri, hcw_ord_ldb_qid_q[pf_qid][enq_hcw_trans.qpri].hcw_q.size(), is_ao_cfg_v ),UVM_MEDIUM)
          end //--if(sch_hcw_trans.sch_is_ldb==1 && enq_qtype_val==2) begin
        end //--QORD: begin
        endcase //--case

        //------------------
        if (hcw_drop_ok(enq_hcw_trans) && (sch_hcw_trans.tbcnt > nxt_hcw_trans.tbcnt)) begin
          nxt_hcw_search_done   = 0;
          `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Allowing dropped HCW (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d tbcnt 0x%0x",
                                                      nxt_hcw_trans.is_vf,nxt_hcw_trans.vf_num,nxt_hcw_trans.qtype.name(),nxt_hcw_trans.qid,nxt_hcw_trans.qpri,nxt_hcw_trans.tbcnt),UVM_LOW)
        end else begin
          nxt_hcw_search_done   = 1;
        end 
      end //--  while (!nxt_hcw_search_done)
      
      
      //----------------------------------------------------------
      if (nxt_hcw_trans != null) begin
        if (sch_hcw_trans.tbcnt != nxt_hcw_trans.tbcnt) begin
          if (enq_hcw_trans.qtype == QDIR) begin
            if (i_hqm_cfg.dir_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d) Expected tbcnt 0x%04x, Received tbcnt 0x%0x (expected)",
                                                          enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,sch_hcw_trans.tbcnt),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d) Expected tbcnt 0x%04x, Received tbcnt 0x%0x",
                                                           enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,sch_hcw_trans.tbcnt))
            end 
          end else begin
            if (i_hqm_cfg.ldb_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
              `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d) Expected tbcnt 0x%04x, Received tbcnt 0x%0x (expected)",
                                                          enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,sch_hcw_trans.tbcnt),UVM_LOW)
            end else begin
              `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d) Expected tbcnt 0x%04x, Received tbcnt 0x%0x",
                                                           enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,nxt_hcw_trans.tbcnt,sch_hcw_trans.tbcnt))
            end 
          end 
        end else begin
          `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d) tbcnt 0x%04x",
                                                      enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,sch_hcw_trans.tbcnt),UVM_LOW)
        end 
      end else begin
      
        //-- Not found from 1pass queue, check_reord_queue
        hcw_ord2p_qid_q_access_sm.get(1);
        if(check_reord_queue(enq_hcw_trans, pf_cq, reord_nxt_hcw_trans) == 0) begin
                    `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("DEBUGSCH_HCW scheduled - cannot find matching tbcnt in hcw_ord2p_<qtype>_qid_q (sch_hcw_trans cq=%0d qtype=%0s pp_type_pp=0x%0x pf_qid=%0d qid=%0d qpri=%0d lockid=0x%04x tbcnt=0x%0x)",pf_cq,enq_hcw_trans.qtype.name(),enq_hcw_trans.pp_type_pp, enq_hcw_trans.pf_qid, sch_hcw_trans.qid,sch_hcw_trans.qpri,sch_hcw_trans.lockid, sch_hcw_trans.tbcnt))
        end 
        hcw_ord2p_qid_q_access_sm.put(1);   
	   
        if(reord_nxt_hcw_trans == null && nxt_hcw_trans == null) begin

           if (enq_hcw_trans.qtype == QDIR) begin
             if (i_hqm_cfg.dir_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
               `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d tbcnt=0x%0x) - Not expected",
                                                           enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,sch_hcw_trans.tbcnt),UVM_LOW)
             end else begin
               `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d tbcnt=0x%0x) - Not expected",
                                                            enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,sch_hcw_trans.tbcnt))
             end 
           end else begin
             if (i_hqm_cfg.ldb_qid_cfg[pf_qid].exp_errors.sch_out_of_order[enq_hcw_trans.qpri]) begin
               `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d tbcnt=0x%0x) - Not expected",
                                                           enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,sch_hcw_trans.tbcnt),UVM_LOW)
             end else begin
               `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW received out of order (is_vf=%0d vf_num=%0d qtype=%s qid=%d qpri=%d tbcnt=0x%0x) - Not expected",
                                                            enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.qtype.name(),enq_hcw_trans.qid,enq_hcw_trans.qpri,sch_hcw_trans.tbcnt))
             end 
           end 
        end	
      end 

      if(!$test$plusargs("HQM_BYPASS_SCH_CHECK")) begin 
         //--anyan_modify_02182021
         if(sch_hcw_trans.sch_is_ldb == 1) sch_hcw_trans.pf_qid = sch_pf_qid;

         check_sch_hcw(sch_hcw_trans,enq_hcw_trans);       // verify scheduled HCW contents

         if (idx_l.size() > 1) begin
           `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("More than one entry (%d) in hcw_enq_q with tbcnt==0x%04x",idx_l.size(),sch_hcw_trans.tbcnt))
         end 
      end 
    end else begin
      if(!$test$plusargs("HQM_BYPASS_SCH_CHECK")) 
      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Received scheduled HCW with no matching entry in hcw_enq_q with tbcnt==0x%04x qtype=%0s qid=%0d",sch_hcw_trans.tbcnt, sch_hcw_trans.qtype.name(), sch_hcw_trans.qid))
      else
      `uvm_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("Received scheduled HCW with no matching entry in hcw_enq_q with tbcnt==0x%04x qtype=%0s qid=%0d",sch_hcw_trans.tbcnt, sch_hcw_trans.qtype.name(), sch_hcw_trans.qid))
    end 
  end else begin
    `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Received scheduled HCW no entries in hcw_enq_q with tbcnt==0x%04x",sch_hcw_trans.tbcnt))
  end 
endtask : process_sch_hcw

task hqm_tb_hcw_scoreboard::check_sch_hcw(hcw_transaction sch_hcw_trans,hcw_transaction enq_hcw_trans);
  int   pf_cq;
  int   pf_pp;
  int   cq_no_xlate_qid;
  int   cmp_enq_qid;
  bit   is_ao_cfg_v;

  pf_cq = i_hqm_cfg.get_pf_pp(sch_hcw_trans.is_vf,sch_hcw_trans.vf_num,sch_hcw_trans.is_ldb,sch_hcw_trans.ppid);
  pf_pp = i_hqm_cfg.get_pf_pp(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.is_ldb,enq_hcw_trans.ppid);


  // Verify producer port
  if (sch_hcw_trans.sch_is_ldb != enq_hcw_trans.sch_is_ldb) begin
    `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule HCW sch_is_ldb=%0d not equal to Enqueued HCW is_ldb=%0d",sch_hcw_trans.sch_is_ldb,enq_hcw_trans.is_ldb))
  end 

  if (sch_hcw_trans.lockid != enq_hcw_trans.lockid) begin
      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule DIR HCW dir_info=0x%04x does not match Enqueue HCW dir_info=0x%04x",
                                                 sch_hcw_trans.lockid, enq_hcw_trans.lockid))
  end 

  if (enq_hcw_trans.qtype == QDIR) begin
    if (sch_hcw_trans.qtype != {~enq_hcw_trans.is_ldb,~enq_hcw_trans.is_ldb}) begin
      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule DIR HCW qtype=0x%01x does not match Enqueue HCW {is_ldb,is_ldb}=0x%01x",
                                                   sch_hcw_trans.qtype,
                                                   {enq_hcw_trans.is_ldb,enq_hcw_trans.is_ldb}))
    end 

    if (i_hqm_cfg.dir_pp_cq_cfg[pf_cq].dir_cq_fmt.keep_pf_ppid) begin
      if (sch_hcw_trans.qid != pf_pp) begin
        `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule DIR HCW pf_ppid=0x%02x does not equal Enqueue HCW ppid=0x%02x (keep_pf_ppid==1)",
                                                     sch_hcw_trans.qid,
                                                     pf_pp))
      end 
    end else begin
      if (sch_hcw_trans.qid != 0) begin
        `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule DIR HCW pf_ppid=0x%02x does not equal 0 (keep_pf_ppid==0)",
                                                     sch_hcw_trans.qid))
      end 
    end 
  end else begin
    is_ao_cfg_v = i_hqm_cfg.is_ao_qid_v(sch_hcw_trans.qid); 
    if(is_ao_cfg_v==0) begin
       if (sch_hcw_trans.qtype != enq_hcw_trans.qtype) begin
         `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule LDB HCW qtype=0x%01x does not match Enqueue HCW qtype=0x%01x",
                                                   sch_hcw_trans.qtype,
                                                   enq_hcw_trans.qtype))
       end 
    end else begin
       if (sch_hcw_trans.qtype == QATM || sch_hcw_trans.qtype == QUNO) begin
         `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule LDB HCW qtype=0x%01x is not 3 when is_ao_cfg_v=1; Enqueue HCW qtype=0x%01x",
                                                   sch_hcw_trans.qtype,
                                                   enq_hcw_trans.qtype))
       end else if(sch_hcw_trans.qtype == QORD) begin
          if (sch_hcw_trans.qtype != enq_hcw_trans.qtype) begin
             `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule LDB HCW qtype=0x%01x does not match Enqueue HCW qtype=0x%01x",
                                                   sch_hcw_trans.qtype,
                                                   enq_hcw_trans.qtype))
          end 
       end else begin
          if (sch_hcw_trans.qtype == enq_hcw_trans.qtype) begin
             `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule LDB HCW qtype=0x%01x Enqueue HCW qtype=0x%01x when is_ao_cfg=1",
                                                   sch_hcw_trans.qtype,
                                                   enq_hcw_trans.qtype))
          end 
       end 
    end 

    cq_no_xlate_qid = i_hqm_cfg.get_act_ral_val("hqm_system_csr", $psprintf("ldb_cq2vf_pf_ro[%0d]",pf_cq), "is_pf");

    if (enq_hcw_trans.is_nm_pf) begin
      if (cq_no_xlate_qid) begin        // enqueued physical qid, scheduled physical qid
        cmp_enq_qid = enq_hcw_trans.qid;
      end else begin                    // enqueued physical qid, scheduled virtual qid
        cmp_enq_qid = i_hqm_cfg.get_vqid(enq_hcw_trans.qid,enq_hcw_trans.is_ldb);
      end 
    end else begin
      if (i_hqm_cfg.is_sciov_mode()) begin
        if (cq_no_xlate_qid) begin      // enqueued virtual qid, scheduled physical qid
          cmp_enq_qid = i_hqm_cfg.get_sciov_qid(enq_hcw_trans.is_ldb,enq_hcw_trans.ppid,enq_hcw_trans.is_ldb,enq_hcw_trans.qid);
        end else begin                  // enqueued virtual qid, scheduled virtual qid
          cmp_enq_qid = enq_hcw_trans.qid;
        end 
      end  else if (enq_hcw_trans.is_vf) begin
        if (cq_no_xlate_qid) begin      // enqueued virtual qid, scheduled physical qid
          cmp_enq_qid = i_hqm_cfg.get_pf_qid(enq_hcw_trans.is_vf,enq_hcw_trans.vf_num,enq_hcw_trans.is_ldb,enq_hcw_trans.qid);
        end else begin                  // enqueued virtual qid, scheduled virtual qid
          cmp_enq_qid = enq_hcw_trans.qid;
        end 
      end else begin
        if (cq_no_xlate_qid) begin      // enqueued physical qid, scheduled physical qid
          cmp_enq_qid = enq_hcw_trans.qid;
        end else begin                  // enqueued physical qid, scheduled virtual qid
          cmp_enq_qid = i_hqm_cfg.get_vqid(enq_hcw_trans.qid,enq_hcw_trans.is_ldb);
        end 
      end 
    end 

   `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_sch_hcw: cq_no_xlate_qid=%0d (SCH_HCW is_vf=%0d vf_num=%0d is_ldb=%0d qtype=%s qid=0x%02x pf_qid=0x%02x tbcnt=0x%0x)(ENQ_HCW is_vf=%0d vf_num=%0d qtype=%s qid=0x%02x pf_qid=0x%02x tbcnt=0x%0x) cmp_enq_qid=0x%02x",
               cq_no_xlate_qid, sch_hcw_trans.is_vf, sch_hcw_trans.vf_num, sch_hcw_trans.sch_is_ldb, sch_hcw_trans.qtype.name(),sch_hcw_trans.qid, sch_hcw_trans.pf_qid, sch_hcw_trans.tbcnt, enq_hcw_trans.is_vf, enq_hcw_trans.vf_num, enq_hcw_trans.qtype.name(),enq_hcw_trans.qid, enq_hcw_trans.pf_qid, enq_hcw_trans.tbcnt, cmp_enq_qid),UVM_HIGH)

    //--anyan_modify_02182021
    if(sch_hcw_trans.is_vf && sch_hcw_trans.sch_is_ldb && (!$test$plusargs("HQM_SCH_PF_QID_CHECK"))) begin 
       if (sch_hcw_trans.pf_qid != enq_hcw_trans.pf_qid) begin
        `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("check_sch_hcw: Schedule LDB HCW qid=0x%02x pf_qid=0x%02x tbcnt=0x%0x does not match LDB enqueue qid 0x%02X pf_qid 0x%02x tbcnt=0x%0x (compare pf_qid)",
                                                   sch_hcw_trans.qid,
                                                   sch_hcw_trans.pf_qid,
                                                   sch_hcw_trans.tbcnt,
                                                   enq_hcw_trans.qid,
                                                   enq_hcw_trans.pf_qid,
                                                   enq_hcw_trans.tbcnt 
                                                   ))
       end else begin
        `uvm_info("HQM_TB_HCW_SCOREBOARD",$psprintf("check_sch_hcw: Schedule LDB HCW qid=0x%02x pf_qid=0x%02x tbcnt=0x%0x match LDB enqueue qid 0x%02X pf_qid 0x%02x tbcnt=0x%0x (compare pf_qid)",
                                                   sch_hcw_trans.qid,
                                                   sch_hcw_trans.pf_qid,
                                                   sch_hcw_trans.tbcnt,
                                                   enq_hcw_trans.qid,
                                                   enq_hcw_trans.pf_qid,
                                                   enq_hcw_trans.tbcnt 
                                                   ),UVM_HIGH)
       end 
    end else begin
       if (sch_hcw_trans.qid != cmp_enq_qid) begin
        `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule LDB HCW qid=0x%02x does not match expected qid=0x%02x ",
                                                   sch_hcw_trans.qid,
                                                   cmp_enq_qid
                                                   ))
       end 
    end 
  end 

  if (enq_hcw_trans.qtype == QDIR) begin
    if (sch_hcw_trans.idsi != enq_hcw_trans.idsi && enq_hcw_trans.meas == 0) begin
      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule DIR HCW idsi=0x%04x does not match Enqueue HCW idsi=0x%04x",
                                                   sch_hcw_trans.idsi,
                                                   enq_hcw_trans.idsi))
    end 
  end else if (enq_hcw_trans.qtype != QATM) begin
    if (sch_hcw_trans.idsi != enq_hcw_trans.idsi && enq_hcw_trans.meas == 0) begin
      `uvm_error("HQM_TB_HCW_SCOREBOARD",$psprintf("Schedule %s HCW idsi=0x%04x does not match Enqueue HCW idsi=0x%04x",
                                                   enq_hcw_trans.qtype.name(),
                                                   sch_hcw_trans.idsi,
                                                   enq_hcw_trans.idsi))
    end 
  end 
endtask : check_sch_hcw

function real hqm_tb_hcw_scoreboard::calc_latency_val(int latency, int total_count);

    uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("calc_latency_val(latency=%0d, total_count=%0d) -- Start", latency, total_count), UVM_DEBUG);
    return (latency/total_count);
    uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("calc_latency_val(latency=%0d, total_count=%0d) -- End", latency, total_count), UVM_DEBUG);

endfunction : calc_latency_val

function void hqm_tb_hcw_scoreboard::set_inst_suffix(string new_inst_suffix);
  inst_suffix = new_inst_suffix;
endfunction : set_inst_suffix

function void hqm_tb_hcw_scoreboard::check_qpri_latency(int qid, int qpri_h, real latency_h, int qpri_l, real latency_l);

    uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("check_qpri_latency(qid=0x%0x, qpri_h=%0d, latency_h=%0.1f, qpri_l=%0d, latency_l=%0.1f) -- Start", qid, qpri_h, latency_h, qpri_l, latency_l), UVM_DEBUG);
    if (latency_h > latency_l) begin
        uvm_report_error("HQM_TB_HCW_SCOREBOARD", $psprintf("Latency for qpri %0d(%0.1f) is higher than latency for qpri %0d(%0.1f) for qid 0x%0x", qpri_h, latency_h, qpri_l, latency_l, qid));
    end else begin
        uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("Latency for qpri %0d(%0.1f) is less than latency for qpri %0d(%0.1f) for qid 0x%0x", qpri_h, latency_h, qpri_l, latency_l, qid), UVM_LOW);
    end 
    uvm_report_info("HQM_TB_HCW_SCOREBOARD", $psprintf("check_qpri_latency(qid=0x%0x, qpri_h=%0d, latency_h=%0.1f, qpri_l=%0d, latency_l=%0.1f) -- End", qid, qpri_h, latency_h, qpri_l, latency_l), UVM_DEBUG);

endfunction : check_qpri_latency

function void hqm_tb_hcw_scoreboard::check_cos_latency_in_bin(int bin_num, int qid_num, real ave_latency, real curr_latency, int tolerance_val);
  int diff_val;
  
  if(curr_latency > ave_latency) diff_val = curr_latency - ave_latency;   
  else                           diff_val = ave_latency - curr_latency;   

  if(diff_val > tolerance_val)  
            uvm_report_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("CoS_CK_perfck_sel=0x%0x, bin_num=%0d, qid=%0d, ave_ldb_qid_total_latency=%0d, curr_latency=%0d, diff_val=%0d > tolerance_val=%0d", i_hqm_cfg.perfck_sel, bin_num, qid_num, ave_latency, curr_latency, diff_val, tolerance_val),UVM_LOW);
  else
            uvm_report_info("HQM_TB_HCW_SCOREBOARD",$psprintf("CoS_CK_perfck_sel=0x%0x, bin_num=%0d, qid=%0d, ave_ldb_qid_total_latency=%0d, curr_latency=%0d, diff_val=%0d < tolerance_val=%0d", i_hqm_cfg.perfck_sel, bin_num, qid_num, ave_latency, curr_latency, diff_val, tolerance_val),UVM_LOW);
endfunction:check_cos_latency_in_bin

function void hqm_tb_hcw_scoreboard::check_cos_latency_bins(real ave_latency_0, real ave_latency_1, real ave_latency_2, real ave_latency_3);
  int diff_val;

  uvm_report_info("HQM_TB_HCW_SCOREBOARD",$psprintf("CoS_CK_perfck_sel=0x%0x, ave_latency_0=%0d, ave_latency_1=%0d, ave_latency_2=%0d, ave_latency_3=%0d,  perfck_tolerance_0=%0d perfck_tolerance_1=%0d perfck_tolerance_2=%0d", i_hqm_cfg.perfck_sel, ave_latency_0, ave_latency_1, ave_latency_2, ave_latency_3, i_hqm_cfg.perfck_tolerance_0, i_hqm_cfg.perfck_tolerance_1, i_hqm_cfg.perfck_tolerance_2),UVM_LOW);

  if(i_hqm_cfg.perfck_sel[7:0]=='h10) begin
     //-- all four bins have the same latency
     check_cos_latency_bins_and_report(1, 0, 1, ave_latency_0, ave_latency_1, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(1, 0, 2, ave_latency_0, ave_latency_2, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(1, 0, 3, ave_latency_0, ave_latency_3, i_hqm_cfg.perfck_tolerance_1);
   
  end else if(i_hqm_cfg.perfck_sel[7:0]=='h11) begin
     //-- _T0011 case 
     check_cos_latency_bins_and_report(1, 0, 1, ave_latency_0, ave_latency_1, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(1, 2, 3, ave_latency_2, ave_latency_3, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(0, 0, 2, ave_latency_0, ave_latency_2, i_hqm_cfg.perfck_tolerance_2);
  end else if(i_hqm_cfg.perfck_sel[7:0]=='h12) begin
     //-- _T1100 case 
     check_cos_latency_bins_and_report(1, 0, 1, ave_latency_0, ave_latency_1, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(1, 2, 3, ave_latency_2, ave_latency_3, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(0, 2, 0, ave_latency_2, ave_latency_0, i_hqm_cfg.perfck_tolerance_2);
  end else if(i_hqm_cfg.perfck_sel[7:0]=='h13) begin
     //-- _T1110 case
     check_cos_latency_bins_and_report(1, 0, 1, ave_latency_0, ave_latency_1, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(1, 0, 2, ave_latency_0, ave_latency_2, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(0, 3, 0, ave_latency_3, ave_latency_0, i_hqm_cfg.perfck_tolerance_2);
  end else if(i_hqm_cfg.perfck_sel[7:0]=='h14) begin
     //-- _T0111 case
     check_cos_latency_bins_and_report(1, 0, 1, ave_latency_1, ave_latency_2, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(1, 0, 2, ave_latency_1, ave_latency_3, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(0, 0, 3, ave_latency_0, ave_latency_3, i_hqm_cfg.perfck_tolerance_2);
  end else if(i_hqm_cfg.perfck_sel[7:0]=='h15) begin
     //-- _T0123 case 
     check_cos_latency_bins_and_report(0, 0, 1, ave_latency_0, ave_latency_1, i_hqm_cfg.perfck_tolerance_0);
     check_cos_latency_bins_and_report(0, 1, 2, ave_latency_1, ave_latency_2, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(0, 2, 3, ave_latency_2, ave_latency_3, i_hqm_cfg.perfck_tolerance_2);
  end else if(i_hqm_cfg.perfck_sel[7:0]=='h16) begin
     //-- _T3210 case
     check_cos_latency_bins_and_report(0, 1, 0, ave_latency_1, ave_latency_0, i_hqm_cfg.perfck_tolerance_2);
     check_cos_latency_bins_and_report(0, 2, 1, ave_latency_2, ave_latency_1, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(0, 3, 2, ave_latency_3, ave_latency_2, i_hqm_cfg.perfck_tolerance_0);
  end else if(i_hqm_cfg.perfck_sel[7:0]=='h17 ) begin
     //--  _T0110 case
     check_cos_latency_bins_and_report(1, 0, 3, ave_latency_0, ave_latency_3, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(1, 1, 2, ave_latency_1, ave_latency_2, i_hqm_cfg.perfck_tolerance_1);
     check_cos_latency_bins_and_report(0, 0, 2, ave_latency_0, ave_latency_2, i_hqm_cfg.perfck_tolerance_2);

  end 
  
endfunction: check_cos_latency_bins

function void hqm_tb_hcw_scoreboard::check_cos_latency_bins_and_report(int expect_same_perf, int bin_num0, int bin_num1, real ave_latency_0, real ave_latency_1, int tolerance_val);
  int diff_val;

  if(expect_same_perf) begin
     if(ave_latency_0 > ave_latency_1) diff_val = ave_latency_0 - ave_latency_1;
     else                              diff_val = ave_latency_1 - ave_latency_0;
  end else begin
     //-- ave_latency_1 should > ave_latency_0
     diff_val = ave_latency_1 - ave_latency_0;
  end 


  if(expect_same_perf) begin
     if(diff_val > tolerance_val) 
       uvm_report_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("CoS_CKFail_expect_same_perfs: bin=%0d ave_latency=%0d, bin=%0d ave_latency=%0d, diff_val=%0d > tolerance_val=%0d", bin_num0, ave_latency_0, bin_num1, ave_latency_1, diff_val, tolerance_val),UVM_LOW);
  end else begin
     if(diff_val < tolerance_val) 
       uvm_report_warning("HQM_TB_HCW_SCOREBOARD",$psprintf("CoS_CKFail_expect_in_diff_perfs: bin=%0d ave_latency=%0d, bin=%0d ave_latency=%0d, diff_val=%0d < tolerance_val=%0d", bin_num0, ave_latency_0, bin_num1, ave_latency_1, diff_val, tolerance_val),UVM_LOW);
  end 
endfunction: check_cos_latency_bins_and_report
